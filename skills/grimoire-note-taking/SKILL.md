---
name: grimoire-note-taking
description: Use when writing, editing, splitting, or reorganizing notes in a Grimoire vault — what a note should contain, where it lives (vault layout, subject subfolders), how to title and section it so retrieval finds it, links, frontmatter, runnable blocks, diagrams, and keeping the vault self-consistent. Commands live in the grimoire-cli skill; use this one whenever the task is deciding what to write.
---

# Grimoire note-taking

**Sections are embedded and returned out of context — one section may be all an agent
ever reads.** Every rule here follows from that.

## Workflow

1. **`search` the topic first.** If a note already covers it, extend that note; a
   near-duplicate is worse than an untidy vault. If a note says something different,
   one of the two is wrong: fix it rather than adding a third version.
2. Draft the note with a title, a 1–3 sentence summary, and one heading per topic.
3. **Revisit before finishing.** Cut what the reader's next action does not depend
   on, remove the scaffolding of how you found out, and drop sections that restate
   another.
4. **Verify it retrieves.** Search a phrase you did *not* put in the title and check
   that the note comes back. Writing a note is not the same as landing it.

## What a note is

- **One note, one subject.** If the title needs "and", it is two notes. Test: what
  would it take to delete this note? If the answer is "rewrite four others", the
  note is doing too much.
- **The title is the retrieval handle.** Make it specific and self-describing:
  `Ticket Event Stream Ingestion`, not `Session 1`. Never let a date or a number be
  the only distinguisher.
- **Open with a 1–3 sentence summary** of what the note is about. The human skimming
  and the retriever both see this first.
- **Keep it under a screen or two.** Past that it has outgrown its subject: split it
  and link the parts. Cap anything unbounded (logs, session dumps) by folding the
  durable conclusion into a subject note and letting the raw trail go.
- **Notes are living.** Correct in place rather than appending a contradiction; a
  note that argues with itself poisons retrieval.
- **Where a note goes is the vault's decision, not yours.** Put it where notes on
  that subject already live. Add a folder only when the subject has no home at all,
  and give it one concern. Search and links do the finding, so file by subject,
  never by where you happened to learn it.

## Vault layout

The shape follows PARA (Forte), adapted. A vault earns each folder as the subject
appears, so a new vault starts empty; copying a template scaffold produces empty
folders and notes filed by date.

- `projects/` holds an effort with an outcome: a ticket, an investigation, an
  upgrade. A multi-note effort gets a `projects/<id>/` subfolder; a single-note
  effort sits loose at the `projects/` root with the id in its title.
- `reference/` holds how the systems work, independent of any effort: services,
  vocabulary, procedures.
- `people/` and `workplace/` hold the humans you work with and employment
  logistics.
- `assets/` holds non-retrievable files by kind (`diagrams/`, `screenshots/`,
  `scripts/`). A note references into it; nothing lives there unread.
- The vault root holds Maps of Content (LYT, Milo): reading-order overviews that
  link across folders. A MOC orients the reader and never holds facts its target
  notes don't; an index that restates rots into a second copy.

Subfolders:

- **A subfolder is earned, not pre-created.** Create `projects/<id>/` when you
  write the second note on the effort: `folder create` it, `note rename` the first
  note in, then grep the old title for `[[links]]`. A move is a rename and breaks
  pointers the same way.
- **The id stays in the title inside the folder.** `Z2 15153813 Investigation and
  Findings`, never `Investigation and Findings`: a retrieved section carries no
  path, so the title is the reader's only context.
- **Recurring roles make a folder read as a set:** Investigation and Findings (the
  durable record), Runbook, Reproduction, Conclusion.
- **No archive folder.** A concluded project stays where it is; its findings are
  reference now. Trash (`note delete`) is for notes that are wrong or superseded,
  not finished.
- **No date- or number-named folders** (`2026-09/`, Johnny Decimal's `07
  Projects`). A date is not a subject.

## Write for retrieval

- **Every section stands alone.** Name its subject in its own heading and its first
  sentence. No "as described above", and no pronoun whose antecedent is three
  headings back.
- **Spell out entities once per section:** full service names, and every acronym
  with its expansion the first time that section uses it.
- **A heading per topic.** Sections of 3–10 lines retrieve better than one
  200-line dump.
- **Define every value you name.** A label is just a word until the note says how
  it was derived and shows one worked value: `stale` means nothing next to "no
  edit in 90 days" and `112d`.
- **Mark what you observed.** A footnote is enough, so a derivation is never read
  back as a measurement.
- **Redundancy across notes is fine** where it makes each note self-sufficient.
  Vagueness is not.
- **Tables:** one fact per cell; three columns you can scan beat five you must
  read. A cell longer than one line belongs below the table.

## Links

- Put `[[Note Title]]` **at the point the other note is needed**, in a sentence
  that says why. A link dump at the bottom carries no information.
- **When citing one claim, use `[[Note#Heading]]`** so the reader lands on the
  paragraph you meant rather than the top of a long note. The heading must match
  verbatim.
- **Retrieval does not follow links.** State the one fact the reader needs to keep
  going, then link for the rest.
- A `[[Link]]` to a note that doesn't exist yet marks work to do. Don't create stub
  notes to satisfy it.
- **A claim from outside the vault carries its source, inline at the claim.** Link
  the thing itself — repo, doc, ticket, release note — so the reader can check it;
  a bare name makes them repeat the search you already did. External facts rot, so
  say when a claim is second-hand ("per X's round-up") rather than read at the
  source.

## Keeping the vault coherent

The vault is one document: a fact stated twice must be stated the same way, and
every pointer must still land.

- **Renaming or splitting a note breaks the pointers into it.** Grep the old title
  before you finish and fix every `[[link]]` that named it. The index needs no
  help; `note rename` prunes the old path itself.
- **Moving a fact means deleting it from where it was.** "See X" with the old text
  still sitting below it is worse than either alone.
- **A count is a claim about a list.** "26 projects" above 27 names is a
  contradiction: recount or drop the number.

## Frontmatter

Keep only what you would filter on, never what the body already says. Reuse the
keys the vault already uses, spelled the same way, rather than coining a synonym
for one of them. No prose and no long values: frontmatter isn't indexed as
content.

## Executable blocks

`bash` is builtin and the rest are one `kernel install` away, so write the check in
whichever language reads clearest. Confirm with `kernel list` before relying on
one.

- **One runner per note.** Interpreted kernels (`python`, `yaegi`) share state
  across the note like notebook cells. `go` compiles each block as a standalone
  program, so write those self-contained: `package main` and its own imports,
  every block.
- **Standard library only.** Grimoire never runs `pip install` or `go get`. A
  block needing a third-party import assumes a prepared host; rewrite it against
  the stdlib, or say so in the note.
- **Tag the block when the language is ambiguous:** ` ```go {kernel=go} `. `go`
  and `yaegi` both claim `go`/`golang`, and the default picks the newest version
  of the first family alphabetically.
- **Blocks reproduce something; they are not decoration.** A runnable check beats
  a pasted transcript. Paste output as text when the command can't be safely
  re-run.
- **An imported file is a draft.** Re-home it, add the summary and the links, and
  cut what the conversion dragged in.

## Diagrams and screenshots

Neither is retrievable. The note carries the same content in text; the picture is
the human's fast path. Put each one directly under the text it illustrates, never
two in a row — a stack at the end of a section means one of them has no text.
Write that text, then place it.

- **Diagrams:** the vault's diagramming skill owns the style, the sizing, and the
  render step.
- **Screenshots:** size the window to the subject *before* shooting, then look at
  the result. A view clipped at the wrong edge hides the part that mattered, and
  an oversized viewport leaves a dead band down the middle. Match the width of the
  shots already in the vault so they sit together. Close banners and scroll the
  subject into frame first; cropping afterwards keeps the centre, which is rarely
  the subject.
