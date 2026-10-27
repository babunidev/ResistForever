# ResistForever — verification roadmap and open decisions

**Creator / decision authority:** Babuni.dev. **Current version:** 1.0.2, interface 16001. This is a prioritized verification proposal, **not approval of new runtime features**.

## Implemented in current source

- Blizzard-native tooltip append to character/pet panel **Fire, Nature, Frost, Shadow and Arcane** resistance rows.
- Same-level defender context and optional current-target attacker-level comparison; no invented skull/unknown target levels.
- Direct-spell partial resistance **0–100% in 10% steps** internally; only nonzero 10–100% outcomes visible.
- Average resistance `R/(R+9 × attackerLevel)` and middle triangular + edge-specific distributions.
- Base spell miss: defender ≥3 levels above attacker **17%**, otherwise `max(0, 4% + 1% × levelDifference)`, with **zero floor** rather than unavoidable 1%.
- Source accessibility/secret checks; session-only cached player/pet levels and resistance with visible stale-value caveat.
- Event/cache updates and secure post-hooks into Blizzard's paper-doll tooltip and stat-row initializer.
- GitHub published v1.0.2/v1.0.1 **tags/releases with no uploaded assets**; source must be installed from repository.

## P0 — math and model validation

1. Run pure formula fixtures around `R=0`, unknown/negative resistance, small/high R, player/pet levels and attacker levels 1 through max relevant range. The current repo has **no automated test files**.
2. Check that every 0–100% bucket remains within 0–1, distribution sums near 1 including **hidden 0%** and the weighted mean equals `R/(R+9L)` to reasonable numerical tolerance.
3. Test edge transitions exactly **a=0.10**, just above 0.10, **a=0.90** and just below 0.90, including potential discontinuities and tooltip rounding.
4. Verify miss with level differences **-5, -4, -3, -2, 0, 1, 2, 3, 4, 10** and distinguish **calculated 1%** from an *unavoidable miss floor*. In source, 0% is possible.
5. Compare representative actual **direct spell** combat logs across resistances and level pairs with the v1.0.2 model. Separate **miss** from **0% resisted hit** in analysis.
6. Independently verify the beta formula and assumed 17% `d ≥ 3` plateau against the exact Forever version intended. The source cites a wowsims/Forever combat-log model, but this documentation audit didn't re-run that evidence.
7. Run separate tests for dots, channeled and binary spells to ensure no tooltip text suggests the direct-spell distribution applies to them.

## P1 — UI and pet behavior

8. In a live **Forever 1.60.1 / interface 16001** client, hover all five schools on character and pet sheets; confirm `CharacterStatsPaneScrollBox` and `CharacterStatsPanePetScrollBox` recognize rows without attaching to unrelated frame tooltips.
9. Verify native tooltip remains intact, expected Resistance rows are appended once, and repeated hovers/update events do not stack duplicates or recurse.
10. Compare a same-level target, a higher/lower-level target, a self-target and a skull/unknown-level target. Check contextual attacker level and name presentation.
11. Verify `UnitResistance` effective/real fallback and row `numericValue` priority under changing gear, pets, buffs and debuffs.
12. Trigger inaccessible/secret numeric values; verify the addon never raises a forbidden arithmetic error and clearly notes when a last-known value is used.
13. Test unit replacement, despawn/re-summon and leveling: the cache is keyed to **player/pet** not unique pet identity and may retain a previous pet's data if new values are unavailable. Decide whether that needs invalidation.
14. Check display of extremely small probabilities, percentage rounding and many populated 10%-step rows at small tooltip sizes/UI scales.
15. Record localization behavior: the title, context labels, `% damage resisted` and `Base spell miss` are **English literals**, even if native tooltips are localized.

## P2 — release quality and maintainability

16. Add bounded pure-Lua test fixtures for formula/rounding and mocked tooltip/context handling if justified; tests must be run and recorded, not merely committed.
17. Confirm release packaging/update workflow. GitHub v1.0.2 exists **without a release asset**, while `.pkgmeta` contains manual-changelog metadata; no CurseForge upload/state was independently verified here.
18. Test exact 1.60.1 build, secret-value API changes, and possible future Forever resistance formula revisions before promising other client versions.
19. Preserve Babuni.dev's existing [MIT license](LICENSE) and accurate source attribution.

## Pending creator decisions (not approved)

Would a one-line **average direct-spell damage resisted** summary improve comprehension? Should the 0% outcome be shown explicitly, or remain hidden for visual economy? Would a small “direct spells only” subtitle help? Should players choose another hypothetical attacker level independently of targeting? Is a dedicated test suite worth the maintenance? Which locales/Forever revisions should be officially supported? These are **proposals only**; do not replace the current authored interface without Babuni.dev's decision.
