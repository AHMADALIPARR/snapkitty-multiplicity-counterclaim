# Ten instability axioms

Taken from `source/supplied-counter-source.md`, section "The 10 Bifurcating Axioms of QMHES Instability". Each axiom is a counter to a claim in Ryan O. Van Gelder, *QMHES — Mathematical Appendix*, Multiplicity Foundation, 2026. They are not proved in Alloy or Lean in this tree. Force of each item is graded in `docs/COUNTER-PAPER.md` §5.

1. **Unified frequency mapping loses injectivity under adversarial amplitude tuning.** Definition 3.7–3.8. An amplitude whose image meets \(f_c^\pm\) collides inside \(F_t\). The appendix lists injectivity in outline F and does not prove it.
2. **Lyapunov stability relies on non-expansive SVD projections that need distributed consensus.** §5.6 clips singular values. Independent fixed-point SVD need not agree, so `encode(M_t)` in Definition 3.12 need not agree. HKDF info diverges and the AEAD keys diverge.
3. **Coupling tensor rank drops when QBER spikes.** Definition 3.4 writes \(\mathcal{T}_t^{ij} = \langle x_i | \alpha_j \rangle_{\mathrm{cross}}\) without a definition of the cross inner product. No entropy bound is proved for the associated data in Definition 3.11.
4. **Strict in-order validation turns jitter into abort.** §4.3. One gap aborts. Sliding window is phase 8 / v2.0. Witness: Test 3, first reject at sequence 5 when 4 was expected.
5. **Prime-indexed eigenvalues \(\lambda_{p_i} = 1/p_i\) are slower for large primes.** Stated as Iteration 1 of the supplied axioms. The appendix does not derive a rate.
6. **Joint IKM from ML-KEM-1024 and QKD is not shown independent.** §3.4 extracts PRK from a single \(K\). A biased QKD string concatenated or XORed with a KEM secret needs a dual-PRF or split-KDF argument. None is given.
7. **Frobenius threshold leaves a deadband.** Equation 22 rotates only above \(\theta_{\mathrm{rotate}}\). Sub-threshold steps can accumulate. Alloy witness: `sub_threshold_drift` in `models/alloy/qmhes_protocol_stability.als`.
8. **Quantum map Lipschitz constant \(\sqrt{17}\) is not derived.** The supplied rectification notes record the constant as fabricated relative to a stated \(2\sqrt{2}\). Cartesian embedding has Lipschitz constant 1. Neither constant authenticates \(F_t\).
9. **Context hash needs a uniqueness assumption on the KEM ciphertext and labels.** Equations 8–13. Identical SID inputs produce identical transcript prefixes. Intra-session sequence counters do not separate cloned sessions.
10. **The cost \(\mathcal{L}\) is evaluated on a local \(s_t\).** Equation 23. Alice's \((\varepsilon, \lambda, \mathrm{QBER}, \Delta)\) is not Bob's. A shared minimizer is assumed, not shown.
