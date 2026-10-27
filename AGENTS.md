# ResistForever — developer and AI collaborator instructions

**Creative author and final decision-maker:** Babuni.dev. **Target:** World of Warcraft: Forever **1.60.1**, addon interface **16001**, manifest **1.0.2**. **License:** [MIT](LICENSE).

## Preserve the original idea

The tool is a **small educational extension to Blizzard's existing character/pet resistance tooltip**. Do not replace the character sheet, invent a gear optimizer, make combat decisions for the player, or attribute the creator's original idea to AI. The addon must retain five schools (Fire/Nature/Frost/Shadow/Arcane), current/target attacker-level contexts, clearly labeled base misses, and **10%-step direct-spell partial reductions** unless Babuni.dev approves changes.

Read `README.md`, `CHANGELOG.md`, `CONCEPT.md`, `ROADMAP.md`, relevant `docs/` files, the entire `ResistForever.lua` and its TOC before touching code.

## Gameplay and data constraints

- The current direct-spell **Forever beta** average is **`R/(R+9L)`** (positive readable defender R, hypothetical attacker level L). Do not silently revert to Classic buckets or earlier UI `ExpectedSpellResistance` helper math.
- Internal probabilities include **0,10,...100%**; tooltip intentionally displays only positive nonzero 10%–100% results after epsilon/rounding checks. Preserve edge cases at mean ≤0.10/≥0.90.
- **Base spell miss** is level-difference-only: defender minus attacker **≥3 → 17%**, else `max(0,4%+diff%)`. There is **no unavoidable 1% floor**. Enemy spell hit unknown; don't market it as final chance to miss.
- This estimate is for **direct magical damage only**, not periodic ticks, channels, binary spell mechanics or enemy spell penetration. Verify formulas against real Forever build before claiming authoritative combat precision.
- The defender is **player or pet** from the hovered frame. The **current target is only a candidate attacker-level context**; don't substitute target resistance into the calculation.
- Skip invalid/secret/inaccessible values. Use `issecretvalue`/`canaccessvalue` checks and protected arithmetic carefully; clients can prohibit calculations on secret unit values.
- Source preference: tooltip row **numericValue**, then `UnitResistance` effective/real, then last-known cache. Mark **stale** values; do not claim fresh data if cached.
- The source caches `player` and `pet` by unit tokens; evaluate pet replacement cache invalidation before relying on it.
- Use `hooksecurefunc` after Blizzard's stat-row init and tooltip routines; guard against duplicated append/recursive refresh and preserve native text.
- The source is a **single Lua + TOC** addon, no SavedVariables, no dependencies, no slash commands, no committed tests. Do not invent a feature or an automated pass.

## Development process

1. Record exact user request, goal and nonnegotiable constraints.
2. Separate AI proposals/alternatives from *approved* creator decisions.
3. Run pure math tests, manual UI checks and real combat-log comparisons where relevant; record environment and actual output. Mock tests do not substitute for the target client.
4. For future changes update `README.md`, `CONCEPT.md`, `ROADMAP.md`, `CHANGELOG.md`, `AGENTS.md`, `docs/ARCHITECTURE.md`, `DESIGN.md`, `CONTENT.md`, `DECISIONS.md`, `DEVLOG.md`, `AI_COLLABORATION.md` as appropriate.
5. Preserve original Babuni.dev authorship, earlier discarded models as history, and the **MIT LICENSE** with its notice.
6. Avoid publishing private player names, selected target identity, real saved data, account details or raw chats. Use synthetic math examples.

The October 27, 2026 repository audit is **documentation-only**. It does not approve formula edits or imply an in-game test.
