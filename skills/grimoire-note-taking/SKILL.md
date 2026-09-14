---
name: grimoire-note-taking
description: Use when writing, editing, splitting, or reorganizing notes in a Grimoire vault — what a note should contain, how to title and section it so retrieval finds it, links, frontmatter, runnable blocks, diagrams, and keeping the vault self-consistent. Commands live in the grimoire-cli skill; use this one whenever the task is deciding what to write.
---

# Grimoire note-taking

**Sections are embedded and returned out of context — one section may be all an agent
ever reads.** Every rule here follows from that.

## Workflow

1. **`search` the topic first.** If a note covers it, extend that note — a
   near-duplicate is worse than an untidy vault. If a note says something *different*,
   one of the two is wrong: fix it rather than adding a third version.
2. Draft: title, 1–3 sentence summary, one heading per topic.
3. **Revisit before finishing.** Cut what the reader's next action doesn't depend on,
   remove the scaffolding of how you found out, drop sections that restate another.
4. **Verify it retrieves.** `search` a phrase you did *not* put in the title and check
   the note comes back. Writing a note is not the same as landing it.

## What a note is

- **One note, one subject.** If the title needs "and", it's two notes. Test: what would
  it take to delete this note? "Rewrite four others" means it's doing too much.
- **The title is the retrieval handle** — specific and self-describing.
  `Ticket Event Stream Ingestion`, not `Session 1`. Never let a date or a number be the
  only distinguisher.
- **Open with a 1–3 sentence summary** of what the note is about. The human skimming and
  the retriever both see this first.
- **Keep it under a screen or two.** Past that it has outgrown its subject: split and
  link. Cap anything unbounded (logs, session dumps) — fold the durable conclusion into
  a subject note and let the raw trail go.
- **Notes are living.** Correct in place rather than appending a contradiction; a note
  that argues with itself poisons retrieval.
- **Where a note goes is the vault's decision, not yours.** Put it where notes on that
  subject already live; add a folder only when the subject has no home at all, and give
  it one concern. Search and links do the finding, so file by subject, never by where
  you happened to learn it.

## Write for retrieval

- **Every section stands alone.** Name its subject in its own heading and its first
  sentence. No "as described above", no pronoun whose antecedent is three headings back.
- **Spell out entities once per section** — full service names, and every acronym with
  its expansion the first time that section uses it.
- **A heading per topic.** 3–10 line sections retrieve better than one 200-line dump.
- **Define every value you name.** A label is just a word until the note says how it
  was derived and shows one worked value — `stale` means nothing next to "no edit in
  90 days" and `112d`.
- **Mark what you observed.** A footnote is enough — so a derivation is never read back
  as a measurement.
- **Redundancy across notes is fine** where it makes each note self-sufficient.
  Vagueness is not.
- **Tables:** one fact per cell; three columns you can scan beat five you must read. A
  cell past one line belongs below the table.

## Links

- `[[Note Title]]` **at the point the other note is needed**, in a sentence saying why.
  A link dump at the bottom carries no information.
- **Citing one claim? Use `[[Note#Heading]]`** so the reader lands on the paragraph you
  meant rather than the top of a long note. The heading must match verbatim.
- **Retrieval does not follow links.** State the one fact the reader needs to keep going,
  then link for the rest.
- A `[[Link]]` to a note that doesn't exist yet marks work to do. Don't create stub notes
  to satisfy it.
- **A claim from outside the vault carries its source, inline at the claim.** Link the
  thing itself — repo, doc, ticket, release note — so the reader can check it; a bare
  name makes them repeat the search you already did. External facts also rot, so say
  when the claim is second-hand ("per X's round-up") rather than read at the source.

## Keeping the vault coherent

The vault is one document: a fact stated twice must be stated the same way, and every
pointer must still land.

- **Renaming or splitting a note breaks the pointers into it.** Grep the old title
  before you finish and fix every `[[link]]` that named it. The index needs no help —
  `note rename` prunes the old path itself.
- **Moving a fact means deleting it from where it was.** "See X" with the old text still
  sitting below it is worse than either alone.
- **A count is a claim about a list.** "26 projects" above 27 names is a contradiction:
  recount or drop the number.

## Frontmatter

Only what you'd filter on, never what the body already says. Reuse the keys the vault
already uses, spelled the same way, rather than coining a synonym for one of them. No
prose and no long values: frontmatter isn't indexed as content.

## Executable blocks

`bash` is builtin and the rest are one `kernel install` away, so write the check in
whichever language reads clearest. Confirm with `kernel list` before relying on one.

- **One runner per note** — interpreted kernels (`python`, `yaegi`) share state across the
  note like notebook cells. `go` compiles each block as a standalone program, so write
  those self-contained: `package main` and its own imports, every block.
- **Standard library only.** Grimoire never runs `pip install` or `go get`. A block
  needing a third-party import assumes a prepared host — rewrite it against the stdlib,
  or say so in the note.
- **Tag the block when the language is ambiguous:** ` ```go {kernel=go} `. `go` and
  `yaegi` both claim `go`/`golang`, and the default picks the newest version of the first
  family alphabetically.
- **Blocks reproduce something; they are not decoration.** A runnable check beats a
  pasted transcript. Paste output as text when the command can't be safely re-run.
- **An imported file is a draft.** Re-home it, add the summary and the links, cut what
  the conversion dragged in.

## Diagrams and screenshots

Neither is retrievable. The note carries the same content in text; the picture is the
human's fast path. Put each one directly under the text it illustrates, never two in a
row — a stack at the end of a section means one of them has no text. Write that text,
then place it.

- **Diagrams:** the vault's diagramming skill owns the style, the sizing, and the
  render step.
- **Screenshots:** size the window to the subject *before* shooting, then look at the
  result — a view clipped at the wrong edge hides the part that mattered, and an
  oversized viewport leaves a dead band down the middle. Match the width of the shots
  already in the vault so they sit together. Close banners and scroll the subject into
  frame first; cropping afterwards keeps the centre, which is rarely the subject.
