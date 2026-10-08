# Original claims under critique

Author of the claims: **Ryan O. Van Gelder** (appendix spelling: R. Van Gelder), Multiplicity Foundation / Citizen Gardens.

Source of the system claims: *QMHES — Mathematical Appendix*, Multiplicity Foundation, 2026, PhaseMirror-HQ. Page numbers below follow the appendix pagination embedded in `source/supplied-counter-source.md`. Theory background: Van Gelder, *Multiplicity Theory — Foundations and Applications*, DOI 10.13140/RG.2.2.18053.46568, July 2025.

These are his claims. They are not findings of this repository.

## Novelty claim

> "The primary novel contribution of QMHES is the unified architecture combining (a) a frequency-space bridge between classical bits and quantum amplitudes governed by Multiplicity Theory operators, (b) a byte-exact, formally verifiable wire protocol with PQ and QKD key material, and (c) a non-linear adaptive feedback mechanism that continuously adjusts cryptographic parameters based on observable system state. No prior published system combines all four layers in this manner."

Appendix §1, p. 3.

The four layers he names are QSBS, QAHES v1.0.1, physical QKD, and the Multiplicity Theory feedback layer.

## Multiplicity Theory attribution

> "Multiplicity Theory, originated by R. Van Gelder (Multiplicity 2024, MIT/CC BY-SA 4.0), is a prime-indexed, recursively stable mathematical framework wherein multiplicity—the recurrence of elements understood through prime number decomposition—forms the basis for modeling nonlinear, emergent structures."

Appendix §2.3, p. 4.

## Frequency-space unification

Definition 3.7 maps each amplitude by magnitude and phase:

\[
F_q(\alpha_j) = \big(|\alpha_j|,\; \arg(\alpha_j)\big)
\]

Definition 3.8 forms the unified set \(F_t = F_c(x_t) \cup F_q(|\psi_t\rangle)\). Appendix §3.2, pp. 5–6.

He does not prove injectivity of \(F_t\) in the appendix body. The later outline heading "F Frequency Map: Injectivity and Invertibility" is a table-of-contents stub, not a proof.

## Encryption operator and key schedule

Definition 3.11 binds frequency set, multiplicity operator, and coupling tensor into AEAD associated data:

\[
C_t = \mathrm{AEAD}_{K_{\mathrm{enc},d,t}}\big(\mathrm{nonce}_{d,t},\, x_t;\; \sigma_t \,\|\, F_t \,\|\, \mathcal{M}_t \,\|\, \mathcal{T}_t\big)
\]

Definition 3.12 extends HKDF info with \(\mathrm{encode}(\mathcal{M}_t)\) and rotates when

\[
\|\mathcal{M}_{t+1} - \mathcal{M}_t\|_F > \theta_{\mathrm{rotate}}
\]

Appendix §3.6, p. 7.

## Feedback law and stability proposition

Printed update (equation 24, p. 7), gradient **ascent**:

\[
\mathcal{M}_{t+1} = \Pi_{\mathcal{B}}\big[\mathcal{M}_t + \eta \nabla_{\mathcal{M}}\mathcal{L}(\mathcal{M}_t, s_t)\big]
\]

Proposition 3.13 (p. 7):

> "If \(\mathcal{L}\) is \(\mu\)-strongly convex in \(\mathcal{M}\) and \(\eta < 2/\mu\), then the iteration (24) is Lyapunov-stable and \(\mathcal{M}_t \to \mathcal{M}^*\) geometrically."

The implementation sketch in §5.6 uses the same ascent step, then clips singular values to \([0,1]\):

```
Mnew = self.M + eta * grad
U, sv, Vt = np.linalg.svd(Mnew)
sv_clipped = np.clip(sv, 0, 1.0)
```

## Sequence rule

§4.3, p. 9, normative:

1. `expected_next_seq[sender] ← 0`
2. Reject any frame where `msg.sequence ≠ expected_next_seq[sender]`
3. On validation failure: abort the session (v1.0.1)
4. On acceptance: increment

Test 3 vector: input `(0,1,2,3,5,4,6,5,6)` produces `(A,A,A,A,R,A,R,A,A)` with final expected sequence 7. Sliding-window replay is a v2.0 item (§6.1, phase 8).

## What he marks unproven

Table 1 (p. 8) labels the QSBS frequency layer "Novel – hardness TBD" and the multiplicity layer "Novel – formally unproven". ML-KEM-1024 and ML-DSA-87 are cited as FIPS 203 / 204, i.e. as existing standards, not as theorems of Multiplicity Theory.

## HKDF test vectors he publishes

Appendix §3.4, salt `00` repeated 32 times:

- \(K_{A\to B} = \texttt{dd70c9f5110ea586dac2ba20569481ad03d8df346c9d17cd78cbf70a9cd2c9e5}\)
- \(K_{B\to A} = \texttt{da2273fed3c28f397e687de459ea37f5bef4fa7af6047c0af48ab3c98f390c6a}\)
- PRK anchor in §5.7: `33ad0a1c607ec03b09e6cd9893680ce210adf300aa1f2660e1b22e10f170f92a` for IKM = salt = 32 zero bytes

Those vectors are ordinary HKDF-SHA-256. They do not depend on \(\mathcal{M}_t\), \(F_t\), or QKD.
