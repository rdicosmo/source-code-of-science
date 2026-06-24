# Voice & style guide

Distilled from RDC's own writing — the *Linear Logic* course book (`LLBook`), the
*Semantica M1* notes (French), and the English publications (CACM 2018, TPDL 2022, SEN 2020,
the SWH ecosystem chapter 2023, ICSE-FoSE 2026). The three corpora converge strongly; this
is the target voice for drafting the course note.

## The two arcs to write to

**Macro (per chapter / section): stakes → gap → mission → call.**
1. *Elevate the object* — open by asserting that source code is precious, human-readable
   knowledge and a pillar of science and society.
2. *Pivot into the gap* — the trademark **"And yet,"**: we have not taken good care of it;
   it is lost, fragile, unrecognised.
3. *The answer* — archive, reference, the SWHID, the practice.
4. *Call to action* — inclusive-"we" duty + urgency, ideally an emphatic one-liner.

**Micro (per concept): motivate → intuition → formalise → verdict.**
1. *Never open with a bare definition.* Pose a felt problem or a naive question first
   (often literally quoted: *"is there a way to name code so the name can't lie?"*).
2. *Name the intuition explicitly, then show where it breaks*: "This **seems** to capture
   what we want, but…". Analogy to something familiar to make the construction feel
   inevitable.
3. *Then* give the precise definition / mechanism.
4. *Close with a short, blunt verdict* — one line, often italic-emphatic.

## Stance & person

- **Inclusive "we"** is the workhorse — authors + reader + the whole discipline ("we have
  not been taking good care of this precious form of knowledge"). Rarely "I".
- **Address the reader directly as "you"**, and use the hortative **"let us / let's"** to
  open a move ("let's look at a couple of examples", "let us be clear about…").
- **Be opinionated, not neutral.** Flag your own bias rather than hiding it (the LL book is
  "deliberately partisan"). Editorialise: a stance is part of the pedagogy.
- **Honest about limits**: "not all of them, and not only, unfortunately."

## Sentence-level habits

- **Rhythm:** long, clause-stacked, accreting sentences — commas, colons, em-dashes — then a
  short punchy closer. Vary deliberately; let the verdict be a fragment if it lands.
- **Colon-as-pivot:** set up an idea, colon, deliver the payload or the list.
- **Em-dash and parenthetical asides** for caveats, pointers, and wit — used liberally.
- **Italics on the one load-bearing word** at first mention (the term being defined): *source
  code*, *intrinsic*, *snapshot*. Italic = "carry this away".
- **Triads / tricolons** are a signature: "collect, preserve, and share"; "it runs, it
  evolves, it depends on a thousand other things".
- **Rhetorical questions as section hinges**, sometimes answered "Apparently yes… Unfortunately…",
  sometimes left open ("(why?)").

## Signposting lexicon (use these connectives)

- Pivot to the complication: **"And yet,"**, **"Now,"**, **"However / Yet"**.
- Confirm / explain: **"Indeed,"**, **"In fact,"**, **"Recall that"**, **"Note that"**,
  **"Of course"**, **"as we will see"**.
- Draw the lesson: **"In short,"**, **"To sum up,"**, **"Hence,"**, **"First and foremost,"**,
  **"Last, but not least,"**, **"On the one hand … On the other hand …"**.
- Open a maneuver / example: **"Let's see…"**, **"Here's the thing:"**, **"Since an example
  is worth a thousand words, let's look at…"**.
- Honest hedges where due: **"typically"**, **"often"**, **"for simplicity"** —
  but never hedge the thesis.

## Value lexicon (recur on these)

*pillar · heritage / cultural heritage · commons / software commons · infrastructure /
common infrastructure · intrinsic (identifier) · universal · long-term / long-lasting ·
precious · first-class citizen · sovereignty · stakeholders · mission · non-profit ·
for the benefit of society as a whole · proactively.* Source code is "a precious, unique
form of knowledge."

## Pedagogical devices

- **Worked examples carry the argument** — small, concrete, runnable; the moral comes after.
  Keep the standing nudge to *go do it yourself* ("verify this with `swh identify`").
- **War stories as motivation** — earn the formalism by first showing the failure (forges
  shutting down; a result that won't rebuild). A touch of wit is welcome.
- **Authority quotes** for gravitas (bank below).
- **A framed takeaway thesis per unit** — we already have `\takeaway{}` margin notes and the
  `handson` box; lean on them. One quotable sentence per section.
- **Exercises / hands-on are essential, not decoration** — say so, and make them stress-test
  the idea just presented.

## Analogy bank (his, reuse them)

- **Fingerprint / git's content-naming** → the SWHID (Ch. 2–3).
- **ISBN: identification vs location are separate concerns** → intrinsic vs extrinsic
  identifiers (Ch. 2).
- **"Forges are not archives"** (his line) → preservation (Ch. 2, 6).
- **Library of Alexandria / cultural heritage** → archiving & preservation (Ch. 1, 6).
- **A very large telescope to explore the software-development galaxy** → the graph / big-code
  angle (Ch. 6).
- **Router / ports** style concrete pictures for an otherwise abstract mechanism.

## Quote bank (for gravitas)

- Abelson (1985): *"programs must be written for people to read, and only incidentally for
  machines to execute."*
- Shustek: source code is *"a view into the mind of the designer."*
- GPL: source code is *"the preferred form for a developer to make a change to a program."*

## Don'ts

- Don't lead with a definition; don't be neutral where a stance is warranted.
- Don't over-polish into sterile textbook English — keep the warm, lecture-from-the-blackboard
  cadence. Fluent, but personal.
- Don't let a bullet list stand un-narrated — the voice lives in the prose *between* the
  bullets.
- Don't hedge the thesis.

## House facts & conventions

- **SWHID = Software Hash Identifier** (intrinsic, ISO/IEC 18670). *Not* "Software Heritage
  Identifier" — the acronym was redefined with the spec/ISO. Use the *Hash* reading throughout.
- **Cite densely** — match the citation density of his published writing; back every claim,
  statistic, and historical fact with a reference rather than leaving it bare.
- **Figures earn their place** — real, concrete, captioned, attributed (archive growth, the
  French Open Science Monitor, a real dependency graph), never decorative. Watch licences:
  CC-BY-NC images (e.g. xkcd) don't sit cleanly in a CC-BY work — prefer generated/licensable.
- **For FAIR**, remember that *interoperable* and *reusable* already have precise, different
  meanings in software engineering — say so; it is the crux of the "beyond FAIR" argument.

## Three model sentences in-voice (seeds for Ch. 1–2)

> Software source code is a precious, unique form of knowledge: readily turned into something
> a machine can run, and yet meant to be read by people. It is a pillar of modern research, in
> every field from mathematics to biology. **And yet,** when a published result rests on code,
> that code is too often the first thing we lose.

> FAIR was built for data. Software is not data — it runs, it evolves, it depends on a thousand
> other things — and bolting the data checklist onto it keeps the letter while missing the
> point. *So let us be clear about what we keep from FAIR, and where we must go beyond it.*

> Recall the everyday trick behind git: name a thing by a fingerprint of its content. Change
> one byte and the fingerprint changes; leave it untouched and anyone, anywhere, recomputes the
> very same name — no registry, no authority, no trust required. The name is **forced to follow
> the bytes.**
