import unittest

from qmhes_counter.sequence import (
    TEST3_FINAL,
    TEST3_PATTERN,
    hmac_input,
    run_normative,
    score_test3,
)


class TestAppendixSequence(unittest.TestCase):
    def test_published_pattern(self):
        pattern, final = score_test3()
        self.assertEqual(pattern, TEST3_PATTERN)
        self.assertEqual(final, TEST3_FINAL)

    def test_normative_abort_on_first_gap(self):
        result = run_normative()
        self.assertEqual(result["state"], "ABORTED")
        self.assertEqual(result["fail_index"], 4)
        self.assertEqual(result["fail_seq"], 5)
        self.assertEqual(result["expected"], 4)
        self.assertEqual(result["accepted"], [0, 1, 2, 3])

    def test_hmac_input_layout(self):
        buf = hmac_input(2, 42, bytes([192, 168, 1, 1]))
        self.assertEqual(len(buf), 1 + 4 + 2 + 4)
        self.assertEqual(buf[0], 2)
        self.assertEqual(buf[1:5], (42).to_bytes(4, "big"))
        self.assertEqual(buf[5:7], (4).to_bytes(2, "big"))
        self.assertEqual(buf[7:], bytes([192, 168, 1, 1]))


if __name__ == "__main__":
    unittest.main()
