# Source of truth

`supplied-counter-source.md` is the markdown this repository was built from.

Authorship split: the embedded QMHES appendix is Ty Van Gelder's (published byline Ryan O. Van Gelder, Multiplicity Foundation). The counter-models, axioms, ADRs, and MATLAB are our successor system.

What was extracted, without changing the mathematics:

| Source block | File |
| --- | --- |
| First Alloy module | `models/alloy/qmhes_counter.als` |
| Second Alloy module (`protocol_stability`) | `models/alloy/qmhes_protocol_stability.als` |
| First Lean sketch | `models/lean/MultiplicityInvariant.lean` |
| Second Lean sketch | `models/lean/ConvergenceFailure.lean` |
| ADR 001 MATLAB | `matlab/adr001/execute_qmhes_framework.m` |
| ADR 002 MATLAB | `matlab/adr002/execute_holographic_pq_framework.m` |
| ADR 003 MATLAB | `matlab/adr003/execute_entropy_drain_framework.m` |
| Roadmap inversion MATLAB | `matlab/roadmap/execute_qmhes_production_inversion.m` |
| Ten instability axioms | `docs/COUNTER-PAPER.md` §5, verbatim force table |
| QMHES appendix text embedded in the markdown | quoted in `docs/ORIGINAL-CLAIMS.md`; full supplied file kept here |

Span markers of the form `[span_n](start_span)` were editorial noise in the source and were not copied into the models.

The original appendix author is Ty Van Gelder / Multiplicity Foundation. This directory does not reassign that authorship. The successor files are ours.
