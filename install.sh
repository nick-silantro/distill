#!/bin/bash
# Install distill for Claude Code

# Default to user-level skills directory
SKILL_DIR="${DISTILL_INSTALL_DIR:-$HOME/.claude/skills/distill}"

mkdir -p "$SKILL_DIR"
cp "$(dirname "$0")/SKILL.md" "$SKILL_DIR/SKILL.md"

echo "✓ Installed distill to $SKILL_DIR"
echo ""
echo "Restart Claude Code or start a new session to use it."
echo ""
echo "Tip: To install into a project instead, run:"
echo "  DISTILL_INSTALL_DIR=.claude/skills/distill bash install.sh"
