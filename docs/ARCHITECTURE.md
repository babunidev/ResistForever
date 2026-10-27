# ResistForever — technical architecture and probability semantics

**Inspected:** `ResistForever.lua` (583 lines including terminal line), `ResistForever.toc`, `.pkgmeta`, Git versions 1.0.0–1.0.2; October 27, 2026. **Static source review only.**

## Installed module and lifecycle

```text
ResistForever.toc / Interface 16001 / Version 1.0.2
  -> ResistForever.lua
       | five resistance-school atlas identifiers
       | pure direct-spell average/bucket and base-miss functions
       | protected numeric/string reads + session cache
       | context resolution: player/pet defender, target attacker level
       | PaperDollStatTooltip post-hook: append lines
       | StatFrame row Init post-hook: tag school and refresh
       | event-driven cache/open-tooltip refresh
```

No external library, SavedVariables, network messaging, persistent logs, slash commands or independently packaged test harness is present. `.pkgmeta` points to `CHANGELOG.md` as a manual changelog for release packaging metadata.

## School and hover-row identity

Five schools map to enum `Enum.Damageclass` where readable, otherwise fallback IDs **Fire=2, Nature=3, Frost=4, Shadow=5, Arcane=6**. Each is associated with `UI-Character-Info-Resistance-[School]` atlas, which tags stat-row frames through `CharacterStatFrameScrollBoxIconElementMixin.Init`.

`ResolveTooltipUnit` checks `frame.unit` for `player` or `pet`; otherwise it walks ancestry under `CharacterStatsPaneScrollBox` or `CharacterStatsPanePetScrollBox`. Only recognized **resistance rows within those panes** trigger the tooltip extension, reducing the chance of attaching to unrelated stat types.

`hooksecurefunc` adds a post-hook to Blizzard's `PaperDollStatTooltip` and the stat-element `Init`, preserving existing tooltip content. The addon requires `GameTooltip:IsOwned(frame)`, guards against its own append recursion, tracks the current `openRow`, and uses `PaperDollStatTooltip(row)` again to refresh after relevant unit events. GameTooltip `OnHide` clears the row reference.

## Protected value acquisition and cache

Forever may return numbers or strings with secret/protected access restrictions. `IsSecret` uses optional `issecretvalue` and `canaccessvalue` guarded by `pcall`. `UsableNumber` excludes non-numbers, inaccessible values and NaN before arithmetic; `WholeLevel` enforces positive levels and rounds to nearest integer.

`ResolveResistance` prioritizes:
1. **The currently displayed frame's `numericValue`**, if readable.
2. Direct `UnitResistance(unit, school)`: the **third** (effective) return if accessible, otherwise the **second** (real) return.
3. Last-known **session cache** for that `unit` and school.

The paper-doll UI may internally show a different `realResistance` value to `ExpectedSpellResistance`; using the readable row's value avoids assuming the historical UI helper equals the newer server-side formula. `ResolveUnitLevel` similarly asks `UnitLevel(unit)` then checks last-known level.

The cache structure is `cache.level[player/pet]` and `cache.resistance[player/pet][schoolID]`. `RefreshResistanceCache` updates it during subscribed events. If resistance or level is reused from cache, the rendered tooltip appends **“Using last available resistance value”**. The cache does not persist across sessions. **Potential ambiguity:** pet unit tokens can refer to different pets over time; there is no explicit identity-aware purge if a newly summoned pet's values are still inaccessible.

## Pure mathematical model

Let defender readable resistance be **R** and hypothetical attacker level **L**.

**Average direct spell fraction resisted:**

`a = R / (R + 9L)` for R > 0, L ≥ 1. Unknown/nonpositive R produces no partial-resist buckets. It is **not** the previous 0.75 × R/(5L) UI helper.

**Discrete reduction distribution** on step outcomes **x=0.0,0.1,...1.0**:

- For **a ≤ 0.10**, `P(0) = 1 - 7.5a`, `P(0.1) = 5a`, `P(0.2) = 2.5a`; other buckets zero.
- For **a ≥ 0.90**, let `q=1-a`; `P(1) = 1-7.5q`, `P(0.9)=5q`, `P(0.8)=2.5q`; other buckets zero.
- Otherwise, for each 10% step, `P(x) = max(0, 0.5 - 2.5 * abs(x-a))`.

The code instantiates all eleven buckets but lists **10–100% only**. It skips values below `PROBABILITY_EPSILON=0.0005` (fraction) or that format as `0.0%`. Thus a user cannot recover the complete probability mass merely by adding visible rows; the **0% resisted** chance is deliberately hidden.

**Base spell miss:**

Let **d = defenderLevel - attackerLevel**. For `d ≥ 3`: **0.17**. Otherwise: **max(0, 0.04 + 0.01d)**. This is *base miss before attacker spell hit*, distinct from partial resistance and not an inevitable miss floor. Level differences -4 or smaller yield 0%.

`BuildResistanceContext` constructs miss independently from buckets, so missing/zero R may still show base miss. It returns nil bucket distribution if mean cannot be calculated. Rounded row values display one decimal.

**Model scope:** direct magical spell hits. Comments explicitly state periodic non-channeled ticks appear to use a different (roughly one-tenth average) model; channels/binary spells also differ. Spell penetration and attacker spell-hit bonuses aren't accessible from a hovered character-sheet resistance row, so this display cannot produce exact odds for every individual attack.

## Contexts displayed to the player

`AppendResistanceTooltip` reads the hovered **defender's** resistance/level and constructs a same-level context with attackerLevel=defenderLevel. It optionally reads the **currently selected target's level** from `UnitLevel("target")`, provided the unit exists, is not the player, has a positive valid level and differs from the defender's level. A valid name appears in the target section label.

A negative/sentinel/skull target level does **not** become an invented +3 level. No target comparison is shown for invalid or equal level. The target's **resistance is not involved**.

If neither context generates visible meaningful rows, no additional section is appended. Otherwise the existing tooltip is followed by a blank, **Resist Forever** title, and one or two context subsections with double-line percentage rows. Base spell miss and partial probabilities are labeled independently.

## Hooks, events and exposure

The addon creates a frame subscribed to **ADDON_LOADED, PLAYER_LOGIN, PLAYER_ENTERING_WORLD, PLAYER_EQUIPMENT_CHANGED, PLAYER_LEVEL_UP, PLAYER_TARGET_CHANGED, PLAYER_REGEN_ENABLED, UNIT_PET**. It also registers **UNIT_AURA, UNIT_RESISTANCES and UNIT_LEVEL** for player/pet through `RegisterUnitEvent` if supported, otherwise global `RegisterEvent` versions filtered when the unit argument is present.

Every relevant event retries hook installation, refreshes readable player/pet cache values and, apart from ADDON_LOADED, attempts to regenerate the currently open resistance tooltip. The post-hook row `Init` similarly refreshes if that same row is currently open. No periodic OnUpdate loop or timer is defined in this Lua source.

`hooksInstalled` prevents multiple secure hook registrations; `appending` prevents recursive calls while the addon is drawing its own rows. Unknown accessibility or UI implementation changes can still affect results and should be tested on the actual client.

## Packaging and test status

Only `ResistForever.lua` and `ResistForever.toc` are required at runtime. GitHub releases **v1.0.1/v1.0.2** exist without attached ZIP artifacts. [LICENSE](../LICENSE) grants MIT terms and `.pkgmeta` names the manual changelog. No **tests/** path exists in the current tree. Static inspection confirms design, **not** mathematical calibration against combat logs or successful UI behavior in-game.
