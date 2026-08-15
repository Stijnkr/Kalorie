import unittest
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))

from nevo_import import parse_nevo_csv


class NevoImportTest(unittest.TestCase):
    def test_parses_core_and_extra_nutrients(self):
        csv_path = Path(__file__).with_name("fixtures") / "nevo_sample.csv"
        items = parse_nevo_csv(csv_path)
        self.assertEqual(len(items), 1)
        item = items[0]
        self.assertEqual(item["nevoCode"], "01101")
        self.assertEqual(item["kcal"], 80)
        self.assertEqual(item["protein"], 2.0)
        self.assertEqual(item["fiber"], 1.8)
        self.assertAlmostEqual(item["salt"], 0.01)
        self.assertEqual(item["nutrients"]["VITC"], 12)
        self.assertEqual(item["kind"], "generic")
        self.assertEqual(item["qualityScore"], 100)

    def test_parses_official_pipe_delimited_nevo(self):
        csv_path = Path(__file__).with_name("fixtures") / "nevo_official_sample.csv"
        items = parse_nevo_csv(csv_path)
        self.assertEqual(len(items), 1)
        item = items[0]
        self.assertEqual(item["nevoCode"], "1")
        self.assertEqual(item["kcal"], 88)
        self.assertEqual(item["fiber"], 1.8)
        self.assertEqual(item["nutrients"]["VITC"], 12)
        self.assertEqual(item["nutrients"]["ENERC"], 371)
        self.assertNotIn("CHOLE", item["nutrients"])
        self.assertIn("aardappel", item["aliases"])
        self.assertIn("Potatoes raw", item["aliases"])


if __name__ == "__main__":
    unittest.main()
