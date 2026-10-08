# SnapKitty counterclaim against Multiplicity

Copyright 2026 Bel esprit D'accord Trust.
Researchers: Ahmad Ali Parr and Jessica Westerhoff, SnapKitty Research Lab.
License: GNU Affero General Public License v3. See `LICENSE`.

The original system is Ty Van Gelder's (published byline Ryan O. Van Gelder, Multiplicity Foundation / Citizen Gardens). This repository is the counterclaim and the removal of his multiplicity operator.

## His claims

*QMHES — Mathematical Appendix*, Multiplicity Foundation, 2026. Extract: [`docs/ORIGINAL-CLAIMS.md`](docs/ORIGINAL-CLAIMS.md). Theory preprint DOI [10.13140/RG.2.2.18053.46568](https://doi.org/10.13140/RG.2.2.18053.46568).

He claims a multiplicity operator \(\mathcal{M}_t\), a coupling tensor, frequency-space unification, and geometric convergence of equation 24. His Table 1 marks that layer formally unproven.

## This lab

[`docs/COUNTERCLAIM.md`](docs/COUNTERCLAIM.md) is the counterclaim.
[`adr/ADR-004.md`](adr/ADR-004.md) removes \(\mathcal{M}_t\), \(\mathcal{T}_t\), and the feedback map from the normative path. ADR 001–003 stay as the record of why the operator was abandoned. They are superseded.

What remains on the data plane is what his appendix already cited from NIST and the IETF: ML-KEM-1024, ML-DSA-87, AES-256-GCM or ChaCha20-Poly1305, SHA-256, HKDF. Test 3 of his sequence rule is checked, not adopted as a liveness design.

```
PYTHONPATH=python python -m unittest tests.test_sequence -v
```

## Layout

```
docs/COUNTERCLAIM.md
docs/COUNTER-PAPER.md
docs/ORIGINAL-CLAIMS.md
adr/ADR-004.md          removal of multiplicity (normative)
adr/ADR-001.md          abandoned elliptic descendant
adr/ADR-002.md          abandoned bifurcation descendant
adr/ADR-003.md          abandoned entropy drain
models/  matlab/  python/  source/
```
