# SnapKitty counterclaim against Multiplicity

[![License: AGPL v3](https://img.shields.io/badge/license-AGPL--3.0-blue.svg)](LICENSE)
[![Owner](https://img.shields.io/badge/owner-Bel%20esprit%20D'accord%20Trust-0c0d0f)](AUTHORS.md)
[![Lab](https://img.shields.io/badge/lab-SnapKitty%20Research%20Lab-9aabba)](AUTHORS.md)
[![ADR-004](https://img.shields.io/badge/normative-ADR--004%20removal-eceae4)](adr/ADR-004.md)
[![Python](https://img.shields.io/badge/tests-unittest%20Test%203-3776AB)](tests/test_sequence.py)
[![Repo](https://img.shields.io/badge/github-AHMADALIPARR%2Fsnapkitty--multiplicity--counterclaim-181717)](https://github.com/AHMADALIPARR/snapkitty-multiplicity-counterclaim)

Copyright 2026 Bel esprit D'accord Trust.
Researchers: Ahmad Ali Parr and Jessica Westerhoff, SnapKitty Research Lab.
License: GNU Affero General Public License, version 3. The operative text is [`LICENSE`](LICENSE). A short grant notice is in [`COPYING.md`](COPYING.md). Authors are listed in [`AUTHORS.md`](AUTHORS.md).

This repository is a research counterclaim. It is not a court pleading, not a FIPS module, and not a replacement cryptosystem. It records why the multiplicity operator in Ty Van Gelder's Quantum-Multiplicity Hybrid Encryption System does not do the work his appendix assigns to it, and it removes that operator from the normative path.

## What this repository is

SnapKitty Research Lab holds the copyright in this tree through Bel esprit D'accord Trust. Ahmad Ali Parr and Jessica Westerhoff are the named researchers. The work under critique is not ours. It is Ty Van Gelder's, published under the byline Ryan O. Van Gelder, Multiplicity Foundation and Citizen Gardens. The system claims are taken from *QMHES — Mathematical Appendix*, Multiplicity Foundation, 2026, PhaseMirror-HQ, as embedded in [`source/supplied-counter-source.md`](source/supplied-counter-source.md). The theory background is *Multiplicity Theory — Foundations and Applications*, DOI [10.13140/RG.2.2.18053.46568](https://doi.org/10.13140/RG.2.2.18053.46568), July 2025, CC BY-NC-SA 4.0. His appendix section 2.3 also describes the theory as "R. Van Gelder (Multiplicity 2024, MIT/CC BY-SA 4.0)." Both notices are recorded. Neither is replaced by the AGPL grant on this tree.

The split is deliberate. Quotations of his claims stay attributed to him. The counterclaim, the architecture decision records, the Alloy modules, the Lean sketches, the MATLAB runners, and the Python check of his Test 3 vector are the lab's. If you reuse those files, the AGPL applies, including the network-use clause: if you run a modified version as a network service, you must offer the corresponding source to users of that service.

## His claims, cited

The extract is [`docs/ORIGINAL-CLAIMS.md`](docs/ORIGINAL-CLAIMS.md). The short form is enough to see what is being refused.

He describes QMHES as a four-layer stack. The layers are a quantum-state frequency bridge, the QAHES v1.0.1 wire protocol, a physical QKD adapter, and a Multiplicity Theory feedback layer. He writes that no prior published system combines all four. Two of the four are existing primitives: ML-KEM-1024 (FIPS 203), ML-DSA-87 (FIPS 204), AES-256-GCM or ChaCha20-Poly1305, and HKDF-SHA-256. Their security is not the object of this counterclaim. The object is the layer he himself marks, in Table 1 of the appendix, as "Novel – hardness TBD" for the frequency map and "Novel – formally unproven" for the multiplicity operator.

Definition 3.3 introduces a multiplicity operator \(\mathcal{M}_t\) depending on a norm of the quantum state, a bit-error rate, session load, and QBER. Definition 3.4 introduces a coupling tensor \(\mathcal{T}_t^{ij} = \langle x_i | \alpha_j \rangle_{\mathrm{cross}}\) without defining the cross inner product. Definition 3.7 maps each quantum amplitude by magnitude and phase, \(F_q(\alpha_j) = (|\alpha_j|, \arg(\alpha_j))\). Definition 3.8 forms a unified frequency set by union with a classical tone map. Definition 3.11 binds \(F_t\), \(\mathcal{M}_t\), and \(\mathcal{T}_t\) into AEAD associated data. Definition 3.12 extends the HKDF info string with \(\mathrm{encode}(\mathcal{M}_t)\) and rotates keys only when the Frobenius gap exceeds a threshold \(\theta_{\mathrm{rotate}}\).

Equation 24 is the update he prints:

\[
\mathcal{M}_{t+1} = \Pi_{\mathcal{B}}\big[\mathcal{M}_t + \eta \nabla_{\mathcal{M}}\mathcal{L}(\mathcal{M}_t, s_t)\big].
\]

Proposition 3.13 says that if \(\mathcal{L}\) is \(\mu\)-strongly convex and \(\eta < 2/\mu\), the iteration is Lyapunov-stable and converges geometrically to a minimizer. The implementation sketch in section 5.6 copies the plus sign and then clips singular values to \([0, 1]\). Section 4.3 requires the receiver to abort the session on any sequence gap. Sliding-window replay is deferred to a v2.0 roadmap item. The published HKDF test vectors in section 3.4 do not depend on \(\mathcal{M}_t\), \(F_t\), or QKD. They are ordinary HKDF-SHA-256.

A related claim appears in the 2025 foundations preprint: prime-powered multiplicities are said to raise the cost of factoring enough to resist a quantum attack. That claim is countered here as well. Unique factorization is the structure Shor's algorithm uses. Labeling a message with primes does not change the order of that algorithm on an integer.

## The counterclaim

The instrument is [`docs/COUNTERCLAIM.md`](docs/COUNTERCLAIM.md). The technical note is [`docs/COUNTER-PAPER.md`](docs/COUNTER-PAPER.md). The ten instability axioms from the supplied markdown are graded in [`docs/AXIOMS.md`](docs/AXIOMS.md). Six points carry the refusal.

First, the printed update is ascent. The contraction he invokes is a descent theorem. For an \(L\)-smooth \(\mu\)-strongly convex cost, projected gradient descent contracts for a step below \(2/L\), and the usual optimal step \(2/(\mu+L)\) contracts at \((L-\mu)/(L+\mu)\). Substituting the printed plus sign reverses the flow. On a strongly convex cost, ascent leaves a neighborhood of the minimizer. ADR 001 later flips the sign. That flip is a different algorithm. It is not a proof of equation 24.

Second, the phase map does not preserve the norm it is asked to preserve. Unitarity gives \(\sum_j |\alpha_j|^2 = 1\). It does not give \(\sum_j (|\alpha_j|^2 + \arg(\alpha_j)^2) = 1\). A global phase moves \(F_q\) even when the ray is the same. The Cartesian embedding \(F'_q(\alpha_j) = (\operatorname{Re}\alpha_j, \operatorname{Im}\alpha_j)\) is an isometry of \(\mathbb{C}^n\) with \(\mathbb{R}^{2n}\). It is not Definition 3.7, and it does not authenticate anything by itself. Injectivity of the unified set is listed in the appendix outline and not proved. A union of classical tones and amplitude-phase pairs can collide if the tone alphabet meets the image of \(F_q\). That is a gap in the stated map, not a concrete break of AES-GCM.

Third, spectral projection does not survive the encoding he specifies. Metric projection onto a closed convex set is non-expansive in exact arithmetic. The set of matrices with spectral norm at most one is convex. The set of matrices whose singular values have been clipped and then encoded at \(w\) bits on two hosts is not the same set. Independent rounding can leave the admissible set or produce distinct encodings of matrices that were close. Definition 3.12 feeds the encoding into HKDF info. If the encodings differ, the AEAD keys differ. The channel fails closed. That is a liveness bug, not a confidentiality proof.

Fourth, the sequence rule he marks normative turns one dropped or reordered datagram into session death. Test 3 in the appendix uses the input `(0, 1, 2, 3, 5, 4, 6, 5, 6)` and the pattern `AAAARARAA`, with final expected sequence 7. Under the v1.0.1 abort rule the session is dead at the first reject, sequence 5 where 4 was expected. Continuing the pattern is only how the test is scored. Both readings are implemented in [`python/qmhes_counter/sequence.py`](python/qmhes_counter/sequence.py).

Fifth, joint input keying material from ML-KEM-1024 and a QKD string is not shown to be independent. Section 3.4 extracts a pseudorandom key from a single shared secret. A biased QKD string concatenated or mixed with a KEM secret needs a dual-PRF or split-KDF argument. None is given. Physical QKD is therefore out of the normative path. It is not required for the FIPS data plane.

Sixth, a Frobenius threshold leaves a deadband. Equation 22 rotates only above \(\theta_{\mathrm{rotate}}\). Sub-threshold steps can accumulate and still move an encoding. The Alloy witness is `sub_threshold_drift` in [`models/alloy/qmhes_protocol_stability.als`](models/alloy/qmhes_protocol_stability.als).

None of these points is a proof of insecurity of ML-KEM, ML-DSA, AES-GCM, ChaCha20-Poly1305, or BB84. The refusal is local to the QMHES-specific operator, the frequency map, and the stability proposition.

## ADR 004, removal of multiplicity

[`adr/ADR-004.md`](adr/ADR-004.md) is the normative decision. It is Accepted. Owner is Bel esprit D'accord Trust. Researchers are Ahmad Ali Parr and Jessica Westerhoff.

The decision removes \(\mathcal{M}_t\), \(\mathcal{T}_t\), the feedback map \(f\), and any encode-into-HKDF of those objects from the data plane. Key encapsulation on the remaining path is ML-KEM-1024. Authentication is ML-DSA-87 or SLH-DSA. The data plane is AES-256-GCM or ChaCha20-Poly1305. Transcript binding is the SHA-256 chain in his equations 8–19, without \(F_t\), \(\mathcal{M}_t\), or \(\mathcal{T}_t\) in associated data. Session validity keeps his Test 3 as a check, not as a liveness design. Abort-on-gap is recorded as his availability defect. A later record may add a window. ADR 004 does not.

ADR 001, ADR 002, and ADR 003 stay in the tree. They are superseded.

ADR 001 replaced the phase map with a Cartesian embedding, flipped the update to descent, and then left the matrix for a point on an elliptic curve \(E(\mathbb{F}_p)\), with \(P_t = [k_t] P_{t-1} \oplus G\). Hasse's theorem bounds the group order. It does not preserve a spectral norm, because the matrix is gone. The MATLAB runner checks that a test point stays on \(y^2 = x^3 + 2x + 3 \pmod{97}\). That is a group-law unit test, not a security reduction to the elliptic-curve discrete logarithm. ADR 004 withdraws the point as well. A descendant of \(\mathcal{M}_t\) is still a multiplicity state.

ADR 002 dropped physical QKD and replaced the operator with a bifurcation index \(S_{t+1} = 2 S_t + (H(S_t \| \mathrm{payload}) \bmod 2)\), mapped through a Vandermonde minor over a small prime field. A public tree index is a domain separator, not a secret. An invertible linear map over \(\mathbb{F}_p\) is not a key-encapsulation mechanism and is not a claim that Shor's algorithm fails against it. ADR 004 withdraws the index.

ADR 003 built a lookup table in the style of a CRYSTALS ring with the Module-LWE error term removed, then iterated until Shannon entropy was 0.0. ML-KEM is a KEM because of that error term. Deleting it deletes the assumption. A constant bound into HKDF info adds no min-entropy. The record is kept so the source can be inspected. It is not a key schedule, and ADR 004 supersedes it.

The index is [`adr/README.md`](adr/README.md).

## Models and runners

The Alloy modules are relational witnesses, not analytic proofs. [`models/alloy/qmhes_counter.als`](models/alloy/qmhes_counter.als) asks whether a state can contain a matrix whose spectral field exceeds 1. [`models/alloy/qmhes_protocol_stability.als`](models/alloy/qmhes_protocol_stability.als) places three predicates against the assertion "no abort and norm at most 1": a sequence gap that aborts, an encoding desynchronization with successor norm above 1, and two sub-threshold steps whose sum meets the threshold. Alloy integers are not matrix norms. The check is expected to fail. It has not been claimed as an Analyzer run in this tree.

The Lean files extract the invariant the appendix claims and leave the proof as `sorry`. [`models/lean/MultiplicityInvariant.lean`](models/lean/MultiplicityInvariant.lean) records the spectral bound. [`models/lean/ConvergenceFailure.lean`](models/lean/ConvergenceFailure.lean) states the intended gap: non-expansiveness of a projection is not inherited by a finite encoding. Neither file is a machine-checked refutation.

The MATLAB routines are the blocks from the supplied markdown, split so each `execute_*` file is a primary function with its helpers. `matlab/adr001/execute_qmhes_framework.m` runs the Cartesian norm check, the \(2\sqrt{2}\) bound check, the grid quantizer, and the elliptic group law on the test curve. `matlab/adr002/execute_holographic_pq_framework.m` walks a bifurcation index and checks a Vandermonde minor. `matlab/adr003/execute_entropy_drain_framework.m` is the entropy drain. Do not use it as a key schedule. `matlab/roadmap/execute_qmhes_production_inversion.m` scores Test 3 and checks the CLASSIC MESSAGE byte layout. Span markers from the source markdown were editorial noise and were not copied.

The only check that runs without an Alloy Analyzer, a Lean toolchain, or MATLAB is the Python reading of Test 3:

```
PYTHONPATH=python python -m unittest tests.test_sequence -v
```

Expected: the published pattern `AAAARARAA` and final counter 7; the normative abort at index 4, sequence 5, expected 4; HMAC input layout `msg_type[1] || seq[4, big-endian] || plen[2, big-endian] || payload`. His PRK anchor for 32 zero bytes of salt and IKM matches HMAC-SHA-256 and equals `33ad0a1c607ec03b09e6cd9893680ce210adf300aa1f2660e1b22e10f170f92a`. That anchor does not depend on multiplicity.

## What is kept, and what is not

Kept, as citations of standards and RFCs rather than as theorems of Multiplicity Theory: ML-KEM-1024, ML-DSA-87, SLH-DSA, AES-256-GCM, ChaCha20-Poly1305, SHA-256, HKDF as in RFC 5869. The byte layout of his CLASSIC MESSAGE HMAC input is an ordinary authenticated framing rule. The section 5.1 scaffold in the appendix signs with HMAC-SHA3-256 expanded by SHAKE and says the stub must be replaced by liboqs. A stub is not a FIPS 204 module. This repository does not vendor liboqs and does not claim a validated module.

Not kept: the frequency-space union, the coupling tensor, prime-indexed eigenvalues \(\lambda_{p_i} = 1/p_i\) as a stability mechanism, the Lyapunov projection, the elliptic descendant, the bifurcation index as a key, and the entropy drain. Physical QKD is out of scope. Nothing on the normative path depends on prime-indexed recurrence.

## License

Copyright 2026 Bel esprit D'accord Trust.

This program is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version. The license text shipped with this repository is [`LICENSE`](LICENSE). If that file is missing from a copy, the license is published at <https://www.gnu.org/licenses/agpl-3.0.html>.

This program is distributed in the hope that it will be useful, but without any warranty; without even the implied warranty of merchantability or fitness for a particular purpose. See the GNU Affero General Public License for details.

The Affero clause matters if you modify this tree and run it as a service. Users who interact with that service over a network must be able to receive the corresponding source. The counterclaim text, the ADRs, the models, and the runners are covered. Quotations of the QMHES appendix and of Multiplicity Theory are not relicensed. His CC BY-NC-SA 4.0 preprint notice, and the MIT / CC BY-SA notice in the appendix, remain his. Do not strip the copyright header from [`AUTHORS.md`](AUTHORS.md) or the third-party paragraph at the top of [`LICENSE`](LICENSE).

## Layout

```
LICENSE                         AGPL-3.0 text
COPYING.md                      short grant
AUTHORS.md                      Trust, lab, researchers
CITATION.cff                    citation metadata
docs/COUNTERCLAIM.md            research counterclaim
docs/COUNTER-PAPER.md           technical note
docs/ORIGINAL-CLAIMS.md         his claims, quoted
docs/AXIOMS.md                  ten instability axioms
adr/ADR-004.md                  removal of multiplicity (normative)
adr/ADR-001.md                  superseded elliptic descendant
adr/ADR-002.md                  superseded bifurcation descendant
adr/ADR-003.md                  superseded entropy drain
models/alloy/                   relational counter-models
models/lean/                    invariant sketches (sorry)
matlab/                         runners from the supplied markdown
python/qmhes_counter/           Test 3 runner
tests/test_sequence.py          unittest
source/supplied-counter-source.md
```

## How to cite

Cite this repository for the counterclaim and for ADR 004. Cite Van Gelder separately for Multiplicity Theory and for the QMHES appendix. A machine-readable record is [`CITATION.cff`](CITATION.cff).

Suggested form: Bel esprit D'accord Trust, SnapKitty Research Lab (Ahmad Ali Parr and Jessica Westerhoff), *SnapKitty counterclaim against Multiplicity*, 2026, <https://github.com/AHMADALIPARR/snapkitty-multiplicity-counterclaim>, GNU AGPL-3.0.

Respondent work: Ryan O. Van Gelder, *QMHES — Mathematical Appendix*, Multiplicity Foundation, 2026; Ryan O. Van Gelder, *Multiplicity Theory — Foundations and Applications*, DOI 10.13140/RG.2.2.18053.46568, 2025.
