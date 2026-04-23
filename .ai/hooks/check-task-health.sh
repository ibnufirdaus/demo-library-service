#!/bin/bash
# check-task-health.sh: Verifies the integrity of active task folders in .ai/tasks/
# and checks that agent skill directories are proper symlinks (not stale real directories).

echo "[Harness] Checking Task Health..."

TASKS_DIR=".ai/tasks"
FOUND=0

for TASK_DIR in "$TASKS_DIR"/*/; do
    # Skip the archive subfolder
    [[ "$TASK_DIR" == *"/archive/"* ]] && continue
    [[ ! -d "$TASK_DIR" ]] && continue

    TASK=$(basename "$TASK_DIR")
    FOUND=1
    echo "[Harness] Checking task: $TASK"

    # 1. tracker.md must exist and contain a Status line
    if [ ! -f "$TASK_DIR/tracker.md" ]; then
        echo "[Error] $TASK: tracker.md missing."
        exit 1
    fi
    if ! grep -qi "Status" "$TASK_DIR/tracker.md"; then
        echo "[Error] $TASK: Status not found in tracker.md"
        exit 1
    fi
    echo "[OK] $TASK: tracker.md"

    # 2. checklist.md must exist
    if [ ! -f "$TASK_DIR/checklist.md" ]; then
        echo "[Error] $TASK: checklist.md missing."
        exit 1
    fi
    echo "[OK] $TASK: checklist.md"

    # 3. findings.md must exist
    if [ ! -f "$TASK_DIR/findings.md" ]; then
        echo "[Error] $TASK: findings.md missing."
        exit 1
    fi
    if ! grep -qiE "Codebase Observation|Findings|Gotcha" "$TASK_DIR/findings.md" 2>/dev/null; then
        echo "[Warning] $TASK: No observations found in findings.md yet."
    fi
    echo "[OK] $TASK: findings.md"

    # 4. If tracker shows Completed, summary.md must exist
    if grep -qiE "Completed|✅" "$TASK_DIR/tracker.md" 2>/dev/null; then
        if [ ! -f "$TASK_DIR/summary.md" ]; then
            echo "[Warning] $TASK: Task is marked Completed but summary.md is missing. Promote findings before archiving."
        else
            echo "[OK] $TASK: summary.md present"
        fi
    fi
done

if [ "$FOUND" -eq 0 ]; then
    echo "[Harness] No active task folders found in $TASKS_DIR."
fi

echo ""
echo "[Harness] Checking skill symlink integrity..."

SKILL_SRC=".ai/skills"
AGENT_DIRS=(".claude/skills" ".cline/skills" ".junie/skills")
SYMLINK_ERRORS=0

for AGENT_DIR in "${AGENT_DIRS[@]}"; do
    [ -d "$AGENT_DIR" ] || continue
    for LINK in "$AGENT_DIR"/*/; do
        [ -e "$LINK" ] || continue
        LINK="${LINK%/}"
        SKILL_NAME=$(basename "$LINK")
        if [ ! -L "$LINK" ]; then
            echo "[Warning] $AGENT_DIR/$SKILL_NAME is a real directory, not a symlink. Run 'bash .ai/setup.sh' to fix."
            SYMLINK_ERRORS=$((SYMLINK_ERRORS + 1))
        elif [ ! -e "$LINK" ]; then
            echo "[Warning] $AGENT_DIR/$SKILL_NAME is a broken symlink. Run 'bash .ai/setup.sh' to fix."
            SYMLINK_ERRORS=$((SYMLINK_ERRORS + 1))
        fi
    done
    for SKILL_DIR in "$SKILL_SRC"/*/; do
        [ -f "$SKILL_DIR/SKILL.md" ] || continue
        SKILL_NAME=$(basename "$SKILL_DIR")
        if [ ! -e "$AGENT_DIR/$SKILL_NAME" ]; then
            echo "[Warning] $AGENT_DIR/$SKILL_NAME missing. Run 'bash .ai/setup.sh' to fix."
            SYMLINK_ERRORS=$((SYMLINK_ERRORS + 1))
        fi
    done
done

if [ "$SYMLINK_ERRORS" -eq 0 ]; then
    echo "[OK] All agent skill symlinks are clean."
fi

echo "[Harness] Task folder health check finished."
