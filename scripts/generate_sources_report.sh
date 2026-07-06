#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

SRC_A="${OPENCLAW_SRC_A:-}"
SRC_B="${OPENCLAW_SRC_B:-}"
OUT_MD="${ROOT_DIR}/docs/SOURCES.md"

A_REPO="hesamsheikh/awesome-openclaw-usecases"
B_REPO="EvoLinkAI/awesome-openclaw-usecases-moltbook"
A_REPO_URL="https://github.com/${A_REPO}"
B_REPO_URL="https://github.com/${B_REPO}"

usage() {
  cat <<'USAGE' >&2
Usage:
  scripts/generate_sources_report.sh [options] [source_a_repo_dir] [source_b_repo_dir] [output_markdown]

Options:
  --src-a <dir>   Source A repository root directory.
  --src-b <dir>   Source B repository root directory.
  --out <file>    Output markdown path.
  -h, --help      Show help.

Compatibility mode:
  scripts/generate_sources_report.sh <source_a_repo_dir> <source_b_repo_dir> [output_markdown]
USAGE
}

positionals=()
while [[ $# -gt 0 ]]; do
  case "$1" in
    --src-a)
      SRC_A="${2:-}"
      shift 2
      ;;
    --src-b)
      SRC_B="${2:-}"
      shift 2
      ;;
    --out)
      OUT_MD="${2:-}"
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

if [[ ${#positionals[@]} -gt 3 ]]; then
  echo "Error: too many positional arguments." >&2
  usage
  exit 1
fi

if [[ ${#positionals[@]} -ge 1 && -z "$SRC_A" ]]; then
  SRC_A="${positionals[0]}"
fi
if [[ ${#positionals[@]} -ge 2 && -z "$SRC_B" ]]; then
  SRC_B="${positionals[1]}"
fi
if [[ ${#positionals[@]} -ge 3 ]]; then
  OUT_MD="${positionals[2]}"
fi

if [[ -z "$SRC_A" ]]; then
  echo "Error: source A is required" >&2
  usage
  exit 1
fi

if [[ ! -d "$SRC_A/.git" ]]; then
  echo "Error: source A is not a git repository: ${SRC_A}" >&2
  exit 1
fi

HAS_SRC_B=1
if [[ -z "$SRC_B" ]]; then
  HAS_SRC_B=0
elif [[ ! -d "$SRC_B/.git" ]]; then
  echo "Warning: source B is not a git repository: ${SRC_B}, proceeding with source A only" >&2
  HAS_SRC_B=0
fi

latest_commit_short() {
  local repo_dir="$1"
  git -C "$repo_dir" rev-parse --short HEAD
}

latest_commit_date() {
  local repo_dir="$1"
  git -C "$repo_dir" show -s --format='%ci' HEAD
}

latest_commit_subject() {
  local repo_dir="$1"
  git -C "$repo_dir" show -s --format='%s' HEAD
}

detect_license_files() {
  local repo_dir="$1"
  local found

  found="$(find "$repo_dir" -maxdepth 1 -type f \( -iname 'license' -o -iname 'license.*' -o -iname 'copying' -o -iname 'copying.*' \) -print | LC_ALL=C sort | xargs -I{} basename "{}" 2>/dev/null || true)"

  if [[ -z "$found" ]]; then
    printf '%s' "未发现显式许可证文件（以最新上游仓库为准）"
    return
  fi

  printf '%s' "$found" | paste -sd ', ' -
}

GENERATED_AT="${OPENCLAW_GENERATED_AT:-$(date '+%Y-%m-%d %H:%M:%S %Z')}"
A_COMMIT="$(latest_commit_short "$SRC_A")"
A_DATE="$(latest_commit_date "$SRC_A")"
A_SUBJECT="$(latest_commit_subject "$SRC_A")"
A_LICENSE="$(detect_license_files "$SRC_A")"

if [[ $HAS_SRC_B -eq 1 ]]; then
  B_COMMIT="$(latest_commit_short "$SRC_B")"
  B_DATE="$(latest_commit_date "$SRC_B")"
  B_SUBJECT="$(latest_commit_subject "$SRC_B")"
  B_LICENSE="$(detect_license_files "$SRC_B")"
fi

mkdir -p "$(dirname "$OUT_MD")"

{
  echo "# Sources And Attribution"
  echo
  echo "> 自动生成文件，请勿手工编辑。"
  echo
  echo "## Upstream Repositories"
  echo
  echo "1. \`${A_REPO}\`"
  echo "   - URL: ${A_REPO_URL}"
  echo "   - Commit: \`${A_COMMIT}\`"
  echo "   - Commit Date: ${A_DATE}"
  echo "   - Latest Message: ${A_SUBJECT}"
  echo "   - License Files: ${A_LICENSE}"
  echo
  
  if [[ $HAS_SRC_B -eq 1 ]]; then
    echo "2. \`${B_REPO}\`"
    echo "   - URL: ${B_REPO_URL}"
    echo "   - Commit: \`${B_COMMIT}\`"
    echo "   - Commit Date: ${B_DATE}"
    echo "   - Latest Message: ${B_SUBJECT}"
    echo "   - License Files: ${B_LICENSE}"
    echo
  else
    echo "2. \`${B_REPO}\` (unavailable)"
    echo "   - URL: ${B_REPO_URL}"
    echo "   - Status: Repository not accessible"
    echo
  fi
  
  echo "## License Notes"
  echo
  echo "- 本仓库默认只提供索引与回链，不镜像上游全文。"
  echo "- 若上游仓库许可证发生变化，请重新执行同步流程并复核该文档。"
  echo "- 对于无显式许可证文件的上游仓库，建议以保守策略处理，仅保留链接索引。"
  echo
  echo "## Sync Timestamp"
  echo
  echo "- Generated At: ${GENERATED_AT}"
} > "$OUT_MD"

echo "Generated sources report: ${OUT_MD}"
