#!/usr/bin/env bash
# .ai/setup.sh — Wire .ai/skills and .ai/commands to agent-native directories
#
# Creates symlinks so AI tools can discover skills from .ai/skills/ and commands
# from .ai/commands/ as native slash commands.
# Run once after cloning or after adding a new skill/command.
#
# Usage:
#   bash .ai/setup.sh           # Set up for all supported agents (currently: claude, junie, cline)
#   bash .ai/setup.sh claude    # Set up for Claude Code only
#   bash .ai/setup.sh junie     # Set up for Junie only
#   bash .ai/setup.sh cline     # Set up for Cline only
#
# Supported agents:
#   claude  → .claude/skills/<name>/SKILL.md (skills) + .claude/skills/<name>/SKILL.md (commands wrapped)
#   junie   → .junie/skills/<name>.md (skills) + .junie/commands/<name>.md (commands)
#   cline   → .cline/skills/<name> (skills) + .cline/skills/<name>/SKILL.md (commands wrapped)

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SKILL_SRC="$REPO_ROOT/.ai/skills"
COMMAND_SRC="$REPO_ROOT/.ai/commands"
AGENTS=("$@")
[ ${#AGENTS[@]} -eq 0 ] && AGENTS=(claude junie cline)

setup_agent() {
  local agent=$1
  local dot_name=".$agent"

  local skill_target="$REPO_ROOT/$dot_name/skills"
  local cmd_target="$REPO_ROOT/$dot_name/commands"

  mkdir -p "$skill_target"
  # Only create commands folder for junie — others use skills/ for everything
  if [ "$agent" == "junie" ]; then
    mkdir -p "$cmd_target"
  fi
  echo "Setting up $agent skills & commands"

  # 1. Process structured skills (.ai/skills/NAME/SKILL.md)
  if [ -d "$SKILL_SRC" ]; then
    for skill_dir in "$SKILL_SRC"/*/; do
      [ -d "$skill_dir" ] || continue
      [ -f "$skill_dir/SKILL.md" ] || continue

      local skill_name
      skill_name=$(basename "$skill_dir")

      if [ "$agent" == "junie" ]; then
        local link="$skill_target/$skill_name.md"
        local rel_path="../../.ai/skills/$skill_name/SKILL.md"
        if [ -L "$link" ]; then rm "$link"; elif [ -e "$link" ]; then echo "  SKIP  skills/$skill_name.md (exists)"; continue; fi
        ln -s "$rel_path" "$link"
        echo "  LINK  $dot_name/skills/$skill_name.md → .ai/skills/$skill_name/SKILL.md"
      else
        local link="$skill_target/$skill_name"
        local rel_path="../../.ai/skills/$skill_name"
        if [ -L "$link" ]; then rm "$link"; elif [ -e "$link" ]; then echo "  SKIP  skills/$skill_name (exists)"; continue; fi
        ln -s "$rel_path" "$link"
        echo "  LINK  $dot_name/skills/$skill_name → .ai/skills/$skill_name"
      fi
    done
  fi

  # 2. Process flat commands (.ai/commands/NAME.md)
  if [ -d "$COMMAND_SRC" ]; then
    for cmd_file in "$COMMAND_SRC"/*.md; do
      [ -f "$cmd_file" ] || continue

      local cmd_name
      cmd_name=$(basename "$cmd_file" .md)

      if [ "$agent" == "junie" ]; then
        local link="$cmd_target/$cmd_name.md"
        local rel_path="../../.ai/commands/$cmd_name.md"
        if [ -L "$link" ]; then rm "$link"; elif [ -e "$link" ]; then echo "  SKIP  commands/$cmd_name.md (exists)"; continue; fi
        ln -s "$rel_path" "$link"
        echo "  LINK  $dot_name/commands/$cmd_name.md → .ai/commands/$cmd_name.md"
      else
        # Claude/Cline: wrap command in a skill folder (skills/<name>/SKILL.md)
        local skill_dir_target="$skill_target/$cmd_name"
        local link="$skill_dir_target/SKILL.md"
        local rel_path="../../../.ai/commands/$cmd_name.md"

        # Clean up if it was a plain symlink from an older setup.sh
        if [ -L "$skill_dir_target" ]; then rm "$skill_dir_target"; fi

        mkdir -p "$skill_dir_target"

        if [ -L "$link" ]; then rm "$link"; elif [ -e "$link" ]; then echo "  SKIP  skills/$cmd_name/SKILL.md (exists)"; continue; fi
        ln -s "$rel_path" "$link"
        echo "  LINK  $dot_name/skills/$cmd_name/SKILL.md → .ai/commands/$cmd_name.md"
      fi
    done
  fi
}

for agent in "${AGENTS[@]}"; do
  case "$agent" in
    claude|junie|cline) setup_agent "$agent" ;;
    *) echo "Unknown agent: $agent (supported: claude, junie, cline)" ;;
  esac
done

echo ""
echo "Done. Available slash commands:"
if [ -d "$SKILL_SRC" ]; then
  for skill_dir in "$SKILL_SRC"/*/; do
    [ -f "$skill_dir/SKILL.md" ] || continue
    echo "  /$(basename "$skill_dir")  (skill)"
  done
fi
if [ -d "$COMMAND_SRC" ]; then
  for cmd_file in "$COMMAND_SRC"/*.md; do
    [ -f "$cmd_file" ] || continue
    echo "  /$(basename "$cmd_file" .md)  (command)"
  done
fi
