-- Counter-statement from source/supplied-counter-source.md.
-- Claim under critique: Van Gelder, QMHES Mathematical Appendix, 2026,
-- Proposition 3.13, iteration (24), and encode(M_t) in Definition 3.12.
-- This theorem is a sketch. The projection and the gradient are sorry.

import Mathlib.Analysis.InnerProductSpace.Basic
import Mathlib.Topology.MetricSpace.Lipschitz
import Mathlib.LinearAlgebra.Matrix.Trace
import Mathlib.Analysis.Convex.Basic

variable {k : ℕ}

structure MultiplicityState (k : ℕ) where
  M : Matrix (Fin k) (Fin k) ℝ
  is_psd : M.PosDef ∨ M = 0
  norm_bounded : ‖M‖ ≤ 1

noncomputable def Pi_B (X : Matrix (Fin k) (Fin k) ℝ) : MultiplicityState k := sorry

-- Source claim: finite encoding breaks non-expansiveness of Pi_B, so the
-- spectral bound need not hold on the encoded update. Not a completed proof.
theorem qmhes_convergence_failure
    (η : ℝ) (μ L : ℝ) (hη : η < 2 / (μ + L))
    (M_t : MultiplicityState k)
    (encode : MultiplicityState k → Matrix (Fin k) (Fin k) ℚ) :
    ∃ s_t : ℝ,
      ¬ (‖(Pi_B (M_t.M - η • (0 : Matrix (Fin k) (Fin k) ℝ))).M‖ ≤ 1) := by
  sorry
