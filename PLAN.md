# Plan — Course note: *The Source Code of Science*

**Working title:** *The Source Code of Science — Archiving, Referencing and Reproducing
Research Software*
(alt. subtitle: *a doctoral course, beyond FAIR data*)

## Context

We have built a standalone *AEC guide* (`../2026-06-AEC-guide/`) and, in doing so, assembled
a verified bibliography (canonical citekeys + `biblatex-software` entries) and become
familiar with a large body of Software Heritage (SWH) teaching material: the **SNS-EELISA
2026** doctoral course ("Beyond FAIR Data"), the **ScienceEurope / GARR-2022 / OSEC-2022**
open-science-pillar talks, the **SKAO 2023** big-science course, the **GARR-2026**
resilience/sovereignty talk, the canonical articles (CACM 2018, CiSE 2020, ICMS 2020,
ecosystem survey 2023, **CODE beyond FAIR** 2026), and the online HOWTO.

This plan turns that corpus into a **full-fledged, self-contained course note** (lecture
notes, prose, ~40–60 pp) for **PhD students and researchers across disciplines**, in
**English**, built in **LaTeX** so the note itself models good software citation via
`biblatex-software`. FAIR is deliberately *not* in the title: the note addresses FAIR and
then moves *beyond* it (per the CODE-beyond-FAIR roadmap).

## Decisions (settled)

- **Spine:** hybrid — ARDC backbone, foundations chapter, reproducibility/artifact-evaluation
  climax, policy+resilience outlook, framed by the "software is not data → beyond FAIR" thesis.
- **Audience/level:** doctoral course; cross-disciplinary researchers; practical with moderate
  theory; suitable for self-study *and* taught delivery.
- **Language:** English (an Italian edition is a possible later follow-up for the GARR audience).
- **Build:** LaTeX `report` + `biblatex` (`datamodel=software`) + `software-biblatex`
  + `biber`, compiled with `xelatex` (TeX Gyre Pagella, SWH-branded title), standalone git repo
  like the AEC guide. (KOMA `scrreprt` was the first choice but `koma-script` is not installed.)
- **License:** CC-BY-4.0 for the text; code snippets permissive (CC0/MIT). *(settled)*
- **Hands-on labs:** included — lab boxes in the practical chapters, plus a self-verification
  capstone in the Colophon. *(settled)*

## Structure and chapter outline

Estimated lengths in parentheses. Each chapter lists the **existing material to reuse**
(module `file.org::#CUSTOM_ID`, paths relative to `slides/common/modules/`) and the **key
references** (citekeys from the shared `references.bib`).

**Ch. 0 — Why this note** (~3 pp)
Software as the third pillar of open science (with publications and data); the stakes
(reproducibility + preservation). The "Monday-morning" promise of the note.
*Reuse:* `swh-ardc.org::#pillaropenscience`, `::#pillaropenscience_monitor`;
`source-code-different-short.org::#softwareisdifferent`.
*Refs:* `SwhCACM2018`, `osec_2022`. *Figure:* French Open Science barometer.

**Ch. 1 — Software is not data, and why "beyond FAIR"** (~5 pp)
Software's living nature: executable + human-readable, evolves over time, dependency
complexity, the human side. Where FAIR-for-data fits and where it breaks for software; the
CODE-beyond-FAIR tiered roadmap. *(This chapter addresses FAIR head-on, then sets it aside.)*
*Reuse:* `swh-ardc.org::#swnotdata`; SNS FAIR section (`2026-06-11-SNS-EELISA.org`, "What
about FAIR?").
*Refs:* `NatureSD2026` (CODE beyond FAIR), `barker2022fair4rs`, `2020GtCitation`.

**Ch. 2 — Foundations** (~10 pp)
Forges are not archives (link-rot evidence: Google Code/Gitorious 2015, Bitbucket 2020, URL
half-life). Identification vs location; **intrinsic vs extrinsic identifiers** (why DOI is
not enough for code). The Merkle DAG data model. The **SWHID** and its granularity. ISO/IEC
18670:2025, SPDX, IANA, Wikidata.
*Reuse:* `forges-not-archives.org::#categories,#oldapproaches,#evidence`;
`swh-pids.org::#diovsido,#swhexamples`; `doi-analysis.org::#doiexplained`;
`under-the-hood-pictures.org::#automation`; `vcs-history.org::#dvcs-to-merkle`;
`swhid.org::#main,#swhidentify`; `swh-id-syntax.org::#swh-id-syntax`.
*Refs:* `swhipres2018`, `ICMS2020`, `pietri2019graph`, `SWHecosystems2023`, `isoiec18670`.
*Figures:* archive-growth, Merkle/under-the-hood.

**Ch. 3 — ARDC in practice** (~12 pp) — the operational core
- **Archive:** Save Code Now, browser extension, webhook/CI, SWORD deposit.
- **Reference:** choosing SWHID granularity (snp/rev/rel/dir/cnt/lines); qualified SWHIDs;
  the `origin=`/`visit=`/`anchor=` qualifiers; worked examples (Apollo 11, Quake III).
- **Describe:** `codemeta.json`, `CITATION.cff`, SPDX licensing, REUSE.
- **Cite & Credit:** `biblatex-software` (the four entry types, the `swhid=` field, crossref
  chains); how the note cites *itself* (dogfooding).
*Reuse:* `swh-acquisition-process.org::#savecodenow`; `deposit.org::#overview,#prepare,#send,#status`;
`swh-ardc.org::#swh-a,#swh-r,#swh-dc,#ardc-best-france`;
`research-software-essentials.org::#description,#licence,#versioncontrol`.
*Refs:* `DiCosmoSEN2020`, `cise-2020-doi`, `force11citationprinciples`, `SCIDWG2020`.
*Tooling:* the `swhid` and `biblatex-software-citation` skills; the online HOWTO.
*Figures:* `BibLaTeX-swh.png`, `hal-swh-overview.png`.

**Ch. 4 — Reproducibility and artifact evaluation** (~12 pp) — the climax
The reproducibility crisis (Collberg); reproducible builds; ACM Artifact Review & Badging and
its spread across (and beyond) CS; the eLife automatic-archival pipeline. **The AEC guide is
lifted in here, lightly re-edited as a chapter** (history of AEC; the four failures of
zip+DOI; the seven SWH properties; organiser/author/reviewer parts; double-blind via
`dir` SWHIDs; the Spinellis "hotspots" strip/restore-qualifiers technique).
*Reuse:* `sourcecode-reproductibility.org::#artefactevaluation,#artefactevaluation-beyondcs,#elife-swh-pipeline,#opensourcereprod`;
`reprod-bad-sota.org::#collbergmethod`; `reproducible-builds.org::#r-b-definition`;
**`../2026-06-AEC-guide/swhid-artifact-evaluation-guide.md`** (port to LaTeX).
*Refs:* `acmbadging`, `nisorp31`, `spinellis2026hotspots`. *Figure:* `acm-artifact-badges`.

**Ch. 5 — Adoption, policy and outlook** (~8 pp)
Adoption indicators (HAL, IPOL, eLife, swMATH, Episciences). The policy landscape (UNESCO,
EOSC SIRS, national plans, the French Software College, RI roadmap). The wider mission:
**resilience & digital sovereignty** (Guix fallback to SWH, AI transparency / CodeCommons,
software supply chain / CRA / SBOM). Call to action for researchers, reviewers, institutions.
*Reuse:* `swh-adoption-academic.org::#adoption,#news`;
`policyactions.org::#unesco2021,#eoscsirs2020,#PNSO2-official,#collegelogiciel,#roadmap2022,#pariscall2019`;
GARR-2026 material (`talks-private/2026-05-19-Garr/`: Guix proof-of-concept, six strategic levers).
*Refs:* `NatureSD2026`, `dicosmo_tpdl_2022`, `SWHecosystems2023`.

**Appendices**
- A. **Command cookbook** (port of the AEC guide's Appendix A: `swh identify`, verify, scanner).
- B. **SWHID syntax cheat-sheet** (from `swh-id-syntax.org`).
- C. **Glossary** (SWHID, core/qualified, origin, visit, anchor, snapshot, forge, archive, ARDC…).
- D. **Annotated bibliography** (the curated `references.bib`).

**Pedagogical devices (doctoral course):**
- *Hands-on boxes* at the end of Ch. 3–4: "archive <any> repo (yours, or a report you want to mention/cite/rely upon) and get its SWHID", "compute a
  `dir` SWHID and verify it", "write a `biblatex-software` entry for your code"
  + additional material:
     - use updateswh, save code now
	 - create a reference to a code snippet, a revison, a file a directory, etc. to embed in a research article
	 - create variants of biblatex-software entries
	 - use an acmart.cls and enable support for biblatex-software entries
     - set up a webhook for your repository on GitHub, GitLab instances, Gitea, Birbucket, SourceForge
  + create a codemeta.json, insert it into your repo, check how the citation sidebar appears in the Archive, and use it to get the citations that you want
- *Key-takeaway* margin notes per chapter.
- *Dogfooding (implemented):* the note archives and verifies **itself**. Because a SWHID is a
  hash of the content, a document cannot contain its own SWHID; so `make swhid SWHID=...` stamps
  the archived-source SWHID into a *non-committed* release PDF, and the **Colophon** turns the
  paradox into a lesson on hashing plus a capstone lab that recomputes and verifies the note's
  own identifier (`git archive HEAD | swh identify --type directory`).

## Sourcing / reuse map (summary)

- **Prose & structure:** ~70 % already exists in `common/modules/` (paths above) and in the
  three articles; the AEC guide supplies Ch. 4 wholesale.
- **Bibliography:** copy `../2026-06-AEC-guide/references.bib` verbatim (canonical citekeys +
  `biblatex-software` entries); extend only as new chapters cite more.
- **Figures:** reuse from `slides/common/images/` (archive-growth, hal-swh-overview,
  acm-artifact-badges, SWH-nutshell, BibLaTeX-swh, Merkle diagrams) — copy into `figures/`
  with attribution; check each is committed/clean (`make check-assets` discipline).

## Toolchain and repository layout

```
2026-course-research-software/
  main.tex                 % report, xelatex, biblatex(datamodel=software)+software-biblatex
  preamble.tex             % fonts (TeX Gyre Pagella), SWH title, hands-on/takeaway envs, swhid stamp
  chapters/01-why.tex … 06-outlook.tex
  appendix/{A-cookbook,B-swhid-syntax,C-glossary}.tex
  colophon.tex             % self-archival SWHID + hashing lesson + capstone lab
  references.bib           % copied from ../2026-06-AEC-guide/
  figures/  logos/SWH-logo.pdf
  Makefile                 % `make` -> main.pdf ; `make swhid SWHID=...` -> stamped (non-committed) PDF
  README.md  LICENSE
```

Build: `latexmk -xelatex main.tex` (biber auto-run). Bibliography options:
`\ExecuteBibliographyOptions{halid=true,swhid=true,swlabels=true,vcs=true,license=true}`.

## Phased execution

1. **Scaffold** the repo: class, preamble, branded title, `Makefile`, copy `references.bib`,
   stage figures, empty chapter files. Build a "hello" PDF. *(git init + initial commit.)*
2. **Ch. 0–2** (framing + foundations) — lift and rewrite from modules.
3. **Ch. 3** (ARDC in practice) — the operational core; add hands-on boxes.
4. **Ch. 4** (reproducibility & AEC) — port the AEC guide to LaTeX; integrate Spinellis.
5. **Ch. 5 + appendices + glossary** — policy/outlook; cookbook; cheat-sheet.
6. **Polish pass:** figures, key-takeaways, cross-references, index; full build; proofread;
   archive the note in SWH and add its self-citation.
7. *(Optional, later)* tagged 3-hour cut for live delivery; Italian edition for GARR.

## Open questions to confirm before/while drafting

*(Settled since the first draft: spine, audience, language, build toolchain, CC-BY-4.0
license, inclusion of hands-on labs, and the self-verification capstone in the Colophon.)*

- **Figure permissions/sourcing:** confirm reuse rights for any third-party images.
- **Depth on the data model** (Ch. 2): how technical to go on the Merkle DAG / graph dataset
  for a cross-disciplinary doctoral audience (proposed: conceptual, with a "go deeper" pointer
  to `pietri2019graph` / the ecosystem survey).

## Verification

- `latexmk -xelatex` builds clean (no undefined refs/citations; biber resolves all keys).
- `pdfinfo` confirms page count in the 40–60 pp target; render-and-read the title, a
  `biblatex-software` reference, and one figure page to confirm branding and citation styling.
- Every SWHID example resolves at `https://archive.softwareheritage.org/<swhid>` and verifies
  with `swh identify --verify` where applicable.
