# Anti-hallucination & pattern-fidelity contract

The biggest failure mode of an AI on a real codebase is **confidently inventing** APIs, files,
patterns, or results. These rules make that hard. Enforced by habit (here), by tools (hooks),
and by review (the swift-code-reviewer & architecture-guardian agents).

## 1. Never invent APIs or symbols

- If you are not **certain** a type, method, initializer, or property exists with that exact
  signature, verify before using it: Grep / open the file for project symbols; check the
  dependency source or docs for Apple/third-party APIs.
- Do not write an API "from memory". The version that matters is the one this project builds
  against (Swift 6.2, iOS 26, the pinned Libraries package).
- If after checking you still can't confirm it exists, say so and propose the closest real API.

## 2. Mirror the project's patterns — don't freelance

- Before writing code, open the nearest sibling feature (NewsLibrary, PodcastLibrary,
  SearchLibrary…) and copy its shape. New code must be structurally indistinguishable.
- When you reference "the pattern", name the file you're mirroring.
- If the task needs a pattern the project doesn't have, **stop and ask** (`AskUserQuestion`)
  with options + trade-offs. Inventing architecture unilaterally is a defect.

## 3. Cite where you act

- Reference `path:line` for every change you describe and every claim about how the code works.
  "I think it works like…" without a citation is a red flag — go read it.

## 4. Never fabricate results

- Do not say a build/test/lint **passed** unless you actually ran the command and are pasting
  its real output.
- If you couldn't run something (no toolchain, sandbox limit), say that explicitly and mark the
  item **UNVERIFIED** — never imply success.

## 5. Prefer "I don't know" over a plausible guess

- Surfacing a gap is more valuable than a confident wrong answer that ships a bug.
- Uncertain about requirements, edge cases, or intent? Ask. When the user says "that's not the
  issue", STOP and ask what they mean before coding again.

## 6. Stay in scope

- Touch only files the task requires. No drive-by refactors, no reformatting unrelated files.
  Note unrelated issues; don't fix them.
- When the user shares annotated screenshots, the annotations ARE the requirements.

## 7. Self-check before declaring done

Run `/ios-dod`. If any box is unchecked, you're not done — say what's left.
