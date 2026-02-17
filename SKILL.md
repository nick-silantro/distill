---
name: distill
description: "Use when turning large bodies of knowledge (courses, workspaces, documentation, book notes, research) into structured, progressive-disclosure skills. Triggers on: create a skill from, distill into a skill, turn this into a skill, encyclopedia skill, knowledge extraction, skill from Tana, skill from course, skill from documentation."
---

# Distill — Turn Large Knowledge Into Skills

## Overview

A methodology for extracting large bodies of knowledge from any source (Tana workspaces, documents, courses, research archives) and structuring them as performant, progressive-disclosure skills that minimize context consumption.

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
   - Tana workspace → `list_workspaces`, `read_node` (home node, maxDepth 2)
   - Documents/files → `Glob` for structure, `Read` for table of contents
   - Web content → `WebFetch` for sitemap/index pages
2. **Map the top-level structure** — sections, lessons, chapters, categories
3. **Estimate scope** — count top-level topics to plan extraction parallelism
4. **List available tags/metadata** if the source supports it (Tana: `list_tags`)

### Phase 2: Parallel Extraction

**Goal:** Read everything. Do not summarize yet.

1. **Dispatch parallel agents** — one per major section/lesson/chapter
   - Use `Task` tool with `subagent_type: general-purpose` and `run_in_background: true`
   - Each agent reads all nodes/sections in its assigned area at maximum depth
   - Instruct agents to return ALL content — every detail, framework, definition, example
   - Explicitly tell agents: "Do not summarize or abbreviate"
2. **Handle external links** — if content references published URLs or templates, use `WebFetch` to capture those too
3. **Wait for all agents** — do not start compiling until extraction is complete

**Parallelism guidance:**
- Group by natural boundaries (lessons, chapters, sections)
- Aim for 4-8 parallel agents for typical course/workspace size
- Each agent should handle a coherent chunk (not arbitrary splits)

### Phase 3: Identify Themes

**Goal:** Find the natural thematic groupings across all extracted content.

1. **Read all agent outputs**
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

### Phase 5: Verify and Register

1. **Check the skill appears** in the available skills list (it should auto-register from `~/.claude/skills/`)
2. **Test a few queries mentally:**
   - "What are SUE scores?" → Quick Reference Card has one-liner; ref file has full detail
   - "Explain the DORA method" → routing table points to correct file
   - "What was covered in Lesson 3?" → Source Index answers directly
3. **Update any project CLAUDE.md** files that referenced the old monolithic approach

## File Size Guidelines

| Component | Target Size | Purpose |
|-----------|-------------|---------|
| SKILL.md | 3-5KB | Always loaded; routing + quick reference |
| Each ref file | 2-4KB | Loaded on demand; one per theme |
| Total skill | 15-30KB | Full knowledge base across all files |

If a ref file exceeds 4KB, consider splitting it. If SKILL.md exceeds 5KB, the quick reference card may need shorter one-liners.

## Adapting to Different Source Types

### Tana Workspaces
- `read_node` with `maxDepth: 2` on home node for structure
- `read_node` with `maxDepth: 5` on content nodes for detail
- `list_tags` and `get_tag_schema` for metadata
- Content is hierarchical — good for parallel extraction by top-level node

### Document Collections
- `Glob` for file listing, `Read` for content
- Group by directory structure or document type
- Watch for cross-references between documents

### Web Sources
- `WebFetch` for individual pages
- Start from index/sitemap pages
- Some content may be behind auth — note gaps

### Conversations / Transcripts
- Extract frameworks and named concepts (not dialogue)
- Attribute ideas to speakers if relevant
- Discard filler and repetition
