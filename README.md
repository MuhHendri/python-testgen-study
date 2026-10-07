# python-testgen-study

Replication package for an independent comparative study of four Python unit test generators — **Pynguin** (search-based), **CodaMOSA** (search seeded by an LLM), **CoverUp** (LLM with coverage feedback), and **MuTAP** (LLM with mutation feedback) — in which every LLM-based tool is run with two LLM backbones (one proprietary, one open-weight).

> **Status:** Milestone M0 (repository skeleton). No experiment has been run yet. Placeholders marked `TODO` or `[ISI: …]` are filled in as milestones are completed.
> Indonesian step-by-step guide: [`docs/panduan_id.md`](docs/panduan_id.md).

## 1. Research questions

| RQ | Question | Scope |
|---|---|---|
| RQ1 | How do the generators compare in line/branch coverage, mutation score, and pass rate under a common environment and budget? | 4 tools on the MT suite; 3 tools on the CM suite (MuTAP cannot run on CM) |
| RQ2 | How much of the variation among the LLM-based tools is attributable to the algorithm, the backbone, and their interaction? | CodaMOSA, CoverUp, MuTAP × 2 backbones |
| RQ3 | Which module characteristics are associated with the relative advantage of each tool? | CM sample, 3 tools |

## 2. Study design

![Study design](docs/figures/fig1_methodology.png)

| Stage | What happens | Script | Output |
|---|---|---|---|
| S1 Benchmarks & sampling | Fetch MT (163 functions, used in full) and CM modules; compute module characteristics; stratified sample of CM (pilot modules excluded) | `scripts/01_fetch_benchmarks.py`, `02_module_characteristics.py`, `03_sample_cm.py` | `results/raw/benchmarks/`, `module_characteristics.csv`, `cm_sample.csv` |
| S2 Test generation | Run every tool × backbone × module R times inside per-tool Docker containers under a common budget; LLM calls logged by `llm_proxy/` | `scripts/04_build_run_matrix.py`, `05_run_generation.py` | `run_matrix.csv`, generated test files, run logs |
| S3 Test execution | Run all generated tests on the unmodified code (pass rate), re-run passing tests to flag flaky tests | `scripts/06_execute_tests.py` | per-test outcomes, valid-test sets |
| S4 Metrics | Line/branch coverage and mutation score on valid tests (same mutant set per module for all tools); time, API calls, tokens | `scripts/07_measure.py` | `results/raw/results.csv` (one row per run) |
| S5 Statistical analysis | Mann–Whitney U, Â12, Holm (RQ1); mixed-effects model (RQ2); module-characteristic analysis (RQ3) | `analysis/rq1.ipynb`, `rq2.ipynb`, `rq3.ipynb` | `results/summary/` tables and figures |

Where the LLM is called inside each tool:

![Role of the LLM](docs/figures/fig2_llm_role.png)

## 3. Requirements

- Ubuntu 22.04+ (native or WSL2). **Do not run from Windows directly**: CoverUp's test isolation relies on the Unix `fork()` call.
- Docker (Docker Engine, or Docker Desktop with WSL integration).
- Git, Python 3.10+ on the host (for orchestration scripts), GNU Make.
- Access to one proprietary and one open-weight LLM through an OpenAI-compatible endpoint (see `.env.example`).

## 4. Quickstart

```bash
git clone <this-repo> && cd python-testgen-study
cp .env.example .env          # fill in your keys/endpoints; never commit .env
make check                    # verifies Docker, Python and .env  (available)
make smoke                    # one MT function, all tools          (from milestone M5)
```

## 5. Reproducing the full experiment

Fill in `docs/protocol.md` **before** the main run, then follow the stages in Section 2 in order (`make s1`, `make s2`, … — added as milestones are completed). Every script reads its parameters from `config/experiment.yaml` and can resume after an interruption.

## 6. Configuration

- `config/experiment.yaml` — backbones, number of runs R, time budget, CM strata, seeds, mutation tool, flaky re-runs.
- `.env` — API keys and endpoints (not committed).

## 7. Outputs

`results/raw/results.csv` has one row per run with: tool, backbone, suite, module, run id, seed, status/error category, pass rate, flaky count, line coverage, branch coverage, mutation score, wall-clock time, API calls, input/output tokens. Raw data stays out of Git; final tables and figures are written to `results/summary/`.

## 8. Tools, versions, and adaptations

Exact tool versions/commits are pinned in `docker/*/Dockerfile` and listed in `docs/sources.md`. Every change needed to run CodaMOSA and MuTAP on current chat-based backbones is recorded in `docs/prompt_adaptations.md`.

## 9. Data sources and licenses

Benchmarks and tools are **not** redistributed here; `scripts/01_fetch_benchmarks.py` downloads them from their official sources. See `docs/sources.md` for URLs and licenses.

## 10. Citation and license

See `CITATION.cff`. Code in this repository is released under the MIT License (`LICENSE`); third-party tools and benchmarks keep their own licenses.
