# QMHES Counter-Models

Critical repository against the Quantum-Multiplicity Hybrid Encryption System (QMHES) claims published by the Multiplicity Foundation.

This tree is a counter-analysis. It does not implement a production cryptosystem, and it does not endorse the security claims of the source paper. Every model, lemma sketch, and MATLAB routine below is taken from the supplied markdown, which is the source of truth for the counter-artifacts:

`source/supplied-counter-source.md`

## Original author and paper

| Item | Citation |
| --- | --- |
| Author | Ryan O. Van Gelder (cited in the appendix as R. Van Gelder) |
| Organizations | Multiplicity Foundation; Citizen Gardens |
| Theory | Multiplicity Theory (2024–2025). Foundations preprint: Ryan O. Van Gelder, *Multiplicity Theory — Foundations and Applications*, figshare / ResearchGate, DOI [10.13140/RG.2.2.18053.46568](https://doi.org/10.13140/RG.2.2.18053.46568), July 2025, CC BY-NC-SA 4.0 |
| Related disclosures | *P = NP Reinterpreted: A Prime-Indexed Multiplicity Framework*, DOI [10.13140/RG.2.2.12301.81127](https://doi.org/10.13140/RG.2.2.12301.81127), 27 February 2026, labeled public-domain defensive publication by the author |
| System under critique | *QMHES — Mathematical Appendix*, Multiplicity Foundation, 2026, PhaseMirror-HQ. The appendix text used here is the copy embedded in the supplied markdown |
| Related code | PhaseMirror Foundry `multiplicity-crypto` (QKD Hybrid Encryption v1.0.1 sources; TypeScript / Python / Rust). Not vendored here |

The appendix's own attribution line (section 2.3) says Multiplicity Theory was "originated by R. Van Gelder (Multiplicity 2024, MIT/CC BY-SA 4.0)". External preprints use CC BY-NC-SA 4.0. Both notices are recorded; this repo does not relicense his work.

## What he claims

Quoted from the 2026 appendix, not rewritten as our claims. Full extract: [`docs/ORIGINAL-CLAIMS.md`](docs/ORIGINAL-CLAIMS.md).

1. QMHES is a four-layer stack: quantum-state-based security (QSBS), QAHES v1.0.1 wire protocol, physical QKD, and a Multiplicity Theory feedback layer. He claims no prior system combines all four.
2. Classical bits and quantum amplitudes share a unified frequency set \(F_t = F_c(x_t) \cup F_q(|\psi_t\rangle)\), with \(F_q(\alpha_j) = (|\alpha_j|, \arg(\alpha_j))\).
3. A multiplicity operator \(\mathcal{M}_t\) and coupling tensor \(\mathcal{T}_t\) are bound into AEAD associated data and into an extended HKDF info string.
4. The feedback law is projected gradient *ascent* in the printed equation:
   \(\mathcal{M}_{t+1} = \Pi_{\mathcal{B}}[\mathcal{M}_t + \eta \nabla_{\mathcal{M}} \mathcal{L}(\mathcal{M}_t, s_t)]\),
   while Proposition 3.13 claims Lyapunov stability and geometric convergence if \(\mathcal{L}\) is \(\mu\)-strongly convex and \(\eta < 2/\mu\).
5. Projection onto an admissible set \(\mathcal{B}\) is claimed to keep the operator spectrally bounded (implementation sketch: SVD clip of singular values to \([0,1]\)).
6. Key rotation fires only when \(\|\mathcal{M}_{t+1}-\mathcal{M}_t\|_F > \theta_{\mathrm{rotate}}\).
7. QAHES v1.0.1 aborts the session on any sequence gap. Sliding-window replay is deferred to v2.0.
8. Shared secrets are sourced jointly from ML-KEM-1024 and QKD Toeplitz-hash material, and the novelty layer \(H_{\mathcal{M},f}(F_t)\) is labeled "hardness TBD" / "formally unproven" in his own Table 1.

## What this repo counters

The counter-paper is [`docs/COUNTER-PAPER.md`](docs/COUNTER-PAPER.md). Short form:

- The printed update is gradient ascent. Strong convexity plus ascent does not give the contraction he states.
- \(F_q\) as written appends an unbounded phase, so the unit-norm claim does not follow from \(\sum |\alpha_j|^2 = 1\).
- Spectral projection is non-expansive in exact arithmetic on a convex set. It is not non-expansive after independent fixed-point SVD on two hosts. Alloy and Lean sketches record that gap; they are not discharged proofs.
- Strict in-order abort (his normative rule, Test 3) turns one dropped or reordered datagram into session death. That is an availability counterexample, not a confidentiality break.
- Sub-threshold Frobenius drift can accumulate without rotation.
- Stripping MLWE error terms (ADR 003 in the supplied notes) does not repair the scheme. It deletes the hardness assumption. Entropy 0.0 is key erasure, not security.

The ADR files are preserved because they are in the source markdown. They are proposed rewrites, not restorations of the original theorems.

## Layout

```
docs/COUNTER-PAPER.md          counter-paper
docs/ORIGINAL-CLAIMS.md        cited claims, with locations
docs/adr/ADR-00{1,2,3}.md      rectification notes from the source
models/alloy/*.als             relational counter-models
models/lean/*.lean             invariant extraction sketches (sorry)
matlab/                        every MATLAB routine in the source
python/qmhes_counter/          runnable check of the Test 3 sequence rule
source/supplied-counter-source.md
```

## Run the executable check

The only normative vector that can be checked without inventing cryptography is QAHES Test 3.

```
python -m pytest tests -q
```

Expected: input `(0,1,2,3,5,4,6,5,6)` yields `AAAARARAA` and final expected sequence `7`, matching the appendix. The Python model also shows that a single gap aborts the session, which is the availability counterexample.

Alloy (`models/alloy`) and Lean (`models/lean`) are source artifacts. They are not claimed to be accepted by the Alloy Analyzer or by Lean without the `sorry`s discharged.

## License of this counter-repo

Counter-text, models, and runners in this tree are released under Apache-2.0 (see `LICENSE`). Quotations of the QMHES appendix and of Van Gelder's Multiplicity Theory remain under his notices. Do not treat this repository as a FIPS module, a QKD adapter, or a replacement for ML-KEM / ML-DSA.
