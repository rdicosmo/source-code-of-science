# Course-notes TODO — Roberto idea drop, 2026-07-20

Filed by the CoS from a verbal drop. Audited against the current tree before
writing: two of the five asks turned out to be already covered, so they are
recorded here as *do-not-duplicate* rather than as work.

## STATUS — worked 2026-07-21

- **A1, A2, A3 — DONE.** Written as one arc: new §4.4 *"Who must be trusted, and
  for what"* in `chapters/04-identifiers.tex`, inserted between §4.3 and *The
  SWHID* so it cashes out §4.3's closing line. Contains the four acts of faith
  (minting / resolution / integrity / availability), Table 4.1 of mechanisms
  offered by Handle/DOI/ARK/PURL — with *verification* empty across the board —
  sourced from `swhipres2018`; then the redaction case (A2) and the lost-key
  thought experiment closing on the directory hash + manifest (A3).
  §4.1 and §4.3 untouched, as instructed.
- **B — DONE, reconciled.** PLAN.md:174's acmart lab was **already implemented**
  at `05-ardc.tex` (hands-on step 3), so it was never pending. Division settled:
  the Ch.5 hands-on stays **the exercise**, the new **Appendix F** (`appendix/
  F-venue-classes.tex`) carries **the reference recipes**; the lab now
  cross-references the appendix, so the acmart material is described once.
  - IEEEtran had **no source anywhere** in the repo, so it was constructed and
    **test-built and verified** (all four entry types render with SWHIDs, crossref
    children print `from [1]`) rather than written from guesswork.
  - acmart: first drafted from the repo's WIP sample, then **rewritten
    2026-07-21** — see B1.
- **B1 — RESOLVED, no upstream chase needed (2026-07-21).** acmart is
  operational and documents this itself; the WIP sample in the repo is
  **acmart v1.54 (2018)**, six years stale. Current state:
  - acmart **rewrote its biblatex support at v1.84** (README credits Roberto Di
    Cosmo and Kartik Singhal) and now ships its own `acmnumeric` /
    `acmauthoryear` styles, which **already integrate biblatex-software**:
    `acmdatamodel.dbx` inputs `software.dbx`, `acmnumeric.bbx` inputs
    `software.bbx` and sets `swhid=true`.
  - So the old hacks are dead: **no** `\let\citename\relax`, **no**
    `datamodel=software`, **no** `\usepackage{software-biblatex}`,
    **no** `style=ACM-Reference-Format`. Just `natbib=false` +
    `\RequirePackage[datamodel=acmdatamodel,style=acmnumeric]{biblatex}`.
  - **Verified by building**, against the *installed* acmart v2.12 and the
    system biblatex-software: all four entry types render
    (`[SW]`/`[SW Rel.]`/`[SW Mod.]`/`[SW exc.]`) with SWHIDs and crossref
    relations. Wiring is identical in the latest CTAN v2.19.
  - Remaining real caveat is ACM's own, now quoted in App. F: the biblatex
    path is "highly experimental" and **not supported by TAPS** (camera-ready
    production). Preprint/arXiv/archival: fine.
- **C — still open, needs Roberto.** The DOI-structure figure question is
  untouched: it is a framing decision against commit `a1f1226`, not a gap.
- **D — respected.** Nothing added on location-vs-identification or
  intrinsic-vs-extrinsic.

Build after the work: clean (`exit 0`, no undefined refs), 71 → 75 pp.

## A. Real gaps — write these

### A1. Trust model  ← the significant gap
No section, subsection, or named treatment exists. "Trust" currently appears
only as rhetorical closes:
- `chapters/04-identifiers.tex:126` — "the difference between a name you must
  trust someone to keep, and a name anyone can check"
- `chapters/04-identifiers.tex:227` — "an intrinsic identifier we can trust"
- `chapters/06-reproducibility-aec.tex:156,169` — "No archive, no network, and
  no trust required"

Adjacent material already in place to build on: §4.3's passage on *persistence
as administered, not computed*, quoting RFC 3650 that handle persistence
"depends more on administrative policies than the technology itself".

**To write:** an explicit model of *who must be trusted for what* — minting,
resolution, content integrity, availability — and which of those an intrinsic
identifier removes from the trust surface.

**Source:** the iPRES papers (image + content) — all verified to exist 2026-07-20:
- `~/.../slides/talks-private/2018-09-25-iPres2018/` — **substantial**: `.tex`/`.org`
  source, built PDFs, handout. This is the usable one.
- `~/Projects/SWH/annex-public/talks/2017/2017-09-27-kyoto-ipres.pdf` — real,
  annex object present locally (not a dangling pointer).
- `~/.../slides/talks-private/2021-10-19-iPres/` — ⚠ **thin**: contains only
  `iPresBozzaMia.odp` (a draft), no PDF and no `.tex`/`.org` source. Calling it
  "one of the iPRES papers" overstates it. If the 2021 content is actually
  wanted, the real paper must be sourced from elsewhere.

### A2. What we lose when datasets are redacted
Explain clearly what becomes unknowable once people redact/alter datasets:
with only a DOI there is **no way to detect it**. Ties directly to A1 (this is
the trust surface made concrete) and to the intrinsic-identifier argument.

### A3. Thought experiment — lost key data
Motivate the **directory hash**, and go further: a **manifest file** for the
most important codes/datasets. Frame as a thought experiment ("what if this
key dataset were lost / silently altered?") rather than as a spec.

## B. New appendix — typesetting examples

Clear worked examples of using `biblatex-software` with:
- **`acmart.cls`** — blocked-ish: the acmart documentation has an **open PR to
  clarify this, unmerged as of last check**. See action B1 below.
- **the IEEE class** (`IEEEtran`).

Note: these notes themselves use `report` + vendored `biblatex-software`
v1.2-8 (`style/`, via `.latexmkrc`), **not** acmart — so the examples are new
material, not extractable from the build here. Natural home: a new appendix
next to App. A (command cookbook) / App. D (SWHID tool implementations).

⚠ **Reconcile before writing:** `PLAN.md` line ~174 ("Pedagogical devices")
already lists *"use an `acmart.cls` and enable support for `biblatex-software`
entries"* as an in-chapter hands-on lab exercise. That is adjacent to but
distinct from this appendix. Decide which carries the worked examples so the
same acmart material is not described twice in two places.

### B1. Upstream action (NOT a notes edit — tracked separately)
Chase the open **acmart.cls documentation PR** clarifying biblatex-software
usage. This is a community-facing task with an external owner; it gates the
quality of the acmart example above. Belongs to the d8 / `bibtex-sw-entry`
thread, not to this TODO list.

## C. Decide before adding — DOI structure figure

Roberto asked for "the image of the DOI structure" (source available:
`.../talks-public/2026-06-11-SNS-EELISA/references/doi-merkle.org`, an older
2018 deck reused as source material).

**Conflict:** commit `a1f1226` — *"Reframe the DOI section as a neutral
question, not a quoted claim"* — deliberately turned §4.2 into "when is one DOI
'better' than another?", arguing the identifier layer is *uniform* (Crossref and
DataCite are co-accredited IDF registration agencies over the same Handle
System) and that the real differences live in organization / metadata /
curation. A prefix/suffix anatomy figure would partly undo that framing.

**Open question for Roberto:** add the anatomy figure anyway (and if so, where —
does it serve the "uniform layer" argument or cut against it?), or keep §4.2 as
the neutral question and put the structure image somewhere else entirely?

## D. Already covered — do NOT duplicate

- **location vs identification vs metadata** — §4.1 "Five concerns hiding behind
  one word" is *organized around this*: Identification / Location / Metadata /
  Organization / Curation, with TikZ figure `fig:five-concerns` isolating
  Identification from the other four ("what 'a better identifier' usually really
  means"). Nothing to port from the slides; the notes version is stronger.
- **intrinsic vs extrinsic** — §4.3, with the Paskin "digital identifier *of an
  object*" reading, the repointable-register argument, and a takeaway box.

---
*Note: this file is a capture, not an edit. The tree was in flight when it was
written (`REVIEW-2026-07-19.md` pass active, working tree touched 2026-07-20
00:55) — nothing in `chapters/` was touched.*
