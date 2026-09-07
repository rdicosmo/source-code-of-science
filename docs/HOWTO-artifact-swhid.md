# HOWTO: computing and checking the SWHID of a research artifact

This is the maintained companion to Appendix G (*A model artifact-evaluation section*) of
*The Source Code of Science*. The appendix states the rule and one recipe, and is written to
survive tool churn. **This file carries everything that is version-, tool- and
platform-dependent**, so that the book does not rot.

If you have five minutes, read §1 and §2 and stop. If your identifier does not match, go
straight to §11.

---

## Maintenance status

| | |
|---|---|
| **Last verified** | 2026-09-08 |
| **`swh.model`** | 6.15.0 (`swh.core` 3.4.0), Python 3.11, installed as a `uv` tool |
| **git** | 2.47.3 |
| **Platform** | Linux (Debian 13, kernel 6.18) |
| **Archive checked against** | `archive.softwareheritage.org`, live, 2026-09-08 |

Every command below was executed on that configuration before this file was committed. Where a
claim could **not** be verified here, it is labelled **UNTESTED** or **UNVERIFIED HERE** inline,
with the reason. Nothing in this file is asserted from documentation alone.

Expect to re-verify: the `swh identify` option list (§5 and §12 record two flags that the
appendix and the command cookbook once claimed and that do not exist), the availability of the
Rust implementation (§13), and Git LFS behaviour (§8), which is the largest untested gap.

Authoritative references, in order of precedence:

1. The SWHID specification — ISO/IEC 18670, and <https://www.swhid.org>
2. `swh identify --help` on *your* installed version — always beat this file
3. Software Heritage developer docs — <https://docs.softwareheritage.org/devel/swh-model/persistent-identifiers.html>

---

## 1. The rule

> **A SWHID in this workflow always names a *clean tree*.**
>
> For a git-managed artifact that means the **committed** tree — never the directory you are
> working in. For any other artifact it means the content of the **exact bundle you ship**,
> unpacked into an empty directory.
>
> For a git artifact the directory SWHID is bit-for-bit the git tree hash:
>
> ```
> swh:1:dir:$(git rev-parse <commit>^{tree})
> ```
>
> which is also exactly what Software Heritage stores. **Nobody — author, reviewer, or
> committee — ever hashes a live working copy.**

That last sentence is the whole document. Everything else is either a way of producing a clean
tree, or an explanation of what goes wrong when you don't.

**Verified end to end**, against the production archive, on this book's own repository at commit
`d7263e66ea4d96ba28df3ef5af3700bc21327434`:

```
local clean export   : swh:1:dir:a53cbfce5692dd6b375af39965089e3a4301905a
local git tree       : swh:1:dir:a53cbfce5692dd6b375af39965089e3a4301905a
archive-held dir     : swh:1:dir:a53cbfce5692dd6b375af39965089e3a4301905a
```

Three independently produced numbers — a local export, a local git command, and the directory
that Software Heritage actually holds for that revision — and they are the same number. That
coincidence *is* the guarantee the whole scheme rests on.

For contrast, hashing the working copy of that same repository at that same commit gives
`swh:1:dir:4166069b465ffddfbd240a91ef4d53929b9816f6`. See §2.

---

## 2. The canonical procedure

There are two phases with two different primary sources. The right source differs before and
after archival, and it matters that you use the right one.

**Fallback ordering, in one sentence:** use the archive's value when the artifact is archived;
use the clean-export value when it is not; when both exist they must coincide, and that
coincidence is itself the end-to-end check.

### Phase A — before archival: compute from a clean export

Use this at submission, at every revision, and for **all** double-blind work. In this phase it is
not merely the primary method, it is the *only* one: the artifact is not in the archive yet, and
for a double-blind venue it must not be — running Save Code Now on your own repository publishes
the origin URL and deanonymises you.

**For a git-managed artifact — three commands:**

```sh
EXPORT=$(mktemp -d)
git archive HEAD | tar -x -C "$EXPORT"
swh identify --no-filename --type directory "$EXPORT"
```

**Then the self-check. This is mandatory, and it is one command:**

```sh
echo "swh:1:dir:$(git rev-parse HEAD^{tree})"
```

The two must print the same string. If they do not, your tree is not clean, or you are in one of
the two documented divergence cases (submodules, §7; LFS, §8) — **stop and diagnose, do not
submit the number.**

Scripted, with the check built in:

```sh
EXPORT=$(mktemp -d)
git archive HEAD | tar -x -C "$EXPORT"
swh identify --no-filename --verify "swh:1:dir:$(git rev-parse HEAD^{tree})" \
             --type directory "$EXPORT"
```

`--verify` prints `SWHID match` and exits **0**, or `SWHID mismatch: <expected> != <computed>`
and exits **1**. Both verified.

Substitute any commit-ish for `HEAD` — a tag, a branch, a full hash. Use the same one in both
commands (§4.4).

**For a non-git artifact:** unpack **the very tarball or zip you are submitting** into a fresh,
**empty** directory and hash that (§4.5). Do not hash the directory you built the tarball from —
it is a working copy by another name.

The identifier you record is then, by construction, the number a reviewer's unpack will
reproduce and the number the archive will later hold.

### Phase B — camera-ready: take the identifier from the archive

After acceptance, archive the repository through Save Code Now
(<https://save.softwareheritage.org>), then take the **qualified** SWHID from the archive's
**Permalinks** tab (§6).

Its core `dir` hash **must equal the Phase-A identifier recorded at the close of evaluation**.
Verify that equality before you submit the camera-ready. If it differs, then either

- the archived version is genuinely not the evaluated version — label both, "as evaluated" and
  "as published"; or
- a procedural error occurred — go to §11.

---

## 3. The working-copy hazard

This is the thing everyone gets wrong, so here it is measured rather than asserted.

### 3.1 `swh identify` has no idea git exists

It is a **pure filesystem walk**. It does not read `.gitignore`, it does not consult the index,
and it descends into `.git/` and hashes every byte of it. Demonstration on a three-file repository:

```
working copy                 : swh:1:dir:1f57f3ad15e42674f46475b1c17d81f16c2e5ad7
clean export (git archive)   : swh:1:dir:87127eea5ab329c798b9923b3d752637b034f16c
git rev-parse HEAD^{tree}    : swh:1:dir:87127eea5ab329c798b9923b3d752637b034f16c
```

The only difference between the two trees is the presence of `.git/`. The identifiers are not
"close" — they are unrelated 160-bit values. And note which one equals the git tree.

Proof that `.git/` is what is being hashed — create one file inside it and nothing else:

```
default                          : swh:1:dir:1f57f3ad15e42674f46475b1c17d81f16c2e5ad7
after creating .git/HEAD.probe   : swh:1:dir:e71e6b02ad4af86e454b132d42df8c8b7fb803f2
after deleting it again          : swh:1:dir:1f57f3ad15e42674f46475b1c17d81f16c2e5ad7
```

### 3.2 The working-copy identifier is not stable over time

This is the damaging part. Take a clean repository, make a commit, and undo it:

```sh
swh identify --no-filename --type directory .      # baseline
printf 'x = 1\n' > src/extra.py && git add -A && git commit -q -m second
git reset -q --hard HEAD~1
git status --porcelain                              # empty: clean, back at commit 1
```

Measured:

```
baseline working copy       : swh:1:dir:1f57f3ad15e42674f46475b1c17d81f16c2e5ad7
after commit + reset --hard : swh:1:dir:ffbdead55d3d0ff6eca320e8f5b4bb981bb1a0fe
after a subsequent git gc   : swh:1:dir:fcc75122c47d0a3f6e67e41a000378c3e9b7788b

git rev-parse HEAD^{tree}   : 87127eea5...  ← UNCHANGED throughout
git status --porcelain      : (empty)       ← clean throughout
```

**Three different identifiers for one unchanged commit.** Identical tracked content, identical
commit, clean `git status`, unchanged git tree — and the working-copy hash moved twice, purely
from loose objects and reflog entries left behind inside `.git/`. It also moves on `git fetch`,
on a branch switch and back, and on routine background `gc`.

It is worse than that: the same recipe run by two different people produces two different
working-copy hashes, because their `.git/` differs in config, timestamps and reflog. **An
identifier that its own author cannot reproduce tomorrow, and that no one else can reproduce at
all, is not an identifier.**

### 3.3 `-x '*.git'` is *not* the fix

`swh identify` has an `--exclude`/`-x` glob. On a pristine repository `-x '*.git'` does happen to
give the git tree hash. Do not rely on it. Every ordinary piece of workspace clutter moves it,
because excluding `.git` does nothing about everything else:

| Working copy contains | `swh identify .` | `-x '*.git'` | `git archive` export |
|---|---|---|---|
| clean checkout | `119e808b…` | `27cd7f70…` | **`27cd7f70…`** |
| `+` untracked `build.o` | `f53b8865…` | `d6279c7b…` | **`27cd7f70…`** |
| `+` `src/__pycache__/` | `2bd6a822…` | `6e6adb48…` | **`27cd7f70…`** |
| `+` `node_modules/` | `1a1abb47…` | `a47c423d…` | **`27cd7f70…`** |
| `+` untracked `.gitignore` | `8f7f137b…` | `6818f85c…` | **`27cd7f70…`** |
| `+` editor backup `hello.py~` | `09dbbf56…` | `e5d825b5…` | **`27cd7f70…`** |
| `+` `.venv/` | `a96de272…` | `32db5a8c…` | **`27cd7f70…`** |

Read the columns, not the rows. **Both working-copy columns move on every single line. The
`git archive` column never moves at all.** Note rows 4 onward in particular: those files are
listed in `.gitignore`, and they still change the hash — `swh identify` does not read
`.gitignore`.

This is not a table of things to remember to delete. It is the argument for never hashing a
working copy in the first place.

### 3.4 A real example

On this book's own repository, right now, at `HEAD`:

```
clean export of HEAD      : swh:1:dir:a53cbfce5692dd6b375af39965089e3a4301905a  ← correct
git rev-parse HEAD^{tree} : swh:1:dir:a53cbfce5692dd6b375af39965089e3a4301905a  ← agrees
naive: hash the checkout  : swh:1:dir:4166069b465ffddfbd240a91ef4d53929b9816f6  ← wrong
```

At the time of measurement that checkout carried several dozen untracked-or-ignored entries —
LaTeX build products, editor backups, TODO files, scratch directories. Count yours with:

```sh
git status --porcelain --ignored | grep -c '^[?!]'
```

Any non-zero answer means the naive number is wrong. A working repository essentially always
gives a non-zero answer, which is the point: this is the normal state, not a corner case.

---

## 4. Recipe reference

### 4.1 `git archive` — the default

```sh
EXPORT=$(mktemp -d)
git archive <commit-ish> | tar -x -C "$EXPORT"
swh identify --no-filename --type directory "$EXPORT"
echo "swh:1:dir:$(git rev-parse <commit-ish>^{tree})"   # must match
```

Preferred: it touches nothing, needs no cleanup, and cannot pick up stray files because the
tarball is generated from the object database rather than from the filesystem.

Note `git archive` honours `export-ignore` attributes in `.gitattributes`. If your repository
sets any, the export will legitimately differ from the git tree and the self-check will fire.
Check with `git check-attr -a --cached $(git ls-files) | grep export-ignore`.

### 4.2 `git worktree` — when you need a real checkout

Use this if you need to *run* something in the exported tree (a build, a test) as well as hash it.

```sh
EXPORT=$(mktemp -d)/tree
git worktree add -q --detach "$EXPORT" <commit-ish>
rm -rf "$EXPORT/.git"                                   # ← do not forget this
swh identify --no-filename --type directory "$EXPORT"
```

Verified to give the identical answer to §4.1.

**Cleanup gotcha, verified:** once you have deleted `.git`, `git worktree remove` refuses —
`fatal: validation failed, cannot remove working tree: '…/.git' does not exist`. Clean up with:

```sh
rm -rf "$EXPORT" && git worktree prune
```

**Do not** run a build in the tree *before* hashing it. That reintroduces exactly the pollution
of §3.3. Hash first, then build.

### 4.3 A subdirectory of a monorepo

When the artifact is one directory of a larger repository, address the subtree directly. Note the
`:` syntax, and note that the self-check uses a *different* form (`HEAD:path`, no `^{tree}`):

```sh
EXPORT=$(mktemp -d)
git archive HEAD:artifact | tar -x -C "$EXPORT"
swh identify --no-filename --type directory "$EXPORT"
echo "swh:1:dir:$(git rev-parse 'HEAD:artifact')"       # must match
```

Verified: both give `swh:1:dir:7ae8a6b3ee9230c3fbb17f0c0684388772730a51`, while the whole-repo
tree is `484581f99222d63164a2a010844c555712241a5b`.

The exported tree is rooted **at** `artifact/`, so the top level of the export contains
`README.md` and `src/`, not a wrapper directory named `artifact`. Say which subdirectory the
identifier names when you report it; the hash alone does not say.

### 4.4 A tag rather than a branch tip

```sh
git archive v1.0 | tar -x -C "$EXPORT"
echo "swh:1:dir:$(git rev-parse 'v1.0^{tree}')"
```

Verified equal. `^{tree}` peels an annotated tag through to its commit and then to the tree, so
the same self-check works for lightweight and annotated tags alike.

Record which commit you meant alongside the directory identifier — `git rev-parse
'v1.0^{commit}'`. A `dir` SWHID names a tree; it does not tell anyone which commit produced it.
That is what the `anchor` qualifier is for (§6).

### 4.5 A non-git artifact (tarball or zip)

Hash **the bundle you are actually shipping**, unpacked into a **fresh empty directory**:

```sh
EXPORT=$(mktemp -d)                      # must be empty
tar -xzf artifact-1.0.tar.gz -C "$EXPORT"
ls "$EXPORT"                             # ← look: is there a wrapper directory?
swh identify --no-filename --type directory "$EXPORT"
```

Two failure modes, both common:

- **Extracting into a non-empty directory.** Verified: adding one stray `NOTES.txt` to an
  otherwise correct extraction changed the identifier from `484581f9…` to `f0ad4126…`. Always
  `mktemp -d`.
- **The wrapper directory.** Most release tarballs unpack to a single top-level directory such as
  `artifact-1.0/`. You must then decide, and *state*, whether your identifier names `$EXPORT` or
  `$EXPORT/artifact-1.0` — they are different trees with different hashes. Convention: name the
  directory that contains the artifact's own root (the one holding its `README`), i.e. usually
  `$EXPORT/artifact-1.0`, and say so in the artifact appendix.

There is no self-check available in this case; there is no git tree to compare against. That is
precisely why §2 insists you hash the shipped bundle and not a build directory.

### 4.6 Command notes

- `--no-filename` prints the bare identifier with no trailing path, which is what you want for
  scripting and for pasting into a paper. Without it you get `swh:1:dir:<hex>\t<path>`.
- `--type directory` is worth stating explicitly even though `auto` would infer it. It documents
  intent and it fails loudly if you point at a file by mistake.
- `swh` writes `WARNING:swh.core.sentry: Sentry DSN not provided…` to **stderr** on every
  invocation. It is harmless noise; stdout is clean. Add `2>/dev/null` in scripts.
- `--dereference` affects only paths passed as *arguments*, not symlinks encountered inside the
  tree. Verified: a tree containing a symlink hashes identically with and without the flag.
  Symlinks inside a tree are always hashed as symlinks, never followed.

---

## 5. Permissions

### 5.1 There is no `--permissions-source` flag

**Verified on `swh.model` 6.15.0:**

```
$ swh identify --permissions-source=git-index /tmp
Error: No such option: --permissions-source
```

and the string does not occur anywhere in the installed `swh/model/` source tree. Earlier drafts
of the book's Appendix G and of the command cookbook claimed this flag existed and told authors
to reach for it when a directory check failed. **It does not exist, and the advice was a
misdiagnosis besides** — the dominant cause of a directory mismatch is `.git/` and workspace
pollution (§3), not permission bits.

If some future version introduces such an option, this section is where to record it. Do not
reintroduce it into the book.

### 5.2 What actually affects the hash: the executable bit, and nothing else

From the model source (`swh/model/from_disk.py`, `mode_to_perms`), a filesystem walk maps every
entry to exactly one of four values: `content` (`100644`), `executable_content` (`100755`),
`symlink` (`120000`), `directory` (`040000`). The test for executable is `mode & 0o111`.

Measured consequences:

**Read/write bits are irrelevant.** `chmod 600`, `chmod 400` and `chmod 644` on the same file all
produce the identical directory SWHID (`1dff3ab7…`).

**`umask` is irrelevant.** Extracting the same `git archive` output under three different umasks
gives three different sets of on-disk modes and one identical identifier:

| umask | on-disk modes | directory SWHID |
|---|---|---|
| `022` | `-rw-r--r--`, `-rwxr-xr-x` | `1dff3ab7656a232c511153a8110b38f961e5835e` |
| `077` | `-rw-------`, `-rwx------` | `1dff3ab7656a232c511153a8110b38f961e5835e` |
| `002` | `-rw-rw-r--`, `-rwxrwxr-x` | `1dff3ab7656a232c511153a8110b38f961e5835e` |

**Any execute bit counts.** `744`, `614` (group-execute only) and `645` (other-execute only) all
give the same "executable" identifier `d4df3bd1…`; `644` gives `5c6328cd…`. So a filesystem or
extraction path that grants `g+x` or `o+x` to a file that git records as non-executable *will*
change the hash, even though no ordinary tool would report a permission problem.

**A committed mode change changes the tree; an uncommitted one does not.** Verified:

```
committed non-executable          → export swh:1:dir:d972b0ed8ac70b5e3d1da134fd5a24884dd6290b
chmod +x, NOT committed           → export swh:1:dir:d972b0ed8ac70b5e3d1da134fd5a24884dd6290b   (unchanged)
                                    git status: " M run.sh"
chmod +x, committed               → export swh:1:dir:1dff3ab7656a232c511153a8110b38f961e5835e   (changed)
```

This is the correct caveat to pass to authors, and it is narrower and more useful than the one it
replaces: **git records one bit per file, so only the executable bit can move a directory SWHID
via permissions — and if you `chmod +x` without committing, your clean export will not reflect
it.** Run `git status` before you export; that is what the dirty-tree warning is for.

---

## 6. Getting the identifier from the archive (Phase B)

1. Archive the repository at <https://save.softwareheritage.org>. No account needed; normally
   completes within hours. Archive the **repository**, history included — not a tarball.
2. Browse to the exact version in the archive, navigate to the artifact's directory, and open the
   **Permalinks** tab.
3. Choose the **directory** object and enable the qualifier checkboxes (`origin`, `visit`,
   `anchor`, `path`). Copy the qualified SWHID.

A qualified identifier looks like this — this one is real and was verified to resolve
(HTTP 200, redirecting to the browse view anchored at the revision):

```
swh:1:dir:a53cbfce5692dd6b375af39965089e3a4301905a;origin=https://github.com/rdicosmo/source-code-of-science;anchor=swh:1:rev:d7263e66ea4d96ba28df3ef5af3700bc21327434
```

**Check it against your Phase-A number.** The part before the first `;` is the core identifier
and it must equal what you recorded at the close of evaluation. Here it does:
`a53cbfce5692dd6b375af39965089e3a4301905a`, the same value produced by `git archive` and by
`git rev-parse` in §1.

### Cross-checking without the web UI

The same values are reachable from the API, which is what to use when you want to script the
check or when you do not trust a copy-paste:

```sh
ORIGIN=https://github.com/rdicosmo/source-code-of-science
SNP=$(curl -sS "https://archive.softwareheritage.org/api/1/origin/$ORIGIN/visit/latest/" \
      | python3 -c 'import json,sys; print(json.load(sys.stdin)["snapshot"])')
REV=$(curl -sS "https://archive.softwareheritage.org/api/1/snapshot/$SNP/" \
      | python3 -c 'import json,sys; print(json.load(sys.stdin)["branches"]["refs/heads/main"]["target"])')
curl -sS "https://archive.softwareheritage.org/api/1/revision/$REV/" \
      | python3 -c 'import json,sys; d=json.load(sys.stdin); print("rev:", d["id"]); print("dir:", d["directory"])'
```

Verified output: `rev: d7263e66…`, `dir: a53cbfce…`, and `git rev-parse d7263e66…^{tree}` locally
gives `a53cbfce…`. **This is the concrete proof that the archive stores the git tree hash** — it
is not an implementation detail to be taken on faith, it is checkable in four commands.

### A note on revision identifiers

A Software Heritage revision SWHID *is* the git commit hash:

```sh
echo "swh:1:rev:$(git rev-parse HEAD)"
```

`swh identify` in 6.15.0 offers **no** `--type revision` and no `--type release` — verified,
`-t` accepts only `auto|content|directory|origin|snapshot`. Construct revision SWHIDs with the
`echo` above. Do not report a `rev` SWHID as the artifact identifier, though: the appendix asks
for the `dir`, because that is what a reviewer with a tarball can check.

---

## 7. Submodules — a real divergence

**If your artifact contains git submodules, the §2 self-check will fail, and it is right to.**

A git tree records a submodule as a *gitlink*: mode `160000`, pointing at a commit in another
repository.

```
$ git ls-tree HEAD vendor/
160000 commit 856aac7660344736528ef6082b4dd200f4710d74	vendor/lib
```

`git archive` cannot export that — it writes an **empty directory** in its place. Verified:

```
git tree                            : swh:1:dir:e716728c919557d0cea62be66f59ccec9db9d1d2
git archive export                  : swh:1:dir:2ca4bb4cabbc64e396d5713aefae9710adb64d71
git worktree export (.git removed)  : swh:1:dir:2ca4bb4cabbc64e396d5713aefae9710adb64d71
```

Both clean-export methods agree with each other and **neither** equals the git tree.

`git archive --recurse-submodules` **does not exist** — verified, git 2.47.3 exits 129 with
`error: unknown option 'recurse-submodules'`.

The gap is structural, not a bug you can work around with a flag. `swh.model`'s `DentryPerms`
enum does contain a `revision = 0o160000` value — the model can *represent* a gitlink, which is
how the archive ingests one from git — but `mode_to_perms`, the function that maps a filesystem
`stat` mode, can only ever return `content`, `executable_content`, `symlink` or `directory`.
**A filesystem walk can never produce a gitlink entry, so `swh identify` over any exported tree
can never reproduce the git tree hash of a repository containing submodules.**

The archive, having ingested from git, holds the gitlink and therefore the git tree hash
(`e716728c…` here). So for a submodule-bearing artifact, the Phase-A and Phase-B numbers will
legitimately differ. What to do:

- **Preferred:** avoid the problem. Vendor the dependency as ordinary committed files, or ship
  the artifact as a tarball with submodule content included and identify it per §4.5. Artifact
  evaluation wants a self-contained artifact anyway.
- **If you must keep submodules:** report `swh:1:dir:$(git rev-parse HEAD^{tree})` as the
  identifier — that is the value the archive will hold — and state explicitly in the artifact
  appendix that the artifact contains submodules, so a reviewer knows that a plain unpack-and-hash
  will not reproduce it. Also report the submodule commits.
- Either way, **say which you did.** An unexplained mismatch is the failure this document exists
  to prevent.

---

## 8. Git LFS — **UNTESTED**

**Git LFS is not installed on the machine this file was verified on** (`git lfs version` →
`git: 'lfs' is not a git command`), so nothing in this section has been measured. Treat it as a
hypothesis to be checked, not as guidance.

The expected hazard: under LFS, the git tree stores small **pointer files** (a few lines of text)
rather than the real blobs. `git archive` reads the object database, so an export is expected to
contain pointer files, while a working copy with LFS smudge filters active contains the real
content. Two different trees, two different identifiers — and the archive would be expected to
hold the pointer-file version, since that is what git ingestion sees.

**Before relying on any of that, measure it**, and record the result here:

```sh
git archive HEAD | tar -x -C "$EXPORT"
head -3 "$EXPORT/<an-lfs-tracked-file>"    # pointer file, or real content?
swh identify --no-filename --type directory "$EXPORT"
echo "swh:1:dir:$(git rev-parse HEAD^{tree})"
```

If the artifact's substance lives in LFS objects, the honest move is to ship it as a tarball with
the real content and identify that per §4.5, stating what you did.

---

## 9. What a reviewer with only a tarball can and cannot do

### 9.1 What you CAN verify — offline, trustlessly, in under a minute

That the tree you unpacked **is** the object the authors named.

```sh
EXPORT=$(mktemp -d)                       # fresh and empty
tar -xzf submitted-artifact.tar.gz -C "$EXPORT"
swh identify --no-filename --verify "swh:1:dir:<the identifier on record>" \
             --type directory "$EXPORT"
```

Exit 0 and `SWHID match` is a **proof of bit-for-bit identity**. No account, no login, no network,
no service consulted. Verified round-trip: an author's export hashed `484581f9…`, was tarred,
shipped, and unpacked by a "reviewer" into a fresh directory, and hashed `484581f9…`.

This claim is the whole point of the scheme and it survives intact.

### 9.2 What a mismatch means

**The comparison contains no judgement. The interpretation does.** Do not conflate them.

Inequality proves exactly one thing: two different trees were hashed. It carries **zero**
information about how different they are, or who erred. A one-character typo in a comment and a
wholesale substitution of the artifact produce equally different identifiers. And in practice the
commonest cause is procedural — someone hashed a working copy — not a changed artifact.

**Therefore: a mismatch triggers the §11 checklist first. Report it as a finding only if it
survives diagnosis.** When you do report it, state the identifier you obtained and the procedure
you used. Never state an accusation. "I unpacked `artifact.tar.gz` into an empty directory and
computed `swh:1:dir:<x>`, which differs from the recorded `swh:1:dir:<y>`" is a finding. "The
authors changed the artifact" is not — you cannot know that.

### 9.3 What you CANNOT verify

Be clear-eyed about the limits; the check is strong precisely because its scope is narrow.

- **Before acceptance you cannot verify anything about the archive.** The artifact is not there,
  and for a double-blind venue it must not be. The check is purely local. Any procedure telling a
  reviewer to "resolve the identifier in the archive" at review time is wrong for double-blind
  submissions.
- **You cannot verify that the submitted tree corresponds to any commit in the authors'
  repository.** That repository is hidden from you. The link between the evaluated tree and a
  named origin is established only at camera-ready, when qualifiers are added.
- **You cannot verify a `dir` identifier by resolving it.** Resolution is *by* hash: the archive
  looks up the object whose hash you gave it. It cannot hand back a different hash, so
  "resolve the identifier and confirm it presents the same core hash" is a tautology that tests
  nothing.

  The genuine post-acceptance check is: **resolve the camera-ready qualified SWHID, confirm it
  resolves at all** — that proves the object is archived — **and confirm its core `dir` hash
  equals the identifier the committee recorded at the close of evaluation.** That compares an
  archive-held object against an independently produced committee record, which is a real check.
- **You cannot verify the archived bytes without downloading them.** Resolving shows you a hash
  the archive computed. For full trustlessness, download the tree and recompute it yourself. See
  §9.4 — this works, and it was verified end to end.

### 9.4 Recomputing from the archive's own bytes (the Vault)

This closes the last trust gap: instead of believing the hash the archive displays, download the
tree and hash it yourself. Verified end to end on 2026-09-08.

Directory downloads go through the **Vault**, which is a cook-then-fetch service, not a plain
GET. Three steps:

```sh
D=swh:1:dir:a53cbfce5692dd6b375af39965089e3a4301905a

# 1. request cooking (POST, not GET)
curl -sS -X POST "https://archive.softwareheritage.org/api/1/vault/flat/$D/"

# 2. poll until "status":"done"
curl -sS "https://archive.softwareheritage.org/api/1/vault/flat/$D/"

# 3. download — the -L is REQUIRED, the raw endpoint redirects
curl -sSL -o tree.tar.gz "https://archive.softwareheritage.org/api/1/vault/flat/$D/raw/"

# 4. recompute
V=$(mktemp -d); tar -xzf tree.tar.gz -C "$V"
swh identify --no-filename --type directory "$V/$D"
```

Three gotchas, all of which cost a wrong answer if missed:

- **Step 1 is a POST.** A bare GET on an un-cooked directory returns HTTP 404 with
  `"reason":"Cooking of swh:1:dir:… was never requested."` — that is *not* "the object is
  missing".
- **Step 3 needs `-L`.** Without it curl writes a **0-byte file** and `tar` fails with
  `unexpected end of file`. Measured: 0 bytes without `-L`, 6 357 650 bytes with it.
- **The bundle contains a wrapper directory named after the SWHID.** It extracts to
  `swh:1:dir:<hash>/`, so hash `"$V/$D"`, not `"$V"` (cf. §4.5).

Cooking took roughly 40 seconds for this 6 MB directory. Verified result:

```
recomputed from the archive's own bytes : swh:1:dir:a53cbfce5692dd6b375af39965089e3a4301905a
expected                                : swh:1:dir:a53cbfce5692dd6b375af39965089e3a4301905a
```

There is also a `.../api/1/vault/git-bare/<rev-swhid>/` flavour for whole repositories. **UNTESTED
here.** Note that `https://archive.softwareheritage.org/api/1/directory/<hash>/?format=tar.gz` is
**not** a valid download URL — it returns HTTP 500 (`Http404`). Use the Vault.

---

## 10. Platform notes

- **`umask` does not matter.** Verified in §5.2 across `022`, `077` and `002`. This is a common
  worry and it is unfounded.
- **Group/other execute bits do matter.** Any of `u+x`, `g+x`, `o+x` flips a file to
  `executable_content` (§5.2). Filesystems mounted with permission-forcing options (some
  `vfat`/`ntfs`/`exfat` mounts force `0777`) will therefore mark **every** file executable and
  change the identifier. Do not export onto such a filesystem.
- **Windows checkouts.** `core.autocrlf=true` rewrites line endings on checkout, which changes
  file bytes and therefore the hash. `git archive` writes what is in the object database and is
  not subject to the smudge filter, so §4.1 is the safe recipe on Windows too — but a *checkout*
  based recipe (§4.2) is not. Prefer `git archive` on Windows.
- **Empty directories change the identifier.** Verified: adding one empty directory changed a
  tree from `5c6328cd…` to `4ba541f0…`. Git cannot track empty directories, so a `git archive`
  export never contains one — but a hand-rolled tarball can. This is a real divergence source
  between §4.1 and §4.5.
- **zip vs tar.** Prefer tar. Zip has weaker and more variable handling of symlinks and of the
  executable bit; a zip round-trip can silently drop both, and both change the identifier
  (§4.6, §5.2). If you must ship a zip, verify the identifier after a round-trip through it.
- **`tar -x` into a fresh `mktemp -d` every time.** Reusing a directory is the single easiest way
  to get a wrong number (§4.5).

---

## 11. Troubleshooting: "my identifier does not match"

Work down the list. It is ordered by observed frequency, and the first item accounts for most
real cases.

**1. One side hashed a working copy.** By far the commonest cause. Symptom: the two identifiers
are wholly unrelated and the mismatching side is a git checkout. Ask both sides for the exact
command they ran; if either one names a directory containing `.git/`, that is your answer.
Recompute per §2. → §3

**2. Build or environment droppings.** `__pycache__/`, `node_modules/`, `.venv/`, `target/`,
`build/`, `*.pyc`, editor backups (`*~`, `.#*`, `*.swp`), `.DS_Store`. Remember these break the
hash **even when listed in `.gitignore`** — `swh identify` does not read it. Symptom: the person
who ran a build before hashing gets a different number than the person who didn't. → §3.3

**3. A wrapper directory, or the wrong subtree.** One side hashed `$EXPORT`, the other hashed
`$EXPORT/artifact-1.0`. Or, in a monorepo, one side hashed the whole repository and the other
hashed the artifact subdirectory. Symptom: both numbers are reproducible, and both are "right"
for different trees. Compare `ls` of the two roots before anything else. → §4.3, §4.5

**4. Extraction into a non-empty directory.** Symptom: the recomputation is not even stable for
the same person across two attempts. Always `mktemp -d`. → §4.5

**5. Permissions — the executable bit only.** Symptom: file contents compare identical
(`diff -r` is silent) but the directory hashes differ. Check with
`find "$A" -type f -perm /111 | sort` against the same on `$B`. Causes: an uncommitted
`chmod +x`; a zip round-trip; a permission-forcing filesystem mount. Note that `diff -r` does
**not** report mode differences, which is why this one is confusing. → §5.2, §10

**6. Empty directories, or symlinks flattened.** Symptom: `diff -r` silent, file lists differ by
directory entries only, or a symlink on one side is a regular file on the other. Compare
`find "$A" -type d | sort` and `find "$A" -type l | sort`. → §10

**7. Submodules.** Symptom: the export/git-tree self-check in §2 fails, and the repository has a
`.gitmodules`. This is expected and documented; it is not an error in anyone's procedure. → §7

**8. Git LFS.** Symptom: a file is a few lines of `version https://git-lfs.github.com/spec/v1`
text on one side and real content on the other. **UNTESTED here.** → §8

**9. Line endings.** Symptom: mismatch only on a Windows-touched checkout; `file` reports
`CRLF line terminators`. → §10

### The fastest way to localise a mismatch

Do not eyeball it. Hash every file on both sides and diff the two listings — the differing paths
fall straight out:

```sh
( cd "$A" && find . \( -type f -o -type l \) | sort | xargs swh identify ) > /tmp/a.txt
( cd "$B" && find . \( -type f -o -type l \) | sort | xargs swh identify ) > /tmp/b.txt
diff /tmp/a.txt /tmp/b.txt
```

An empty diff with differing directory hashes means the difference is **not** in file content —
go to items 5 and 6 (executable bits, empty directories, symlinks).

---

## 12. Errata against earlier drafts

Recorded so that these do not creep back in. All three were verified false on `swh.model` 6.15.0.

| Claim | Status |
|---|---|
| `swh identify` exposes `--permissions-source` (`auto`/`fs`/`git-index`/`git-tree`) | **False.** `Error: No such option`; string absent from the installed source. → §5.1 |
| `swh identify --type directory path/to/artifact/`, pointed at a checkout, identifies "the artifact tree as submitted" | **Wrong procedure.** It hashes `.git/` too. → §3 |
| `swh identify .` on a git checkout returns `swh:1:rev:…` | **False.** Returns `swh:1:dir:…` of the polluted working copy. Build revision SWHIDs with `echo "swh:1:rev:$(git rev-parse HEAD)"`. → §6 |

One further install caveat, verified: `swh identify --type snapshot repo.git/` fails with
`Cannot compute snapshot identifier; the Dulwich package is not installed` unless the `[cli]`
extra is present. Install with `pip install 'swh.model[cli]'`, not bare `swh.model`, if you need
snapshot identifiers. (This is an installation gap on the verification machine, not a defect in
the tool; snapshot output itself is **UNVERIFIED HERE**.)

---

## 13. Installing the tool

The verified path on the machine this file was checked against is a `uv` tool install; the
documented and portable path is pip:

```sh
pip install 'swh.model[cli]'        # provides `swh identify`; [cli] extra matters, see §12
swh identify --help                 # confirm your option list against §5.1 and §6
```

### Alternative implementations — **UNVERIFIED HERE**

A Rust implementation, `swhid-rs`, exists and is described elsewhere in the book as producing
identical identifiers. **It is not installed on the verification machine** (`command -v swhid
swhid-rs swh-identify` exits 1; nothing in `~/.cargo/bin`), so no claim in this file rests on it
and its equivalence has **not** been checked here.

Before recommending any alternative tool, or repeating an equivalence claim about one, install it
and confirm it produces the identical hash on the §3.3 fixtures. The `--permissions-source` errata
in §12 is what happens when a tool's behaviour is documented from memory rather than measured.
