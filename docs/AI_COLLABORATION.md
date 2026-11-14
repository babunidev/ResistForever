# ResistForever — human–AI collaboration and attribution

Follow [the documentation standard](DOCUMENTATION.md) for first-person author voice throughout project documentation, factual changelogs, and naming the AI tool and verified model for each contribution.

**Human creative and creative director:** Babuni.
**Scope:** October 27, 2026 repository documentation audit and historically grounded source description.

## Preserve the human creative contribution

With Resist Forever, I wanted the native character sheet to explain Fire, Nature, Frost, Shadow and Arcane resistance. That direction also shaped the pet tooltip and the comparison against the selected target’s level.

Historical commits establish a **real mathematical iteration**: 1.0.0 Classic-like buckets; 1.0.1 pet support/PvP-PvE miss correction; 1.0.2 Forever 10% steps with a new average formula and base spell miss. The version history cannot establish the full personal design discussion, the author of every formula line or an unrecorded acceptance/rejection. When conversations are available, summarize only those actually observed and publication-safe.

The repository includes an **MIT LICENSE** under Babuni.dev's 2026 notice. Its copyright/source rights should not be silently changed to make AI attribution seem larger.

## Actual AI contribution in this audit

For the October 27 audit, the assistant did the following. The AI tool and model were not recorded.
- Recovered the project audit order and identified **ResistForever** as repository **#24** after #23 EnchantVisuals.
- Read current 1.0.2 Lua, TOC, initial README, three historical changelog versions and October documentation scaffold; reviewed the September 28, October 12 and October 20 source diffs.
- Checked GitHub release metadata: **v1.0.2/v1.0.1 released with no attached downloadable files**.
- Explained the **`R/(R+9L)`** direct-spell average, discrete 10% partial-resist buckets, mean/edge distribution, separate level-based base miss and absent unavoidable 1% floor.
- Documented stat-row/pet context detection, secure post-hooks, secret-value avoidance, cache freshness labels, unknown-level target omission and event-driven refresh.
- Expanded/created the eleven source-grounded project documents, including a narrative development journal and open test/creative choices, without changing executable Lua, TOC, MIT LICENSE or packaging metadata.

This is **analysis, technical explanation and documentation work**. It is **not** a live launch-client combat measurement, proof of in-game tooltip behavior, original authorship of the addon idea or a Babuni-approved new feature.

## November 14 writing and byline revision

At my request, OpenAI Codex (GPT-6) revised the narrative and changelog, recorded gaps in historical AI attribution, and corrected the addon manifest byline. The October 26 commits document the earlier byline, and the MIT notice retains its historical wording.

## Documentation standard for future changes

For every substantial iteration, distinguish and preserve:

1. **User direction:** desired feature/feeling, original reasons and firm constraints.
2. **AI contribution:** actual proposals, mathematical research, generated code/docs and implementation changes.
3. **Creative iteration:** rejected approximations, misunderstandings, bug reports, competing models and corrections.
4. **Creative decisions:** explicit approvals, rejections or postponements; never turn a roadmap idea into assumed consent.
5. **Implementation:** precise changed files, commit IDs/version tags and source-level behavior.
6. **Verification:** test commands, environment/client build, observed results and what remains unverified.

Keep private conversations out of public docs; summarize them accurately when needed, without unrelated personal details. Use synthetic numerical examples instead of personal player/game telemetry.

**The October 27 audit is documentation only.** The current code's math and graphical behavior remain untouched; only further independent testing can validate the modeled odds in live gameplay.
