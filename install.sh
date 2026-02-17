#!/bin/bash
# Install the knowledge-distillation skill for Claude Code

SKILL_DIR="$HOME/.claude/skills/knowledge-distillation"

mkdir -p "$SKILL_DIR"
cp "$(dirname "$0")/SKILL.md" "$SKILL_DIR/SKILL.md"

echo "Installed knowledge-distillation skill to $SKILL_DIR"
echo "Restart Claude Code or start a new session to use it."
