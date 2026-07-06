#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

SRC_A="${OPENCLAW_SRC_A:-}"
SRC_B="${OPENCLAW_SRC_B:-}"
OUT_MD=""
OUT_JSON=""
OUT_STATS=""

A_REPO="hesamsheikh/awesome-openclaw-usecases"
B_REPO="EvoLinkAI/awesome-openclaw-usecases-moltbook"
A_URL="https://github.com/${A_REPO}/blob/main/usecases"
B_URL="https://github.com/${B_REPO}/blob/main/usecases"

usage() {
  cat <<'USAGE' >&2
Usage:
  scripts/generate_usecases_index.sh [options] [source_a_repo_dir] [source_b_repo_dir] [output_markdown]

Options:
  --src-a <dir>       Source A repository root directory.
  --src-b <dir>       Source B repository root directory.
  --out-md <file>     Markdown index output file.
  --out-json <file>   JSON index output file.
  --out-stats <file>  Statistics markdown output file.
  -h, --help          Show help.

Compatibility mode:
  scripts/generate_usecases_index.sh <source_a_repo_dir> <source_b_repo_dir> [output_markdown]

Environment fallback:
  OPENCLAW_SRC_A=/path/to/awesome-openclaw-usecases
  OPENCLAW_SRC_B=/path/to/awesome-openclaw-usecases-moltbook
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
if [[ ${#positionals[@]} -ge 3 && -z "$OUT_MD" ]]; then
  OUT_MD="${positionals[2]}"
fi

if [[ -z "$OUT_MD" ]]; then
  OUT_MD="$ROOT_DIR/docs/USECASES.md"
fi
if [[ -z "$OUT_JSON" ]]; then
  OUT_JSON="$(dirname "$OUT_MD")/$(basename "$OUT_MD" .md).json"
fi
if [[ -z "$OUT_STATS" ]]; then
  OUT_STATS="$(dirname "$OUT_MD")/STATS.md"
fi

if [[ -z "$SRC_A" ]]; then
  echo "Error: source A is required" >&2
  usage
  exit 1
fi

A_DIR="${SRC_A}/usecases"
B_DIR=""

if [[ ! -d "$A_DIR" ]]; then
  echo "Error: missing directory: ${A_DIR}" >&2
  exit 1
fi

if [[ -n "$SRC_B" ]]; then
  B_DIR="${SRC_B}/usecases"
  if [[ ! -d "$B_DIR" ]]; then
    echo "Warning: source B directory not found: ${B_DIR}, proceeding with source A only" >&2
    B_DIR=""
  fi
fi

escape_pipe() {
  printf '%s' "$1" | sed 's/|/\\|/g'
}

json_escape() {
  local value="$1"
  value="${value//\\/\\\\}"
  value="${value//\"/\\\"}"
  value="${value//$'\n'/\\n}"
  value="${value//$'\r'/\\r}"
  value="${value//$'\t'/\\t}"
  printf '%s' "$value"
}

detect_source_license_status() {
  local source_root="$1"
  local found

  found="$(find "$source_root" -maxdepth 1 -type f \( -iname 'license' -o -iname 'license.*' -o -iname 'copying' -o -iname 'copying.*' \) -print -quit)"
  if [[ -n "$found" ]]; then
    printf '%s' "explicit_license"
    return
  fi

  printf '%s' "missing_explicit_license"
}

extract_title_with_flag() {
  local file="$1"
  local title
  local has_heading

  title="$(awk '/^# /{sub(/^# /, ""); print; exit}' "$file")"
  has_heading=1

  if [[ -z "$title" ]]; then
    title="$(basename "$file" .md | tr '-' ' ')"
    has_heading=0
  fi

  title="$(printf '%s' "$title" | tr '\t\r\n' '   ' | sed 's/  */ /g; s/^ //; s/ $//')"
  printf '%s\t%s\n' "$title" "$has_heading"
}

classify_usecase() {
  local title="$1"
  local path="$2"
  local text

  text="$(printf '%s %s' "$title" "$path" | tr '[:upper:]' '[:lower:]')"

  case "$text" in
    *security*|*credential*|*secret*|*scanner*|*audit*|*ctf*|*exploit*|*keychain*)
      printf '%s' "安全"
      ;;
    *infra*|*server*|*dashboard*|*cron*|*health*|*monitor*|*tracing*|*workflow*|*devops*)
      printf '%s' "开发运维"
      ;;
    *content*|*podcast*|*youtube*|*newsletter*|*social*|*instagram*|*story*|*marketing*)
      printf '%s' "内容增长"
      ;;
    *trade*|*market*|*wallet*|*bitcoin*|*polymarket*|*price*|*crypto*|*earnings*)
      printf '%s' "投资交易"
      ;;
    *calendar*|*assistant*|*task*|*todo*|*crm*|*brief*|*digest*|*reminder*|*booking*)
      printf '%s' "效率自动化"
      ;;
    *learning*|*tutor*|*journal*|*knowledge*|*memory*|*research*)
      printf '%s' "学习知识"
      ;;
    *family*|*health*|*travel*|*weather*|*homework*|*home*)
      printf '%s' "生活方式"
      ;;
    *)
      printf '%s' "通用"
      ;;
  esac
}

assess_security_risk() {
  local category="$1"
  local title="$2"
  local path="$3"
  local text

  text="$(printf '%s %s' "$title" "$path" | tr '[:upper:]' '[:lower:]')"

  if [[ "$category" == "安全" ]] || [[ "$text" == *credential* ]] || [[ "$text" == *secret* ]] || [[ "$text" == *token* ]] || [[ "$text" == *keychain* ]] || [[ "$text" == *ctf* ]] || [[ "$text" == *exploit* ]] || [[ "$text" == *scanner* ]]; then
    printf '%s' "high"
    return
  fi

  if [[ "$category" == "投资交易" ]] || [[ "$text" == *wallet* ]] || [[ "$text" == *bitcoin* ]] || [[ "$text" == *crypto* ]] || [[ "$text" == *trade* ]] || [[ "$text" == *market* ]]; then
    printf '%s' "medium"
    return
  fi

  printf '%s' "low"
}

clamp_score() {
  local score="$1"
  if (( score < 0 )); then
    printf '%s' "0"
    return
  fi
  if (( score > 100 )); then
    printf '%s' "100"
    return
  fi
  printf '%s' "$score"
}

calculate_source_confidence() {
  local license_status="$1"
  local has_heading="$2"
  local security_risk="$3"
  local score

  if [[ "$license_status" == "explicit_license" ]]; then
    score=72
  else
    score=55
  fi

  if [[ "$has_heading" -eq 1 ]]; then
    score=$((score + 10))
  fi

  case "$security_risk" in
    high) score=$((score - 12)) ;;
    medium) score=$((score - 6)) ;;
  esac

  clamp_score "$score"
}

calculate_reproducibility_score() {
  local license_status="$1"
  local has_heading="$2"
  local security_risk="$3"
  local category="$4"
  local score

  if [[ "$has_heading" -eq 1 ]]; then
    score=72
  else
    score=60
  fi

  if [[ "$license_status" == "missing_explicit_license" ]]; then
    score=$((score - 15))
  fi

  case "$security_risk" in
    high) score=$((score - 20)) ;;
    medium) score=$((score - 10)) ;;
  esac

  case "$category" in
    开发运维|效率自动化|学习知识)
      score=$((score + 6))
      ;;
  esac

  clamp_score "$score"
}

percent() {
  local part="$1"
  local total="$2"
  awk -v p="$part" -v t="$total" 'BEGIN { if (t == 0) { printf "0.0" } else { printf "%.1f", (p * 100) / t } }'
}

source_license_status() {
  local source="$1"
  if [[ "$source" == "A" ]]; then
    printf '%s' "$A_LICENSE_STATUS"
  else
    printf '%s' "$B_LICENSE_STATUS"
  fi
}

A_LICENSE_STATUS="$(detect_source_license_status "$SRC_A")"
B_LICENSE_STATUS="$(detect_source_license_status "$SRC_B")"

tmp_dir="$(mktemp -d /tmp/openclaw-usecases-index-XXXXXX)"
trap 'rm -rf "$tmp_dir"' EXIT

A_TSV="$tmp_dir/source_a.tsv"
B_TSV="$tmp_dir/source_b.tsv"
ALL_TSV="$tmp_dir/all.tsv"

: > "$A_TSV"
: > "$B_TSV"
: > "$ALL_TSV"

idx=1
while IFS= read -r file; do
  [[ -n "$file" ]] || continue

  base="$(basename "$file")"
  rel="usecases/${base}"

  IFS=$'\t' read -r title has_heading < <(extract_title_with_flag "$file")
  category="$(classify_usecase "$title" "$base")"
  risk="$(assess_security_risk "$category" "$title" "$base")"
  license_status="$(source_license_status "A")"
  confidence="$(calculate_source_confidence "$license_status" "$has_heading" "$risk")"
  reproducibility="$(calculate_reproducibility_score "$license_status" "$has_heading" "$risk" "$category")"
  url="${A_URL}/${base}"

  printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n' \
    "A" "$idx" "$title" "$base" "$rel" "$url" "$category" "$license_status" "$confidence" "$risk" "$reproducibility" >> "$A_TSV"
  printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n' \
    "A" "$idx" "$title" "$base" "$rel" "$url" "$category" "$license_status" "$confidence" "$risk" "$reproducibility" >> "$ALL_TSV"

  idx=$((idx + 1))
done < <(find "$A_DIR" -maxdepth 1 -type f -name '*.md' | LC_ALL=C sort)

idx=1
if [[ -n "$B_DIR" ]]; then
  while IFS= read -r file; do
    [[ -n "$file" ]] || continue

    base="$(basename "$file")"
    rel="usecases/${base}"

    IFS=$'\t' read -r title has_heading < <(extract_title_with_flag "$file")
    category="$(classify_usecase "$title" "$base")"
    risk="$(assess_security_risk "$category" "$title" "$base")"
    license_status="$(source_license_status "B")"
    confidence="$(calculate_source_confidence "$license_status" "$has_heading" "$risk")"
    reproducibility="$(calculate_reproducibility_score "$license_status" "$has_heading" "$risk" "$category")"
    url="${B_URL}/${base}"

    printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n' \
      "B" "$idx" "$title" "$base" "$rel" "$url" "$category" "$license_status" "$confidence" "$risk" "$reproducibility" >> "$B_TSV"
    printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n' \
      "B" "$idx" "$title" "$base" "$rel" "$url" "$category" "$license_status" "$confidence" "$risk" "$reproducibility" >> "$ALL_TSV"

    idx=$((idx + 1))
  done < <(find "$B_DIR" -maxdepth 1 -type f -name '*.md' ! -name 'TEMPLATE.md' | LC_ALL=C sort)
fi

A_COUNT="$(wc -l < "$A_TSV" | tr -d ' ')"
B_COUNT="$(wc -l < "$B_TSV" | tr -d ' ')"
TOTAL_COUNT="$((A_COUNT + B_COUNT))"
GENERATED_AT="${OPENCLAW_GENERATED_AT:-$(date '+%Y-%m-%d %H:%M:%S %Z')}"

mkdir -p "$(dirname "$OUT_MD")"
mkdir -p "$(dirname "$OUT_JSON")"
mkdir -p "$(dirname "$OUT_STATS")"

print_md_rows() {
  local tsv_file="$1"
  while IFS=$'\t' read -r source index title base rel url category license_status confidence risk reproducibility; do
    printf '| %s | %s | [查看](%s) | `%s` | `%s` | `%s` | %s | %s |\n' \
      "$index" "$(escape_pipe "$title")" "$url" "$rel" "$category" "$risk" "$confidence" "$reproducibility"
  done < "$tsv_file"
}

{
  echo "# OpenClaw Usecases 中文总索引"
  echo
  echo "> 自动生成文件，请勿手工编辑。"
  echo
  echo "- 生成时间: ${GENERATED_AT}"
  echo "- 来源 A: \`${A_REPO}\` (${A_COUNT})"
  echo "- 来源 B: \`${B_REPO}\` (${B_COUNT})"
  echo "- 总计: ${TOTAL_COUNT}"
  echo "- 机器可读索引: \`$(basename "$OUT_JSON")\`"
  echo
  echo "## 来源 A（社区合集）"
  echo
  echo "| # | 用例 | 上游链接 | 相对路径 | 分类 | 风险 | 可信度 | 可复现性 |"
  echo "|---|---|---|---|---|---|---:|---:|"
  print_md_rows "$A_TSV"
  echo
  echo "## 来源 B（Moltbook）"
  echo
  echo "| # | 用例 | 上游链接 | 相对路径 | 分类 | 风险 | 可信度 | 可复现性 |"
  echo "|---|---|---|---|---|---|---:|---:|"
  print_md_rows "$B_TSV"
} > "$OUT_MD"

{
  echo "{"
  printf '  "generated_at": "%s",\n' "$(json_escape "$GENERATED_AT")"
  echo '  "scoring_model": {'
  echo '    "license_status": "explicit_license | missing_explicit_license",'
  echo '    "source_confidence": "0-100, based on source license presence + heading quality + risk penalty",'
  echo '    "security_risk": "low | medium | high, heuristic by category and keywords",'
  echo '    "reproducibility_score": "0-100, based on heading quality + legal clarity + risk penalty + category bonus"'
  echo '  },'
  echo "  \"totals\": {"
  printf '    "source_a": %s,\n' "$A_COUNT"
  printf '    "source_b": %s,\n' "$B_COUNT"
  printf '    "overall": %s\n' "$TOTAL_COUNT"
  echo "  },"
  echo "  \"sources\": ["
  printf '    {"id": "A", "repo": "%s", "url": "%s", "count": %s, "license_status": "%s"},\n' \
    "$(json_escape "$A_REPO")" "$(json_escape "https://github.com/${A_REPO}")" "$A_COUNT" "$(json_escape "$A_LICENSE_STATUS")"
  printf '    {"id": "B", "repo": "%s", "url": "%s", "count": %s, "license_status": "%s"}\n' \
    "$(json_escape "$B_REPO")" "$(json_escape "https://github.com/${B_REPO}")" "$B_COUNT" "$(json_escape "$B_LICENSE_STATUS")"
  echo "  ],"
  echo "  \"usecases\": ["

  line_no=0
  while IFS=$'\t' read -r source index title base rel url category license_status confidence risk reproducibility; do
    if [[ "$line_no" -gt 0 ]]; then
      echo ","
    fi
    printf '    {"source": "%s", "index": %s, "title": "%s", "path": "%s", "url": "%s", "category": "%s", "license_status": "%s", "source_confidence": %s, "security_risk": "%s", "reproducibility_score": %s}' \
      "$(json_escape "$source")" \
      "$index" \
      "$(json_escape "$title")" \
      "$(json_escape "$rel")" \
      "$(json_escape "$url")" \
      "$(json_escape "$category")" \
      "$(json_escape "$license_status")" \
      "$confidence" \
      "$(json_escape "$risk")" \
      "$reproducibility"
    line_no=$((line_no + 1))
  done < "$ALL_TSV"

  echo
  echo "  ]"
  echo "}"
} > "$OUT_JSON"

UNIQUE_TITLE_COUNT="$(awk -F '\t' '
  {
    k = tolower($3)
    gsub(/[^a-z0-9]/, "", k)
    if (!(k in seen)) {
      seen[k] = 1
      unique++
    }
  }
  END { print unique + 0 }
' "$ALL_TSV")"

DUPLICATE_TITLE_COUNT="$((TOTAL_COUNT - UNIQUE_TITLE_COUNT))"

CATEGORY_RANK="$tmp_dir/category_rank.tsv"
RISK_RANK="$tmp_dir/risk_rank.tsv"
LICENSE_RANK="$tmp_dir/license_rank.tsv"

awk -F '\t' '{ count[$7]++ } END { for (k in count) printf "%s\t%d\n", k, count[k] }' "$ALL_TSV" \
  | LC_ALL=C sort -t $'\t' -k2,2nr -k1,1 > "$CATEGORY_RANK"

awk -F '\t' '{ count[$10]++ } END { for (k in count) printf "%s\t%d\n", k, count[k] }' "$ALL_TSV" \
  | LC_ALL=C sort -t $'\t' -k2,2nr -k1,1 > "$RISK_RANK"

awk -F '\t' '{ count[$8]++ } END { for (k in count) printf "%s\t%d\n", k, count[k] }' "$ALL_TSV" \
  | LC_ALL=C sort -t $'\t' -k2,2nr -k1,1 > "$LICENSE_RANK"

AVG_CONFIDENCE="$(awk -F '\t' '{ sum += $9; n += 1 } END { if (n == 0) print "0.0"; else printf "%.1f", sum / n }' "$ALL_TSV")"
AVG_REPRODUCIBILITY="$(awk -F '\t' '{ sum += $11; n += 1 } END { if (n == 0) print "0.0"; else printf "%.1f", sum / n }' "$ALL_TSV")"

{
  echo "# OpenClaw Usecases 统计"
  echo
  echo "> 自动生成文件，请勿手工编辑。"
  echo
  echo "- 生成时间: ${GENERATED_AT}"
  echo "- 来源 A: ${A_COUNT}"
  echo "- 来源 B: ${B_COUNT}"
  echo "- 总计: ${TOTAL_COUNT}"
  echo "- 归一化后唯一标题: ${UNIQUE_TITLE_COUNT}"
  echo "- 潜在重复标题: ${DUPLICATE_TITLE_COUNT}"
  echo "- 平均可信度: ${AVG_CONFIDENCE}"
  echo "- 平均可复现性: ${AVG_REPRODUCIBILITY}"
  echo
  echo "## 分类分布"
  echo
  echo "| 分类 | 数量 | 占比 |"
  echo "|---|---:|---:|"
  while IFS=$'\t' read -r category count; do
    [[ -n "$category" ]] || continue
    printf '| %s | %s | %s%% |\n' "$category" "$count" "$(percent "$count" "$TOTAL_COUNT")"
  done < "$CATEGORY_RANK"
  echo
  echo "## 风险分布"
  echo
  echo "| 风险 | 数量 | 占比 |"
  echo "|---|---:|---:|"
  while IFS=$'\t' read -r risk count; do
    [[ -n "$risk" ]] || continue
    printf '| %s | %s | %s%% |\n' "$risk" "$count" "$(percent "$count" "$TOTAL_COUNT")"
  done < "$RISK_RANK"
  echo
  echo "## License 状态分布"
  echo
  echo "| 状态 | 数量 | 占比 |"
  echo "|---|---:|---:|"
  while IFS=$'\t' read -r license_status count; do
    [[ -n "$license_status" ]] || continue
    printf '| %s | %s | %s%% |\n' "$license_status" "$count" "$(percent "$count" "$TOTAL_COUNT")"
  done < "$LICENSE_RANK"
  echo
  echo "## 来源占比"
  echo
  echo "| 来源 | 数量 | 占比 |"
  echo "|---|---:|---:|"
  printf '| %s | %s | %s%% |\n' "$A_REPO" "$A_COUNT" "$(percent "$A_COUNT" "$TOTAL_COUNT")"
  printf '| %s | %s | %s%% |\n' "$B_REPO" "$B_COUNT" "$(percent "$B_COUNT" "$TOTAL_COUNT")"
} > "$OUT_STATS"

echo "Generated markdown: ${OUT_MD}"
echo "Generated json: ${OUT_JSON}"
echo "Generated stats: ${OUT_STATS}"
