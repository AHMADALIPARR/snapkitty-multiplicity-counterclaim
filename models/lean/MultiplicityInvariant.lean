-- Invariant extraction from Van Gelder, QMHES Mathematical Appendix, 2026,
-- Definition 3.12 / Proposition 3.13 / §5.6 SVD sketch.
-- The appendix does not contain a Lean development. This file records the
-- invariant the paper claims. The proof is not discharged.

import Mathlib.LinearAlgebra.Matrix.Spectrum
import Mathlib.Analysis.InnerProductSpace.PiL2

set_option autoImplicit false

structure MultiplicityState (k : Type) [NormedAddCommGroup k] [InnerProductSpace ℝ k] where
  M : Matrix (Fin 4) (Fin 4) ℝ
  psd : 0 ≤ M
  spectral_bound : Matrix.spectralNorm M ≤ 1

-- Paper equation 24 uses + η • grad. The comment in the source sketch
-- assumes a projection that restores the bound. Neither the projection
-- nor the sign is defined in this file.
theorem multiplicity_invariant_preserved
    (t : ℕ) (st : MultiplicityState ℝ) (η : ℝ) (grad : Matrix (Fin 4) (Fin 4) ℝ)
    (h_eta : 0 < η ∧ η < 2 / 10) :
    let M_next := st.M + η • grad
    Matrix.spectralNorm M_next ≤ 1 := by
  sorry
