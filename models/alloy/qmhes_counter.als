// Counter-model 1 from source/supplied-counter-source.md
// Target claim (Van Gelder, QMHES Mathematical Appendix, 2026, Prop. 3.13
// and the SVD sketch in §5.6): projection Pi_B keeps spectral norm <= 1.
// This module only asks Alloy whether a state can contain a matrix whose
// spectral field exceeds 1. It does not encode the projection.

module qmhes_counter

sig State {
    matrix: set Matrix,
    qber: Int,
    load: Int
}

sig Matrix {
    spectral_norm: Int,
    psd: Bool
}

pred violates_spectral_bound[s: State, m: Matrix] {
    // Counter-claim: under a delta the source does not constrain,
    // a matrix sitting in the state can have spectral_norm > 1.
    m.spectral_norm > 1 and m in s.matrix
}

run { some s: State, m: Matrix | violates_spectral_bound[s, m] } for 3
