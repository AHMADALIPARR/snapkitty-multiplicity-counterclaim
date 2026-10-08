// Counter-model 2 from source/supplied-counter-source.md
// Claims countered, all from Van Gelder, QMHES Mathematical Appendix, 2026:
//   §4.3  any sequence gap aborts the session
//   §5.6  SVD clip enforces spectral norm <= 1
//   eq. 22 rotation iff Frobenius gap > theta_rotate
// The assertion is expected to fail. Alloy integers are not matrix norms;
// the predicates are relational witnesses, not analytic proofs.

module qmhes_protocol_stability

open util/ordering[State]

sig Node {}

sig Matrix {
    norm: Int,
    encoding: Int
}

sig State {
    M: Matrix,
    T: Matrix,
    qber: Int,
    seq: Int,
    aborted: set Node
}

-- Claim counter 1: sequence validation aborts on any gap (§4.3).
-- Witness: a gap of 1 (UDP drop or reorder) puts a node in aborted.
pred network_jitter_abort[s, s': State, n: Node] {
    s'.seq = add[s.seq, 2]
    n in s'.aborted
}

-- Claim counter 2: projection onto B guarantees norm <= 1 (§5.6).
-- Witness: equal norm, distinct fixed-point encodings, successor norm > 1.
pred svd_desync_divergence[s, s': State] {
    s.M.norm = 1
    s'.M.encoding != s.M.encoding
    s'.M.norm > 1
}

-- Claim counter 3: rotation when ||M_{t+1} - M_t||_F > theta (eq. 22).
-- Witness: two sub-threshold steps whose sum meets the threshold.
pred sub_threshold_drift[s, s', s'': State] {
    let diff1 = minus[s'.M.norm, s.M.norm] | diff1 < 1
    let diff2 = minus[s''.M.norm, s'.M.norm] | diff2 < 1
    let total_drift = minus[s''.M.norm, s.M.norm] | total_drift >= 2
}

fact system_transitions {
    all s: State, s': s.next {
        network_jitter_abort[s, s', Node] or
        svd_desync_divergence[s, s'] or
        sub_threshold_drift[s, s', s.next.next]
    }
}

assert protocol_stability {
    all s: State | no s.aborted and s.M.norm <= 1
}

check protocol_stability for 5 but 3 State
