#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

WORK_DIR=""
KEEP_WORK_DIR=1
REFRESH_EXISTING=1

REPO_A_URL="https://github.com/hesamsheikh/awesome-openclaw-usecases"
REPO_B_URL="https://github.com/EvoLinkAI/awesome-openclaw-usecases-moltbook"

OUT_MD="${ROOT_DIR}/docs/USECASES.md"
OUT_JSON="${ROOT_DIR}/docs/USECASES.json"
OUT_STATS="${ROOT_DIR}/docs/STATS.md"
OUT_SOURCES="${ROOT_DIR}/docs/SOURCES.md"
OUT_DIFF_MD="${ROOT_DIR}/docs/DIFF.md"
OUT_DIFF_JSON="${ROOT_DIR}/docs/DIFF.json"
OUT_QUICKSTART_MD="${ROOT_DIR}/docs/QUICKSTARTS.md"
OUT_QUICKSTART_JSON="${ROOT_DIR}/docs/QUICKSTARTS.json"

usage() {
  cat <<'USAGE' >&2
Usage:
  scripts/fetch_and_build.sh [options] [work_dir]

Options:
  --work-dir <dir>       Working directory for upstream repositories.
  --clean-work-dir       Remove working directory when done.
  --keep-work-dir        Keep working directory (default).
  --no-refresh           Reuse existing clones without fetch/reset.
  --repo-a-url <url>     Override source A repository URL.
  --repo-b-url <url>     Override source B repository URL.
  --out-md <file>        Output markdown index path.
  --out-json <file>      Output JSON index path.
  --out-stats <file>     Output stats markdown path.
  --out-sources <file>   Output source report path.
  --out-diff-md <file>   Output diff markdown path.
  --out-diff-json <file> Output diff JSON path.
  --out-quickstart-md <file>   Output quickstarts markdown path.
  --out-quickstart-json <file> Output quickstarts JSON path.
  -h, --help             Show help.

Compatibility mode:
  scripts/fetch_and_build.sh [work_dir]
USAGE
}

positionals=()
while [[ $# -gt 0 ]]; do
  case "$1" in
    --work-dir)
      WORK_DIR="${2:-}"
      shift 2
      ;;
    --clean-work-dir)
      KEEP_WORK_DIR=0
      shift
      ;;
    --keep-work-dir)
      KEEP_WORK_DIR=1
      shift
      ;;
    --no-refresh)
      REFRESH_EXISTING=0
      shift
      ;;
    --repo-a-url)
      REPO_A_URL="${2:-}"
      shift 2
      ;;
    --repo-b-url)
      REPO_B_URL="${2:-}"
      shift 2
      ;;
    --out-md)
      OUT_MD="${2:-}"
      shift 2
      ;;
    --out-json)
      OUT_JSON="${2:-}"
      shift 2
      ;;
    --out-stats)
      OUT_STATS="${2:-}"
      shift 2
      ;;
    --out-sources)
      OUT_SOURCES="${2:-}"
      shift 2
      ;;
    --out-diff-md)
      OUT_DIFF_MD="${2:-}"
      shift 2
      ;;
    --out-diff-json)
      OUT_DIFF_JSON="${2:-}"
      shift 2
      ;;
    --out-quickstart-md)
      OUT_QUICKSTART_MD="${2:-}"
      shift 2
      ;;
    --out-quickstart-json)
      OUT_QUICKSTART_JSON="${2:-}"
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    --)
      shift
      while [[ $# -gt 0 ]]; do
        positionals+=("$1")
        shift
      done
      ;;
    -*)
      echo "Error: unknown option: $1" >&2
      usage
      exit 1
      ;;
    *)
      positionals+=("$1")
      shift
      ;;
  esac
done

if [[ ${#positionals[@]} -gt 1 ]]; then
  echo "Error: too many positional arguments." >&2
  usage
  exit 1
fi

if [[ ${#positionals[@]} -eq 1 && -z "$WORK_DIR" ]]; then
  WORK_DIR="${positionals[0]}"
fi

AUTO_WORK_DIR=0
if [[ -z "$WORK_DIR" ]]; then
  WORK_DIR="$(mktemp -d /tmp/openclaw-usecases-cn-src-XXXXXX)"
  AUTO_WORK_DIR=1
fi

if [[ -e "$WORK_DIR" && ! -d "$WORK_DIR" ]]; then
  echo "Error: work dir exists and is not a directory: ${WORK_DIR}" >&2
  exit 1
fi

mkdir -p "$WORK_DIR"

OLD_JSON_SNAPSHOT="$(mktemp /tmp/openclaw-usecases-prev-json-XXXXXX)"
if [[ -f "$OUT_JSON" ]]; then
  cp "$OUT_JSON" "$OLD_JSON_SNAPSHOT"
else
  cat > "$OLD_JSON_SNAPSHOT" <<'JSON'
{"generated_at":"","usecases":[]}
JSON
fi

cleanup() {
  if [[ -n "${OLD_JSON_SNAPSHOT:-}" && -f "$OLD_JSON_SNAPSHOT" ]]; then
    rm -f "$OLD_JSON_SNAPSHOT"
  fi

  if [[ "$KEEP_WORK_DIR" -eq 0 && -n "${WORK_DIR:-}" && -d "$WORK_DIR" ]]; then
    rm -rf "$WORK_DIR"
  fi
}
trap cleanup EXIT

SRC_A="${WORK_DIR}/awesome-openclaw-usecases"
SRC_B="${WORK_DIR}/awesome-openclaw-usecases-moltbook"

resolve_default_remote_ref() {
  local repo_dir="$1"
  local ref

  ref="$(git -C "$repo_dir" symbolic-ref -q refs/remotes/origin/HEAD || true)"
  if [[ -n "$ref" ]]; then
    printf '%s' "$ref"
    return
  fi

  if git -C "$repo_dir" show-ref --verify --quiet refs/remotes/origin/main; then
    printf '%s' "refs/remotes/origin/main"
    return
  fi

  if git -C "$repo_dir" show-ref --verify --quiet refs/remotes/origin/master; then
    printf '%s' "refs/remotes/origin/master"
    return
  fi

  echo ""
}

sync_repo() {
  local repo_url="$1"
  local repo_dir="$2"

  if [[ -d "${repo_dir}/.git" ]]; then
    if [[ "$REFRESH_EXISTING" -eq 0 ]]; then
      echo "Using existing repository without refresh: ${repo_dir}"
      return 0
    fi

    echo "Refreshing existing repository: ${repo_dir}"
    if ! git -C "$repo_dir" fetch --depth 1 origin 2>/dev/null; then
      echo "Warning: failed to refresh ${repo_dir}, skipping" >&2
      return 1
    fi

    default_ref="$(resolve_default_remote_ref "$repo_dir")"
    if [[ -z "$default_ref" ]]; then
      echo "Warning: unable to resolve origin default branch for ${repo_dir}, skipping" >&2
      return 1
    fi

    git -C "$repo_dir" reset --hard "$default_ref"
    git -C "$repo_dir" clean -fd
    return 0
  fi

  if [[ -e "$repo_dir" ]]; then
    echo "Error: target exists but is not a git repository: ${repo_dir}" >&2
    return 1
  fi

  echo "Cloning repository: ${repo_url}"
  if ! git clone --depth 1 "$repo_url" "$repo_dir" 2>/dev/null; then
    echo "Warning: failed to clone ${repo_url}, skipping" >&2
    return 1
  fi
  return 0
}

sync_repo "$REPO_A_URL" "$SRC_A" || { echo "Fatal: failed to sync source A" >&2; exit 1; }
sync_repo "$REPO_B_URL" "$SRC_B" || echo "Source B unavailable, proceeding with source A only"

"${ROOT_DIR}/scripts/generate_usecases_index.sh" \
  --src-a "$SRC_A" \
  --src-b "$SRC_B" \
  --out-md "$OUT_MD" \
  --out-json "$OUT_JSON" \
  --out-stats "$OUT_STATS"

"${ROOT_DIR}/scripts/generate_sources_report.sh" \
  --src-a "$SRC_A" \
  --src-b "$SRC_B" \
  --out "$OUT_SOURCES"

"${ROOT_DIR}/scripts/generate_usecases_diff.sh" \
  --old "$OLD_JSON_SNAPSHOT" \
  --new "$OUT_JSON" \
  --out-md "$OUT_DIFF_MD" \
  --out-json "$OUT_DIFF_JSON"

"${ROOT_DIR}/scripts/generate_quickstarts.sh" \
  --index "$OUT_JSON" \
  --out-md "$OUT_QUICKSTART_MD" \
  --out-json "$OUT_QUICKSTART_JSON" \
  --top 20

echo "Done."
echo "Index markdown: ${OUT_MD}"
echo "Index JSON: ${OUT_JSON}"
echo "Statistics: ${OUT_STATS}"
echo "Sources report: ${OUT_SOURCES}"
echo "Diff markdown: ${OUT_DIFF_MD}"
echo "Diff JSON: ${OUT_DIFF_JSON}"
echo "Quickstarts markdown: ${OUT_QUICKSTART_MD}"
echo "Quickstarts JSON: ${OUT_QUICKSTART_JSON}"

if [[ "$KEEP_WORK_DIR" -eq 1 ]]; then
  echo "Source cache: ${WORK_DIR}"
elif [[ "$AUTO_WORK_DIR" -eq 0 ]]; then
  echo "Source cache removed: ${WORK_DIR}"
fi
