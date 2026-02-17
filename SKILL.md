---
name: distill
description: "Use when turning large bodies of knowledge (courses, workspaces, documentation, book notes, research) into structured, progressive-disclosure skills. Triggers on: create a skill from, distill into a skill, turn this into a skill, encyclopedia skill, knowledge extraction, distill from course, distill from documentation."
---

# Distill — Turn Large Knowledge Into Skills

## Overview

A methodology for extracting large bodies of knowledge from any source (documents, courses, research archives, knowledge management tools) and structuring them as performant, progressive-disclosure skills that minimize context consumption.

## When To Use

- User has a large knowledge source (course, workspace, book, research corpus)
- They want it queryable by future agent sessions
- The material is too large to load entirely into context without causing rot

## Anti-Patterns

- **Monolithic file** — One huge markdown file that loads entirely on every question. Wastes context, causes rot.
- **Skipping extraction** — Summarizing from memory or partial reads instead of exhaustively reading source material.
- **Chronological organization** — Ordering by when content appeared (lesson 1, 2, 3) instead of by theme. Chronological order is fine for an index, but the reference files should be thematic so a single question loads only relevant material.
- **Premature compression** — Summarizing too aggressively before understanding what details matter. Preserve all frameworks, definitions, examples, and named concepts.

## The Process

### Phase 1: Map the Source

**Goal:** Understand the full scope before reading anything in depth.

1. **Identify the source type** and how to access it:
   - Local files/folders → list directory structure, read tables of contents
   - Web content → fetch sitemap or index pages
   - Knowledge management tools → use their available API/MCP tools to browse top-level structure
2. **Map the top-level structure** — sections, lessons, chapters, categories
3. **Estimate scope** — count top-level topics to plan extraction parallelism
4. **List available tags/metadata** if the source supports structured metadata

### Phase 2: Parallel Extraction

**Goal:** Read everything. Do not summarize yet.

1. **Dispatch parallel agents** — one per major section/lesson/chapter
   - Use whatever background task/subagent mechanism your environment supports (Claude Code: `task` with `--background`, OpenClaw: `sessions_spawn`, or simply sequential reads if parallelism isn't available)
   - Each agent reads all content in its assigned area at maximum depth
   - Instruct agents to return ALL content — every detail, framework, definition, example
   - Explicitly tell agents: "Do not summarize or abbreviate"
2. **Handle external links** — if content references published URLs or templates, fetch and capture those too
3. **Wait for all agents** — do not start compiling until extraction is complete

**Parallelism guidance:**
- Group by natural boundaries (lessons, chapters, sections)
- Aim for 4-8 parallel agents for typical course/workspace size
- Each agent should handle a coherent chunk (not arbitrary splits)
- If parallelism isn't available, extract sequentially — the methodology still works, just slower

### Phase 3: Identify Themes

**Goal:** Find the natural thematic groupings across all extracted content.

1. **Read all agent outputs** (or all extracted content if done sequentially)
2. **Identify frameworks, concepts, and standalone ideas** across all content
3. **Group thematically, not chronologically** — ask:
   - What topics would a user ask about together?
   - What frameworks build on each other?
   - What stands alone?
4. **Target 4-7 reference files** — each ~2-4KB when written
   - Too few = files are too large, defeating progressive disclosure
   - Too many = routing table becomes unwieldy

**Common thematic patterns:**
- Core methodology / foundational frameworks
- Systems and design patterns
- Thinking and analysis tools
- Strategy and positioning
- Practical techniques (prompting, workflows, templates)
- Standalone concepts and examples

### Phase 4: Write the Skill

**Goal:** Create a SKILL.md that serves as a concise router, plus focused reference files.

#### SKILL.md Structure (~3-5KB max)

```markdown
---
name: skill-name
description: "Concise description with trigger keywords..."
---

# Title

One-paragraph overview of the knowledge domain.

## How To Use This Skill

**Do NOT read all reference files upfront.** Use the routing table below
to load only what the user's question requires.

## Quick Reference Card

| Framework/Concept | One-liner | Source | Ref File |
|-------------------|-----------|--------|----------|
| ... | ... | ... | ... |

## Routing Table

| File | Topics |
|------|--------|
| `ref/filename.md` | Topic A, Topic B, Topic C |

## Source Index (optional)

Map topics back to original sources (lessons, chapters, etc.)
```

**Key rules for SKILL.md:**
- Every named concept gets a row in the Quick Reference Card
- One-liners should be enough to answer "what is X?" without loading a ref file
- Routing table makes it obvious which file to load for any topic
- Description field must include all likely trigger keywords

#### Reference Files (~2-4KB each)

- Live in `ref/` subdirectory
- Each file covers one thematic cluster
- Include: full framework descriptions, all steps/components, named examples, key quotes
- Do NOT include: redundant overviews, cross-references to other ref files, meta-commentary

**Example reference file (`ref/core-frameworks.md`):**

```markdown
# Core Frameworks

## Framework Name
**What it is:** One-sentence definition.

**Components:**
1. Component A — explanation
2. Component B — explanation
3. Component C — explanation

**When to use:** Practical guidance on application.

**Example:** Concrete illustration of the framework in action.

---

## Another Framework
...
```

### Phase 5: Verify and Register

1. **Check the skill loads** — confirm the SKILL.md is in a location your agent discovers (project `.claude/skills/`, `~/.claude/skills/`, or equivalent)
2. **Test a few queries mentally:**
   - Can a specific concept question be answered from the Quick Reference Card alone?
   - Does the routing table point to the right file for each topic?
   - Is any single ref file doing too much?
3. **Update any project configuration** that referenced the old monolithic approach

## File Size Guidelines

| Component | Target Size | Purpose |
|-----------|-------------|---------|
| SKILL.md | 3-5KB | Always loaded; routing + quick reference |
| Each ref file | 2-4KB | Loaded on demand; one per theme |
| Total skill | 15-30KB | Full knowledge base across all files |

If a ref file exceeds 4KB, consider splitting it. If SKILL.md exceeds 5KB, the quick reference card may need shorter one-liners.

## Adapting to Different Source Types

### Local Documents
- List files and directories for structure
- Read files for content — group by directory or document type
- Watch for cross-references between documents

### Web Sources
- Fetch individual pages for content
- Start from index/sitemap pages
- Some content may be behind auth — note gaps

### Knowledge Management Tools (Tana, Notion, Obsidian, etc.)
- Use their API or MCP tools to browse structure first
- Extract at maximum depth per section
- Leverage tags/metadata for thematic grouping

### Conversations / Transcripts
- Extract frameworks and named concepts (not dialogue)
- Attribute ideas to speakers if relevant
- Discard filler and repetition
