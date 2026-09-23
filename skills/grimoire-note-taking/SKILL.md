---
name: grimoire-note-taking
description: "Use when writing, editing, splitting, or reorganizing notes in a Grimoire vault: note anatomy, the fractal vault layout, writing for retrieval, links, frontmatter, runnable blocks, diagrams, and keeping the vault coherent. Commands live in the grimoire-cli skill. Use whenever deciding what to write."
---

# Grimoire note-taking

Retrieval returns one section out of context — that section may be all a reader ever sees. Every rule follows from this.

## Workflow

1. `search` first. Extend the note that covers it — a near-duplicate is worse than an untidy vault. If two notes disagree, one is wrong: fix it, never add a third.
2. Draft: title, 1-3 sentence summary, one heading per topic.
3. Reread: cut what the reader's next action doesn't depend on — how you found out, sections that restate another.
4. Verify: search a phrase you didn't put in the title. The note must come back.

## A note

- One subject. Title needs "and" → two notes. Deleting it rewrites four others → too much.
- The title is the retrieval handle: specific, self-describing — `Ticket Event Stream Ingestion`, not `Session 1`. Never a date or number as the only distinguisher.
- Open with a 1-3 sentence summary. Keep under a screen or two. Longer → split and link. Fold logs and session dumps into a durable conclusion and let the raw trail go.
- Living: correct in place. A note that argues with itself poisons retrieval.
- File by subject, not by where you learned it.

## Layout: one fractal shape at every scale

Every folder — the vault root included — is the same container. Structuring a subfolder repeats the vault's recipe, so a correct structure is definable at any level.

| Part | Earned when | Holds |
|------|-------------|-------|
| notes | always | one subject each, directly inside |
| `assets/` | first non-retrievable file | `diagrams/`, `screenshots/`, `scripts/`, `evidence/` — same kinds at every level, never nested in an `assets/` |
| child containers | the listing stops scanning | one concern per child, never a folder for one note |
| `index.md` | children exist | a MOC: reading-order links, no facts its targets don't carry |

- Retrieval crosses folders: children serve the browser, not search. Links are the knowledge structure.
- An asset lives where its note would, at any depth. Borrowers embed by vault-root-relative path.
- Structure is earned, never scaffolded: a new vault starts empty, a copied template yields empty folders and date-filed notes. A vault-root `assets/` serves the whole vault. Most never earn one.

Top-level kinds fix where a note starts. The fractal shape recurses below. Two standard kinds, not a closed set — any other top-level folder the owner wants is the same container under the same recipe:

| Folder | Kind | Examples |
|--------|------|----------|
| `activities/` | time-bound: a named thread of work | ticket, investigation, onboarding, standing duty |
| `references/` | timeless: how things work, independent of any effort | systems, vocabulary, procedures, people |

- An activity sits loose at `activities/` root until a second note or first asset. Promote with `folder create` + `note rename`. Keep the id in every title inside (`Z2 15153813 Investigation and Findings`) — a retrieved section carries no path.
- Every activity has one core note — the catch-up page. It holds the essential state, findings, commands with their output, and the assets that help, as briefly as clarity allows. A human new to the thread catches up from it alone.
- A recurring activity's core is Investigation and Findings, supported by Runbook, Reproduction, Conclusion.
- Never: an archive folder (a concluded activity stays put, its findings are references now) · `note delete` for finished work (trash is for wrong or superseded) · a date- or number-named folder (a date is not a subject).

## Write for retrieval

- Sections stand alone: subject named in heading and first sentence. No "as described above", no pronouns reaching back three headings.
- Spell out entities once per section: full service names, acronyms expanded on first use.
- One heading per topic. 3-10-line sections retrieve better than a 200-line dump.
- Define every value: `stale` means nothing next to "no edit in 90 days (112d)".
- Bold one load-bearing sentence per section — not a highlight run.
- Footnote what you observed. A derivation must never read back as a measurement.
- Redundancy that keeps each note self-sufficient is fine. Vagueness is not.
- Tables: one fact per cell. Three scannable columns beat five readable. A cell over one line belongs below the table.

## Links

- `[[Note Title]]` at the point of need, in a sentence saying why — a bottom link dump carries no information. Cite one claim as `[[Note#Heading]]`, heading verbatim.
- Retrieval doesn't follow links: state the one fact needed to keep going, link for the rest.
- A `[[link]]` to a missing note marks work to do — don't create stubs.
- Outside claims carry their source inline (repo, doc, ticket, release note). Say when second-hand.

## Coherence

The vault is one document: a fact stated twice is stated the same way, and every pointer lands.

- `note rename` retargets inbound wikilinks. A link in frontmatter is data — check by hand.
- Moving a fact means deleting it from where it was. "See X" over the old text is worse than either.
- A count is a claim about a list: "26 projects" over 27 names is a contradiction. Recount or drop it.

## Frontmatter

Only what you would filter on. The body says the rest. Reuse the vault's existing keys, spelled the same. No prose, no long values.

## Executable blocks

`bash` is builtin. The rest are a `kernel install` away (`kernel list` to confirm).

- One runner per note. `python`/`yaegi` share state like notebook cells. `go` compiles each block standalone: `package main`, own imports, every block.
- Stdlib only — no `pip install`/`go get`. Rewrite against the stdlib or say so in the note.
- Tag ambiguous blocks: ` ```go {kernel=go} ` — `go` and `yaegi` both claim `go`.
- A block reproduces something. A runnable check beats a pasted transcript.
- Paste output only when unsafe to re-run: keep the columns and representative rows, mark the cut ("top 10 of 40, rest elided").
- An imported file is a draft: re-home, summarize, link, cut what conversion dragged in.

## Diagrams and screenshots

Not retrievable — the text carries the content and the picture is the human's fast path. Place each directly under the text it illustrates, never two in a row. Diagrams: the vault's diagramming skill owns style, sizing, rendering. Screenshots: size the window to the subject, match existing shot widths, close banners, look at the result — cropping keeps the centre, rarely the subject.
