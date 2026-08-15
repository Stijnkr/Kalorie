import unittest
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))

from normalize import match_key, normalize_barcode, normalize_match, normalize_search


class NormalizeTest(unittest.TestCase):
    def test_unaccent_and_punct(self):
        self.assertEqual(normalize_search("Crème brûlée!"), "creme brulee")

    def test_match_strips_size_and_stopwords(self):
        self.assertEqual(
            match_key("Campina", "Halfvolle melk 1L"),
            "campina|halfvolle melk",
        )

    def test_barcode_upc_to_ean(self):
        self.assertEqual(normalize_barcode("123456789012"), "0123456789012")

    def test_barcode_rejects_short(self):
        self.assertIsNone(normalize_barcode("123"))


if __name__ == "__main__":
    unittest.main()
