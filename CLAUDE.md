# Instructions for Claude (repository level)

This repository implements the experiment described in the paper's Methodology v3.
Private paper drafts are NOT in this repo; put them in `CLAUDE.local.md` (git-ignored) if needed.

## Non-negotiable design rules
- Stages S1–S5 as in `docs/figures/fig1_methodology.png`.
- Backbones: one proprietary and one open-weight model (no "default backbone" arm; Codex is unavailable).
- MuTAP runs on the MT suite only. MT suite is used in full (163); only CM is stratified-sampled; pilot modules are excluded.
- One Ubuntu/WSL machine, one Docker image per tool plus one evaluation image.
- Pass rate is computed on ALL generated tests before filtering; coverage and mutation score on valid tests only (passing and non-flaky).
- The same mutant set per module is used for every tool and backbone.
- All parameters come from `config/experiment.yaml`; secrets only in `.env`.

## Working rules
- Never guess install commands or CLI flags of a tool; read its official README and record the source in `docs/sources.md`. Mark untested steps [PERLU DICEK].
- Never copy benchmark data or tool code into the repo; download it in `scripts/01_fetch_benchmarks.py`.
- Build milestone by milestone (see `docs/panduan_id.md`). After each milestone, show the exact commands and expected output, update the guide, and stop for the user's confirmation.
- The user is an MSc student new to Docker: explain each step in `docs/panduan_id.md` in Indonesian.

## Milestones
M0 skeleton (done) · M1 Pynguin on one MT function · M2 llm_proxy + CoverUp · M3 CodaMOSA + MuTAP with adaptations ·
M4 full evaluation on one function · M5 smoke test + cost estimate (STOP until docs/protocol.md is filled) ·
M6 benchmarks + sampling + run matrix · M7 main run with resume · M8 analysis notebooks.
