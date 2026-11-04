# ResistForever — narrative development journal

**Project creative and creative director:** Babuni  
**Retrospective date:** October 27, 2026 · **Updated:** November 4, 2026  
**Evidence:** actual Git history, README/CHANGELOG, the Lua/TOC, current GitHub release records and the November 4 public Forever UI-source compatibility review. Relevant project conversations inform the creative record where available. The complete original design conversation is not reproduced or invented. Earlier code-line authorship is not inferred from Git alone.

## The question behind a resistance number

A number like 90 Fire resistance occupies a very small piece of the World of Warcraft character sheet. But that number prompts more questions than it answers: Does it make the player less likely to be hit by a Fire spell? Does it reduce the damage when a spell lands? If it reduces damage, how much? Does the opponent's level make the investment stronger or weaker?

**Resist Forever** reflects Babuni's interest in making mechanics visible through the game's own interface. Rather than replacing the character pane or inventing a separate calculator that a player has to remember to open, the addon adds a small explanatory table when the player hovers Fire, Nature, Frost, Shadow or Arcane resistance. The same existing tooltip remains in place, and the custom detail follows it.

That restrained design is part of the creative work. The goal is to help the player *interpret the character*, not to perform a combat rotation or turn statistics into a recommendation engine. The tool is particularly appropriate to **World of Warcraft: Forever**, where the resistance rules were changing during the beta period and old Classic assumptions could give confidently incorrect probabilities.

The ownership of this original purpose and its creative direction belongs to **Babuni**. The documentation assistant's later explanations and mathematical summaries are a separate contribution; the Git tree doesn't tell us who typed every earlier implementation function.

## September 28, 2026 — first public code and an initial theory

The repository's first empty scaffolding commit **`c3f137064a52`** was followed by **`aceba99381c1`**, “Publish the first resistance tooltip release,” on September 28. The manifest declared **interface 16001, version 1.0.0** for World of Warcraft: Forever, and the README invited the player simply to hover one of five resistance rows.

The initial Lua already did more than display fixed percentages. It identified the hovered school by the resistance atlas in the revamped character sheet, examined the player's resistance and level, read the target as a potential attacker-level reference, calculated a spread of partial resist outcomes, and appended lines to Blizzard's tooltip without replacing the existing information. It also guarded against the Forever client's newer notion of **secret/protected numeric values**, where even ordinary arithmetic or comparison can be blocked under certain UI conditions.

For the actual model, the first release leaned on the game's prior paper-doll **ExpectedSpellResistance** UI helper, using an average resembling `0.75×R/(5L)`, and displayed Classic-style **25/50/75/100%** resisted buckets. It used level-difference spell miss assumptions based on older reference tables. This was a practical starting point, but those source assumptions were not a verified, timeless description of Forever's server rules.

The initial release itself is visible in code; a full set of preceding design sketches or playtest transcripts is not. The existence of a public v1.0.0 doesn't prove that the first published model was ultimately correct.

## October 12 — a companion's defense and a level-curve correction

Commit **`c64797aa276b`**, “Fix player spell-miss curve and show pet resistance tooltips,” was released as **v1.0.1** on October 12. This change had two distinct threads.

One was an interaction expansion: the **pet character pane** received the same hover behavior as the player's resistance panel. The source learned to classify rows as player or pet through their frame ancestry and kept separate cached levels/resistances for those units. This is an elegant extension of the original design. A player examining their pet's survivability should be able to ask the same resistance questions without opening a new addon window.

The other change corrected how the addon treated casters at different levels. At that stage it distinguished **Classic-derived PvP and PvE miss curves**: player defenders used a 13%-at-+3 rule with +7% continuation; pets and non-player defenders used 17%-at-+3 with +11% continuation. The changelog specifically illustrated why a level-10 caster attacking a level-22 player should not be shown as an automatic 100% miss under that then-current model.

That was an actual mathematical revision, not merely a label or new tooltip style. Importantly, it would later be **superseded**. A publishable project history should keep the reasoning and correction visible without confusing a visitor about which curve is currently used.

## October 20 — leaving the Classic model behind for Forever

Commit **`8a9f09612d32`**, “Update Forever beta resist and base spell-miss models,” produced **version 1.0.2** on October 20. This is the most consequential visible pivot in the repository's short history.

The project moved from calculating in classic 25% partial reduction outcomes to representing **0, 10, 20, ..., 100%** damage resisted for direct magical spell hits. The source describes the new average as **`R/(R+9×attackerLevel)`**, derived from the then-current Forever beta/wowsims combat-log model rather than trusting the earlier **ExpectedSpellResistance** interface helper. The result is turned into a discrete probability distribution: a triangular band around the mean in the middle and special formulas near the 0% and 100% edges.

Only the meaningful positive reduction rows are drawn. The **0% reduction** case is still computed internally but never displayed; tiny rounded-zero chances also disappear. That keeps a potentially long tooltip from filling with statistically negligible numbers, although it also means the visible probabilities may not sum to a complete 100%.

At the same time, the addon abandoned the Classic-derived player-versus-pet miss split. Its new **Forever model** calculates baseline spell miss from defender minus attacker level: **17%** if the defender is three or more levels above the caster, otherwise `max(0, 4% + 1% per level difference)`. Unlike an older assumption, a **1% minimum is not unavoidable**. Equally importantly, the row is now labeled **Base spell miss**, not simply spell miss, because the enemy may have spell-hit bonuses the addon cannot see.

This revision expresses a broader lesson in game-mechanics development: the client interface may contain a formula intended for display, a legacy formula may be well known from earlier versions, and the actual server-specific behavior may be different from both. The addon had to choose which model to communicate and be transparent about its scope and evidence.

The source explicitly limits these partial odds to **direct spell damage**. It notes that periodic non-channeled ticks, channels and binary spells can follow different mechanics. Enemy spell penetration is unknown from the paper doll. Those caveats are not an afterthought—they are the difference between a useful explanatory approximation and a promise that any specific hit will behave exactly as predicted.

## Maintaining trust in a changing user interface

The 1.0.2 source at that stage was also careful about **where the numbers came from**. It attempts to use the exact resistance value already stamped on the hovered frame. If unavailable, it tries the effective/real returns from `UnitResistance`, then falls back to a small session-only cache. A previously readable level is reused if a new one cannot be accessed.

The cache is especially relevant to a client exposing **secret** values. The code wraps accessibility checks and arithmetic validation in guarded calls instead of assuming every number can be compared. A fallback adds the muted text **“Using last available resistance value”**. If there is no safe context, the addon simply doesn't append a speculative value.

The tooltip has two useful perspectives. One is a **same-level hypothetical attacker**, always phrased as “Against level N.” The other, shown only if a different-level target has a real readable level, uses that target as a hypothetical caster. An invalid/skull level isn't treated as +3 by fiat. And no part of the calculation changes the subject of the tooltip: when hovering the pet, it is still the **pet's resistance** being modeled, not the resistance of a selected enemy.

The code attaches through secure post-hooks to Blizzard's stat-row and tooltip functions, uses event-driven cache refreshes and guards against recursive rows. This avoids a wholly separate window and reduces the risk of trampling the original tooltip, but it depends on client-specific 1.60.1 frame structures. There is no permanent tracking database or user settings file.

## October 26–27 — preserving the creative and mathematical record

On October 26, attribution commits set the TOC and README author to **Babuni.dev** and updated the existing MIT License notice. Subsequent commits created concise concept, roadmap, architecture, decisions and journal files and linked them from README.

The October 27 documentation audit inspected the current Lua, manifest, original version changelog, Git revisions and release metadata. It confirmed **v1.0.1 and v1.0.2 GitHub releases exist but have no attached binary/ZIP assets**, and expanded eleven Markdown documents to preserve the story behind the numbers.

**Creative contribution:** Babuni conceived and directed the tooltip-explanation project and its evolution. **AI contribution in this session:** code/history review, mathematical interpretation, architecture/UX documentation, source-grounded roadmap and editorial collaboration record. Some prior project discussions addressed the v1.0.2 formula update, but without a complete original back-and-forth and commit attribution this journal does not invent who proposed every mathematical step.

**Actually verified here:** current source formulas, event/UI structure, commit chronology, release metadata, documentation paths and unchanged runtime blobs after the commit. **Not performed:** installing Forever, hovering a live tooltip, exercising secret-value restrictions in game, performing a combat-log probability experiment, or executing automated tests. No tests were committed in the inspected source tree.

## November 4, 2026 — launch-day compatibility review

With Forever going live, I wanted Resist Forever checked against the launch UI before changing its mechanics again. The review compared the addon's integration points with the public **1.60.1.70790** Forever UI source and found the paper-doll tooltip hook, resistance-row initializer, player/pet stat panes, row numeric values and `UnitResistance` API structure still in place.

Current public `wowsims/forever` research also continues to use the same 10%-step direct-spell resistance model and zero-floor level-based spell miss adopted in 1.0.2. That was enough to leave the runtime formulas untouched for this documentation pass, while keeping their research-derived status explicit.

No in-game launch-client test, combat-log validation, version bump, tag or public release was performed as part of this review.

### 1.0.3 development polish

A small launch-polish pass followed the documentation review. The resistance model stayed unchanged; the code instead hardened secret target-name handling, clears stale pet cache data when the player's pet changes, and adds a pure-Lua regression harness for the production math. The manifest now reads **1.0.3**. Packaging was tightened at the same time so players receive only the runtime TOC/Lua plus the required MIT license; project documentation, tests and the changelog stay in Git rather than the installed addon folder.

Running the new harness with `texlua tests/math.lua` passed **31 assertions**, and `loadfile` syntax checks passed for both the runtime Lua and test file. Those checks verify the implementation and math in a Lua environment; the character/pet tooltip behavior still needs the actual Forever client.

The approved release was then tagged as **v1.0.3** on commit `8c2856e8600432ae44622c5c70d9e89405ffd466`. CurseForge subsequently showed the file as **Approved**, release type **Release**, for **Forever 1.60.1**. That confirms publication, but not the internal file listing of the generated archive; the package contents remain source-configured until the published ZIP itself is inspected. A separate GitHub Release object for v1.0.3 had not been created when this record was written.

## A next chapter grounded in the game

The most valuable continuation is empirical: use the actual Forever build and a controlled set of direct magical hits to compare the distribution of observed partial reductions with the displayed 10% buckets, while separately estimating misses and recording any spell-hit/penetration effects. Repeat with a pet and an enemy whose level differs from the defender's.

On the user-experience side, see how the tables read after gear changes or a pet summon, and test protected UI states where an apparently fresh level becomes temporarily inaccessible. If a surprising value appears, capture the formula input and the precise game-client version—not just an anecdotal “resists seem wrong.”

The project is a small portfolio example of **careful, revisable explanation**. Its interface is a tooltip. Its creative work lies in recognizing which question players have, presenting uncertainty well, and being prepared to replace a familiar formula when a living game evolves.
