# Resist Forever — source and release changelog

**Creator / copyright:** Babuni.dev · **Target:** WoW: Forever, interface 16001.  
**Method:** Preserves original version facts and adds dated Git context; release or source existence is not proof of independently tested game behavior.

## October 27, 2026 — portfolio documentation expansion

- Expanded/created **11 Markdown docs**: README, concept, roadmap, changelog, AGENTS, architecture, design, content, decisions, narrative DEVLOG and AI collaboration.
- Preserved the full **1.0.0 → 1.0.1 → 1.0.2** mathematical evolution instead of implying all formulas are current.
- Documented direct-spell scope, 10% buckets including hidden 0% branch, level-based base misses, target-level context, pet UI, secret/protected-number handling, stale cache labels and event-driven hooks.
- Confirmed v1.0.2/v1.0.1 GitHub releases exist, **without attached files**, and that current repository includes an MIT LICENSE and `.pkgmeta` pointing at this manual changelog.
- Documentation only: **no Lua/TOC/license changed**, and no runtime, combat-log or automated tests executed in this session.

## 1.0.2 — October 20, 2026: Forever beta resist and base spell miss

**Git commit:** `8a9f09612d32`; [GitHub v1.0.2 release](https://github.com/babunidev/ResistForever/releases/tag/v1.0.2).

- Updated resistance estimates for the then-current **World of Warcraft: Forever beta** behavior.
- Changed average direct-spell resistance from earlier UI-helper-based `0.75 × R / (5 × level)` to **`R/(R+9×attackerLevel)`**.
- Replaced the classic **25/50/75/100%** buckets with **10% damage resisted steps** and separate edge distributions near 0% and 100%.
- Removed Classic PvP/PvE miss splitting in favor of the Forever level-difference function: defender at least **+3** → **17%**; otherwise `max(0, 4% + diff%)`.
- Removed the assumption of an **unavoidable 1% miss floor**; named the result **Base spell miss** because enemy spell-hit bonuses are not known.
- Updated level-context handling for the current Forever model.

**Not verified by today's documentation pass:** the formula's server-side fidelity in live beta combat; direct/periodic/binary applicability beyond the source's stated distinctions.

## 1.0.1 — October 12, 2026: pet panels and Classic-derived miss correction

**Git commit:** `c64797aa276b`; [GitHub v1.0.1 release](https://github.com/babunidev/ResistForever/releases/tag/v1.0.1).

- Added the same resistance-tooltip extension on the **pet character panel**.
- At that stage, spell miss used a **Classic-style distinction**: player/PvP defenders **13% at +3**, continuing **+7%** per further level; pet and other non-player/PvE defenders **17% at +3**, continuing **+11%**.
- The historical README example considered a level-10 caster into a level-22 player as about **76% miss**, avoiding a naïve 100% cap.

**Superseded:** Those PvP/PvE continuation tables are **not used in current v1.0.2**. Preserve them as historical change evidence, not present UI behavior.

## 1.0.0 — September 28, 2026: first resistance tooltip

**Git commit:** `aceba99381c1`.

- First public code and TOC for **character-sheet resistance hover** with partial damage resist probabilities and spell-miss estimates.
- Initial presentation used earlier Classic outcome categories and early Forever UI-derived averages; the exact mechanics were revised in later versions.

## October 26 — creator attribution and documentation scaffold

- `eeb7d693ea4f`: standardize manifest author as **Babuni.dev**.
- `653b525d3448`: credit Babuni.dev in README.
- `6c40390c40aa`: update existing **MIT LICENSE** copyright pseudonym to **Babuni.dev**.
- `61460f5d806f`: add preliminary project concept/architecture/roadmap/decisions/journal.
- `cf910d4aa211`: link the history documents from README.

Original creative authorship is Babuni.dev. The expanded October 27 editorial audit records the history and uncertainty without modifying game behavior.
