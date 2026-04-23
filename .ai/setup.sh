#!/usr/bin/env bash
# .ai/setup.sh — Wire .ai/skills to agent-native skill directories
#
# Creates symlinks so AI tools can discover skills from .ai/skills/ as native slash commands.
# Run once after cloning or after adding a new skill.
#
# Usage:
#   bash .ai/setup.sh           # Set up for all supported agents (currently: claude, junie, cline)
#   bash .ai/setup.sh claude    # Set up for Claude Code only
#   bash .ai/setup.sh junie     # Set up for Junie only
#   bash .ai/setup.sh cline     # Set up for Cline only
#
# Supported agents:
#   claude  → .claude/skills/<name> → .ai/skills/<name>/
#   junie   → .junie/skills/<name>  → .ai/skills/<name>/
#   cline   → .cline/skills/<name>  → .ai/skills/<name>/

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SKILL_SRC="$REPO_ROOT/.ai/skills"
AGENTS=("$@")
[ ${#AGENTS[@]} -eq 0 ] && AGENTS=(claude junie cline)

setup_claude() {
  local target_dir="$REPO_ROOT/.claude/skills"
  mkdir -p "$target_dir"
  echo "Setting up Claude Code skills → $target_dir"

  for skill_dir in "$SKILL_SRC"/*/; do
    [ -d "$skill_dir" ] || continue
    [ -f "$skill_dir/SKILL.md" ] || continue

    local skill_name
    skill_name=$(basename "$skill_dir")
    local link="$target_dir/$skill_name"

    # Relative path from .claude/skills/ to .ai/skills/<name>/
    local rel_path="../../.ai/skills/$skill_name"

    if [ -L "$link" ]; then
      rm "$link"
    elif [ -e "$link" ]; then
      echo "  SKIP  $skill_name (exists and is not a symlink — remove manually to re-link)"
      continue
    fi

    ln -s "$rel_path" "$link"
    echo "  LINK  .claude/skills/$skill_name → .ai/skills/$skill_name"
  done
}

setup_junie() {
  local target_dir="$REPO_ROOT/.junie/skills"
  mkdir -p "$target_dir"
  echo "Setting up Junie skills → $target_dir"

  for skill_dir in "$SKILL_SRC"/*/; do
    [ -d "$skill_dir" ] || continue
    [ -f "$skill_dir/SKILL.md" ] || continue

    local skill_name
    skill_name=$(basename "$skill_dir")
    local link="$target_dir/$skill_name"

    # Relative path from .junie/skills/ to .ai/skills/<name>/
    local rel_path="../../.ai/skills/$skill_name"

    if [ -L "$link" ]; then
      rm "$link"
    elif [ -e "$link" ]; then
      echo "  SKIP  $skill_name (exists and is not a symlink — remove manually to re-link)"
      continue
    fi

    ln -s "$rel_path" "$link"
    echo "  LINK  .junie/skills/$skill_name → .ai/skills/$skill_name"
  done
}

setup_cline() {
  local target_dir="$REPO_ROOT/.cline/skills"
  mkdir -p "$target_dir"
  echo "Setting up Cline skills → $target_dir"

  for skill_dir in "$SKILL_SRC"/*/; do
    [ -d "$skill_dir" ] || continue
    [ -f "$skill_dir/SKILL.md" ] || continue

    local skill_name
    skill_name=$(basename "$skill_dir")
    local link="$target_dir/$skill_name"

    # Relative path from .cline/skills/ to .ai/skills/<name>/
    local rel_path="../../.ai/skills/$skill_name"

    if [ -L "$link" ]; then
      rm "$link"
    elif [ -e "$link" ]; then
      echo "  SKIP  $skill_name (exists and is not a symlink — remove manually to re-link)"
      continue
    fi

    ln -s "$rel_path" "$link"
    echo "  LINK  .cline/skills/$skill_name → .ai/skills/$skill_name"
  done
}

for agent in "${AGENTS[@]}"; do
  case "$agent" in
    claude) setup_claude ;;
    junie) setup_junie ;;
    cline) setup_cline ;;
    *) echo "Unknown agent: $agent (supported: claude, junie, cline)" ;;
  esac
done

echo ""
echo "Done. Skills available as slash commands:"
for skill_dir in "$SKILL_SRC"/*/; do
  [ -f "$skill_dir/SKILL.md" ] || continue
  skill_name=$(basename "$skill_dir")
  echo "  /$skill_name"
done
