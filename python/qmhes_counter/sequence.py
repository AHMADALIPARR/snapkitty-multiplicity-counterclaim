"""Runnable reading of QAHES v1.0.1 sequence validation.

Source of the rule: Ryan O. Van Gelder, QMHES Mathematical Appendix,
Multiplicity Foundation, 2026, §4.3.

Two readings are both implemented:

* score_test3 continues after a reject so the published pattern can be
  compared. That is how the appendix scores Test 3.
* run_normative aborts on the first mismatch. That is the v1.0.1 rule.
"""

from __future__ import annotations

TEST3_INPUT = (0, 1, 2, 3, 5, 4, 6, 5, 6)
TEST3_PATTERN = "AAAARARAA"
TEST3_FINAL = 7


def score_test3(sequence: tuple[int, ...] = TEST3_INPUT) -> tuple[str, int]:
    """Appendix scoring: record A/R and keep going. Final counter is 7."""
    expected = 0
    pattern: list[str] = []
    for seq in sequence:
        if seq != expected:
            pattern.append("R")
        else:
            pattern.append("A")
            expected += 1
    return "".join(pattern), expected


def run_normative(sequence: tuple[int, ...] = TEST3_INPUT) -> dict:
    """v1.0.1 rule: first mismatch aborts. Later frames are not accepted."""
    expected = 0
    accepted: list[int] = []
    for index, seq in enumerate(sequence):
        if seq != expected:
            return {
                "state": "ABORTED",
                "fail_index": index,
                "fail_seq": seq,
                "expected": expected,
                "accepted": accepted,
            }
        accepted.append(seq)
        expected += 1
    return {
        "state": "AUTHENTICATED",
        "fail_index": None,
        "fail_seq": None,
        "expected": expected,
        "accepted": accepted,
    }


def hmac_input(msg_type: int, seq: int, payload: bytes) -> bytes:
    """CLASSIC MESSAGE HMAC input, appendix §4.1 equation (25)."""
    if not 0 <= msg_type <= 255:
        raise ValueError("msg_type")
    if not 0 <= seq <= 0xFFFFFFFF:
        raise ValueError("seq")
    plen = len(payload)
    if plen > 0xFFFF:
        raise ValueError("plen")
    return (
        bytes([msg_type])
        + seq.to_bytes(4, "big")
        + plen.to_bytes(2, "big")
        + payload
    )
