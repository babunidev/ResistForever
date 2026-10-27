# ResistForever — recorded decisions, revisions and alternatives

**Creative decision-maker:** Babuni.dev. **Evidence standard:** Git diffs, source code and changelog; absent original design conversations aren't invented.

## Actual implemented evolution

| Evidence | Observable design/mathematical choice |
| --- | --- |
| Sep 28 `aceba993` / 1.0.0 | Append partial resistance + spell-miss odds to existing **character** resistance tooltip; initial Classic-like result buckets |
| Oct 12 `c64797aa` / 1.0.1 | Expand to **pet** panel; revise Classic miss assumptions to **player PvP vs pet/non-player PvE** curves |
| Oct 20 `8a9f0961` / 1.0.2 | Replace earlier math with **Forever beta 10% outcomes**, `R/(R+9L)`, and a flat-17%-from-+3 level miss rule without unavoidable floor |
| Oct 26 `eeb7d693`, `653b525d`, `6c40390c` | Standardize Babuni.dev author and MIT license copyright |
| Oct 26 `61460f5d`, `cf910d4a` | Commit/link first source-grounded documentation |

The first two formula models are **historical, not selectable alternatives** in the current program. The commit record identifies real iterations, but not every human conversation, experiment, or earlier author of a given Lua line.

## Key tradeoffs in current code

**Embedded tooltip vs independent calculator.** By reading the player's selected resistance row, the addon answers a question in context and avoids new persistent UI. It is limited to character/pet sheets and hypothetical attacker levels obtainable from the target.

**10%-step distributions vs Classic buckets.** Current Forever beta assumptions require eleven discrete outcomes, not old 25/50/75% reductions. This improved model fidelity as understood at October 20, but needs ongoing validation as Forever evolves.

**Base miss vs combined hit prediction.** The current miss function is expressly **pre-spell-hit**. Showing it separately from partial resistance avoids falsely pretending to know enemy spell hit and penetration.

**Visible probabilities vs complete distribution.** The 0% outcome is calculated but not displayed; rows with rounded-zero odds are hidden. This keeps the tooltip shorter, though a user adding visible percentages may be confused without explanatory docs.

**Same-level plus target context vs arbitrary input.** Only a selected target with a known different level produces a second comparison. A skull target is omitted rather than guessed at an unsupported level.

**Secret values vs freshness.** Cached last-known data can help show something when values are protected, but may be stale, particularly after pet replacement. The source displays a note and should consider identity-based invalidation if future tests find misleading cases.

**Secure hooks and event refresh vs frame replacement.** Post-hooks respect Blizzard's UI while relying on exact 1.60.1 mixin/frame names. Updates are event-driven; no polling loop exists. There can be version-specific breakage without breaking the rest of the addon.

**MIT licensing:** The repository includes an actual [MIT LICENSE](../LICENSE), with Babuni.dev copyright. Do not claim unlicensed source or rewrite licensing terms during feature work.

## Creator decisions still open

Would showing the 0% branch or average reduction make the math clearer? Should a target with unknown level be omitted (current) or assigned user-chosen level (proposal)? Should a pet cache clear on identity changes? Should future clients have locale text tables? Should formula changes be gated by verified version checks?

These are **questions and AI-suggested tests**, not decisions already made by Babuni.dev. Any eventual choice should be recorded with reasoning, alternatives, code and actual verification.
