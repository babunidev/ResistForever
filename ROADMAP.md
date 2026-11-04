# ResistForever — verification roadmap and open decisions

**Creative / decision authority:** Babuni. **Current development version:** 1.0.3, interface 16001. **Latest GitHub release:** 1.0.2. This is a prioritized verification proposal, **not approval of new runtime features**.

## Implemented in current source

- Blizzard-native tooltip append to character/pet panel **Fire, Nature, Frost, Shadow and Arcane** resistance rows.
- Same-level defender context and optional current-target attacker-level comparison; no invented skull/unknown target levels.
- Direct-spell partial resistance **0–100% in 10% steps** internally; only nonzero 10–100% outcomes visible.
- Average resistance `R/(R+9 × attackerLevel)` and middle triangular + edge-specific distributions.
- Base spell miss: defender ≥3 levels above attacker **17%**, otherwise `max(0, 4% + 1% × levelDifference)`, with **zero floor** rather than unavoidable 1%.
- Source accessibility/secret checks; session-only cached player/pet levels and resistance with visible stale-value caveat.
- Event/cache updates and secure post-hooks into Blizzard's paper-doll tooltip and stat-row initializer.
- GitHub published v1.0.2/v1.0.1 **tags/releases with no uploaded assets**. CurseForge is publicly installable for Forever 1.60.1; its exact current file version must be verified directly after the next release rather than inferred from cached public pages.

## P0 — math and model validation

1. Maintain the new `tests/math.lua` fixtures around zero/invalid resistance, representative low/high resistance, edge distributions and level-based misses. These are pure-Lua automated checks, not in-game tests.
2. Check that every 0–100% bucket remains within 0–1, distribution sums near 1 including **hidden 0%** and the weighted mean equals `R/(R+9L)` to reasonable numerical tolerance.
3. Test edge transitions exactly **a=0.10**, just above 0.10, **a=0.90** and just below 0.90, including potential discontinuities and tooltip rounding.
4. Verify miss with level differences **-5, -4, -3, -2, 0, 1, 2, 3, 4, 10** and distinguish **calculated 1%** from an *unavoidable miss floor*. In source, 0% is possible.
5. Compare representative actual **direct spell** combat logs across resistances and level pairs with the v1.0.2 model. Separate **miss** from **0% resisted hit** in analysis.
6. Continue validating the current Forever research formula and 17% `d ≥ 3` plateau against actual launch combat logs. A November 4 source review confirmed current `wowsims/forever` still uses the same model, but that is not independent server-side verification.
7. Run separate tests for dots, channeled and binary spells to ensure no tooltip text suggests the direct-spell distribution applies to them.

## P1 — UI and pet behavior

8. In a live **Forever 1.60.1 / interface 16001** client, hover all five schools on character and pet sheets; confirm `CharacterStatsPaneScrollBox` and `CharacterStatsPanePetScrollBox` recognize rows without attaching to unrelated frame tooltips. The November 4 source review covered build **1.60.1.70790**, but this live test remains pending.
9. Verify native tooltip remains intact, expected Resistance rows are appended once, and repeated hovers/update events do not stack duplicates or recurse.
10. Compare a same-level target, a higher/lower-level target, a self-target and a skull/unknown-level target. Check contextual attacker level and name presentation.
11. Verify `UnitResistance` effective/real fallback and row `numericValue` priority under changing gear, pets, buffs and debuffs.
12. Trigger inaccessible/secret numeric values; verify the addon never raises a forbidden arithmetic error and clearly notes when a last-known value is used.
13. Verify in game that the 1.0.3 `UNIT_PET` cache invalidation prevents a replacement pet from inheriting the previous pet's cached level/resistance while still repopulating readable values normally.
14. Check display of extremely small probabilities, percentage rounding and many populated 10%-step rows at small tooltip sizes/UI scales.
15. Record localization behavior: the title, context labels, `% damage resisted` and `Base spell miss` are **English literals**, even if native tooltips are localized.

## P2 — release quality and maintainability

16. Keep the bounded pure-Lua production-math regression harness passing. Tooltip/context behavior still requires client-side verification because the current harness intentionally avoids mocking Blizzard frames.
17. Packaging is configured for a minimal `ResistForever` folder containing only `ResistForever.toc`, `ResistForever.lua`, and `LICENSE`; `CHANGELOG.md` remains the manual release-note source but is ignored from the ZIP. Before pushing a release tag, verify the private CurseForge repository/tag integration settings if accessible; after tagging, inspect the actual generated CurseForge archive and publication state.
18. Keep checking exact 1.60.1 builds, secret-value API changes and future Forever resistance revisions before promising compatibility beyond what has been verified. Public source compatibility was rechecked at **1.60.1.70790**; live launch-client behavior still needs confirmation.
19. Preserve the repository's existing [MIT license](LICENSE), its Babuni.dev copyright notice and accurate source attribution.

## Pending creative decisions (not approved)

Would a one-line **average direct-spell damage resisted** summary improve comprehension? Should the 0% outcome be shown explicitly, or remain hidden for visual economy? Would a small “direct spells only” subtitle help? Should players choose another hypothetical attacker level independently of targeting? Is a dedicated test suite worth the maintenance? Which locales/Forever revisions should be officially supported? These are **proposals only**; do not replace the current authored interface without Babuni's decision.
