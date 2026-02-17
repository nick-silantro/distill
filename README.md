# Knowledge Distillation Skill for Claude Code

A methodology for turning large bodies of knowledge (courses, Tana workspaces, documentation, book notes, research) into structured, progressive-disclosure skills that any future Claude Code session can query without context rot.

## What It Does

When you say something like "turn this course into a skill" or "distill this into a skill," Claude Code follows a proven 5-phase process:

1. **Map the Source** -- understand the full scope before reading anything in depth
2. **Parallel Extraction** -- dispatch background agents to read everything simultaneously
3. **Identify Themes** -- group content by topic (not chronology) into 4-7 reference files
4. **Write the Skill** -- concise index file (~3-5KB) that routes to focused reference files (~2-4KB each)
5. **Verify and Register** -- confirm the skill is live and queryable

The result is a skill where a typical question costs ~5-7KB of context instead of loading 25KB+ of monolithic content.

## Install

**Option A: One-liner**

```bash
git clone https://github.com/nicksilhacek/knowledge-distillation-skill.git /tmp/kd-skill && bash /tmp/kd-skill/install.sh && rm -rf /tmp/kd-skill
```

**Option B: Manual**

```bash
mkdir -p ~/.claude/skills/knowledge-distillation
cp SKILL.md ~/.claude/skills/knowledge-distillation/SKILL.md
```

Then restart Claude Code or start a new session.

## Supported Source Types

- **Tana workspaces** -- reads node hierarchies, tags, and schemas
- **Document collections** -- files, folders, markdown, PDFs
- **Web sources** -- fetches and extracts from URLs
- **Conversations / transcripts** -- extracts frameworks and concepts from dialogue

## Requirements

- Claude Code CLI
- Works with any Claude model (Opus, Sonnet, Haiku)

## License

MIT
