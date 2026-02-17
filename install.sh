#!/bin/bash
# Install distill for Claude Code

SKILL_DIR="$HOME/.claude/skills/distill"

mkdir -p "$SKILL_DIR"
cp "$(dirname "$0")/SKILL.md" "$SKILL_DIR/SKILL.md"

echo "Installed distill to $SKILL_DIR"
echo "Restart Claude Code or start a new session to use it."
