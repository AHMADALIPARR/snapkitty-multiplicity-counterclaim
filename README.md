# Successor system to QMHES

Two authors, two systems.

| System | Author | What it is |
| --- | --- | --- |
| Original | Ty Van Gelder (published byline Ryan O. Van Gelder), Multiplicity Foundation / Citizen Gardens | QMHES, the 2026 mathematical appendix, and Multiplicity Theory |
| This repository | Ours | Counter-models plus the successor architecture in ADR 001–003 |

The supplied markdown is the source of truth for our files: `source/supplied-counter-source.md`. His appendix text is quoted, not relicensed.

## His paper

- Ryan O. Van Gelder, *Multiplicity Theory — Foundations and Applications*, DOI [10.13140/RG.2.2.18053.46568](https://doi.org/10.13140/RG.2.2.18053.46568), July 2025, CC BY-NC-SA 4.0. Appendix §2.3 also says “R. Van Gelder (Multiplicity 2024, MIT/CC BY-SA 4.0)”.
- *QMHES — Mathematical Appendix*, Multiplicity Foundation, 2026, PhaseMirror-HQ. Claims extract: [`docs/ORIGINAL-CLAIMS.md`](docs/ORIGINAL-CLAIMS.md).
- Related disclosure: *P = NP Reinterpreted*, DOI [10.13140/RG.2.2.12301.81127](https://doi.org/10.13140/RG.2.2.12301.81127), 27 February 2026.

He claims a four-layer stack (frequency bridge, QAHES v1.0.1, QKD, multiplicity feedback), unified frequencies \(F_q(\alpha_j)=(|\alpha_j|,\arg(\alpha_j))\), projected update

\[
\mathcal{M}_{t+1}=\Pi_{\mathcal{B}}[\mathcal{M}_t+\eta\nabla_{\mathcal{M}}\mathcal{L}],
\]

geometric convergence in Proposition 3.13, SVD clip to spectral norm \(\le 1\), rotation only above a Frobenius threshold, and session abort on any sequence gap. Table 1 marks the novel layers “hardness TBD” and “formally unproven”.

## Our system

[`docs/COUNTER-PAPER.md`](docs/COUNTER-PAPER.md) is our paper against those claims. The successor is the three ADRs, not a patch on his operator:

- ADR 001 — Cartesian frequency embedding, descent sign, then exact state on \(E(\mathbb{F}_p)\) so two hosts share a point instead of a rounded matrix. `matlab/adr001/`
- ADR 002 — hybrid QKD removed; state is a bifurcation index on an elementary abelian group. `matlab/adr002/`
- ADR 003 — recorded lattice collapse. Entropy 0.0 deletes min-entropy; it is in tree because it is in the source, and it is not the data-plane KEM. `matlab/adr003/`

Wire and sequence behavior we keep from his spec is the byte layout and Test 3, checked rather than redesigned. `python/qmhes_counter/sequence.py`

## Layout

```
docs/COUNTER-PAPER.md     our paper
docs/ORIGINAL-CLAIMS.md   his claims, cited
docs/AXIOMS.md            ten instability axioms
docs/adr/                 ADR 001–003
models/alloy/             relational counter-models
models/lean/              invariant sketches (sorry)
matlab/                   every MATLAB routine in the source
python/qmhes_counter/     Test 3 runner
source/supplied-counter-source.md
```

```
PYTHONPATH=python python -m unittest tests.test_sequence -v
```

Expected: pattern `AAAARARAA`, final counter 7, normative abort at the first gap.

Alloy and Lean are source artifacts. They are not claimed accepted by the Analyzer or discharged in Lean.

## License

Our text, models, and runners are Apache-2.0. His appendix and Multiplicity Theory stay under his notices.
