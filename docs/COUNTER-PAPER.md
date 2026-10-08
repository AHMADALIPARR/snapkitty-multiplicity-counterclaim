# Our paper against the QMHES claims

**Authors.** This paper and the successor architecture are ours. The system under critique is not.
**Original system.** Ty Van Gelder, published byline Ryan O. Van Gelder, Multiplicity Foundation / Citizen Gardens. *QMHES — Mathematical Appendix*, 2026, PhaseMirror-HQ. Theory: *Multiplicity Theory — Foundations and Applications*, DOI 10.13140/RG.2.2.18053.46568, 2025.
**Successor.** ADR 001–003 in this repository. Source of the models: `source/supplied-counter-source.md`.

## 1. Scope

Van Gelder claims a four-layer construction: a frequency bridge between classical bits and quantum amplitudes, a byte-exact QAHES v1.0.1 wire protocol, a QKD adapter, and a prime-indexed feedback operator \(\mathcal{M}_t\). He writes that no prior system combines all four, and that under mild conditions the feedback recursion converges geometrically to a unique minimizer (Proposition 3.13, equation 24).

Two of the four layers are existing primitives (ML-KEM-1024 / FIPS 203, ML-DSA-87 / FIPS 204, AES-256-GCM, HKDF-SHA-256). Their security is not at issue here. The claims that fail are the ones he marks, in his own Table 1, as "hardness TBD" and "formally unproven", plus the stability proposition that contradicts the printed update rule.

## 2. The update rule is ascent; the proposition assumes descent

Equation 24 is

\[
\mathcal{M}_{t+1} = \Pi_{\mathcal{B}}\big[\mathcal{M}_t + \eta \nabla_{\mathcal{M}}\mathcal{L}(\mathcal{M}_t, s_t)\big].
\]

Proposition 3.13 says: if \(\mathcal{L}\) is \(\mu\)-strongly convex and \(\eta < 2/\mu\), then the iteration is Lyapunov-stable and converges geometrically to \(\mathcal{M}^*\).

That contraction is the standard result for projected gradient **descent**,

\[
\mathcal{M}_{t+1} = \Pi_{\mathcal{B}}\big[\mathcal{M}_t - \eta \nabla_{\mathcal{M}}\mathcal{L}(\mathcal{M}_t, s_t)\big],
\]

and the step-size restriction for an \(L\)-smooth \(\mu\)-strongly convex function is \(\eta < 2/L\), not \(\eta < 2/\mu\). For descent with \(\eta = 2/(\mu+L)\) the optimal factor is \((L-\mu)/(L+\mu)\). Substituting the printed plus sign reverses the flow. On a strongly convex cost, ascent leaves any neighborhood of the minimizer. The Python sketch in appendix §5.6 copies the plus sign. ADR 001 in the supplied notes rewrites the sign; that is a different algorithm, not a proof of equation 24.

## 3. The frequency map does not preserve the norm it is asked to preserve

Definition 3.7 sets \(F_q(\alpha_j) = (|\alpha_j|, \arg(\alpha_j))\) with \(\arg(\alpha_j) \in [0, 2\pi)\). Unitarity gives \(\sum_j |\alpha_j|^2 = 1\). It does not give

\[
\sum_j \big(|\alpha_j|^2 + \arg(\alpha_j)^2\big) = 1.
\]

A global phase multiplies every \(\arg\) term and moves \(F_q\) even when \(|\psi\rangle\) is physically the same ray. The Cartesian embedding

\[
F'_q(\alpha_j) = (\operatorname{Re}\alpha_j, \operatorname{Im}\alpha_j)
\]

does satisfy \(\|F'_q\|_2 = 1\). That map is an isometry of \(\mathbb{C}^n \cong \mathbb{R}^{2n}\). It is not the map in Definition 3.7, and it does not by itself authenticate anything. Injectivity of the unified set \(F_t = F_c(x) \cup F_q(|\psi\rangle)\) is listed in the appendix outline and not proved. A set-union of classical tones and amplitude-phase pairs can collide if the classical tone alphabet is not disjoint from the image of \(F_q\). The supplied Axiom 1 records that collision as a forgery path against associated data. It is a gap in the stated map, not a concrete attack on AES-GCM.

## 4. Spectral projection does not survive the encoding he specifies

He asks \(\Pi_{\mathcal{B}}\) to enforce a spectral bound (implementation: clip singular values to \([0,1]\)). In exact arithmetic, metric projection onto a closed convex set is non-expansive. Two facts break the inference he needs:

1. The set of matrices with spectral norm at most 1 is convex. The set of matrices with singular values clipped and then re-encoded at \(w\) bits is not the same set. Independent rounding on two hosts can leave the admissible set or produce distinct encodings of matrices that were close.
2. Definition 3.12 feeds \(\mathrm{encode}(\mathcal{M}_t)\) into HKDF info. If Alice and Bob do not compute the same encoding, they do not compute the same AEAD key. The channel fails closed. That is a liveness bug, not a confidentiality proof.

`models/alloy/qmhes_counter.als` is the small relational witness: a state may contain a matrix whose spectral field exceeds 1. `models/alloy/qmhes_protocol_stability.als` is the three-way counter (sequence abort, SVD encoding desync, sub-threshold drift) against the assertion "no abort and norm ≤ 1". `models/lean/ConvergenceFailure.lean` states the intended gap — non-expansiveness of \(\Pi_{\mathcal{B}}\) is not inherited by a finite encoding — and leaves the proof as `sorry`. Neither file is a machine-checked refutation.

## 5. Ten instability axioms, and how far each goes

The supplied note "The 10 Bifurcating Axioms of QMHES Instability" is the working list. Each item is a claim about the paper, not a new primitive.

| # | Paper claim | Counter in the source | Force |
| --- | --- | --- | --- |
| 1 | \(F_t\) unifies classical and quantum frequencies | Adversarial amplitudes can land on \(f_c^\pm\) | Map not shown injective |
| 2 | \(\Pi_{\mathcal{B}}\) is stable across the session | SVD / fixed-point encodings diverge | Desynchronizes HKDF info |
| 3 | \(\mathcal{T}_t^{ij} = \langle x_i \vert \alpha_j\rangle_{\mathrm{cross}}\) binds subsystems | Rank drop at high QBER loosens the stated op-norm | Associated-data entropy not proved |
| 4 | Any sequence gap aborts (v1.0.1 §4.3) | One loss or reorder aborts | Availability; confirmed by Test 3 |
| 5 | \(\lambda_{p_i} = 1/p_i\) gives structural determinism | High-prime modes decay slowly | No rate proved in the appendix |
| 6 | ML-KEM and QKD IKM compose | A biased QKD string is not independent of the KEM secret | Composition needs a KEM-DEM / dual-PRF argument he does not give |
| 7 | Rotation iff Frobenius gap exceeds \(\theta\) | Drift can stay under the threshold and still move the encoding | Deadband |
| 8 | \(F_q\) has Lipschitz constant \(\sqrt{17}\) | Constant is not derived; Cartesian map has constant 1 | Bound is ornamental |
| 9 | Transcript hash binds the session | Same KEM ciphertext and labels replay the prefix | Needs a session-id uniqueness argument |
| 10 | Unique minimizer \(\mathcal{M}^*(s^*)\) | Alice and Bob observe different \((\varepsilon,\lambda,\mathrm{QBER})\) | Coupled fixed point not shown |

Axiom 4 is the one with a fully specified witness. The appendix Test 3 vector is `(0,1,2,3,5,4,6,5,6)` with pattern `AAAARARAA` and final counter 7. Under the normative abort rule the session is dead at the first `R`. Continuing the pattern is only how the test is scored. `python/qmhes_counter/sequence.py` reproduces both readings.

## 6. Successor architecture

The three ADRs are our system. They are not a proof that his equation 24 already converged.

ADR 001 replaces Definition 3.7 with the Cartesian embedding, flips equation 24 to descent, then leaves the matrix for a point on \(E(\mathbb{F}_p)\): \(P_t = [k_t]P_{t-1} \oplus G\), with \(k_t\) from quantized QBER and load. Hasse's bound limits the group order. It does not preserve a spectral norm, because the matrix is gone. The MATLAB in `matlab/adr001/` checks that the test point stays on \(y^2 = x^3 + 2x + 3 \bmod 97\).

ADR 002 drops physical QKD and replaces \(\mathcal{M}_t\) by a bifurcation index \(S_{t+1} = 2S_t + (H(S_t \| \mathrm{payload}) \bmod 2)\), mapped through a Vandermonde minor over \(\mathbb{F}_p\). That is an exact shared index, not a KEM. The data-plane KEM remains ML-KEM-1024.

ADR 003 strips the Module-LWE error term and iterates until Shannon entropy is 0. That construction is ours and it is recorded, but it is not the key schedule: a constant bound into HKDF info adds no min-entropy. ML-KEM stays the encapsulation layer.

## 7. What survives

The byte layout he specifies for CLASSIC MESSAGE HMAC input — `msg_type[1] || seq[4,BE] || plen[2,BE] || payload` — is an ordinary authenticated framing rule. HKDF-SHA-256 with the published labels is an ordinary KDF. ML-KEM-1024 and ML-DSA-87 are NIST standards. None of these require Multiplicity Theory. The appendix §5.1 scaffold signs with HMAC-SHA3-256 expanded by SHAKE and says the stub must be replaced by liboqs. A stub is not a FIPS 204 module.

## 8. Artifacts

- Claims extract: `docs/ORIGINAL-CLAIMS.md`
- Alloy: `models/alloy/`
- Lean sketches: `models/lean/`
- MATLAB from the source: `matlab/`
- Test 3 runner: `python/qmhes_counter/sequence.py`
- Supplied markdown: `source/supplied-counter-source.md`

No artifact in this repository is a proof of insecurity of ML-KEM, ML-DSA, AES-GCM, or BB84. The insecurity result is local: the QMHES-specific operator, frequency map, and stability proposition do not have the properties the appendix asserts.
