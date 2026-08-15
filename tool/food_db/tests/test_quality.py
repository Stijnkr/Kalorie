import unittest
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))

from quality import QualityInput, score


class QualityTest(unittest.TestCase):
    def test_complete_nl_branded_passes(self):
        result = score(
            QualityInput(
                name="Halfvolle melk",
                brand="Campina",
                kcal=46,
                protein=3.4,
                carbs=4.6,
                fat=1.5,
                fiber=0,
                sugars=4.6,
                salt=0.1,
                has_dutch_name=True,
                country_nl=True,
                has_serving=True,
            )
        )
        self.assertFalse(result.reject)
        self.assertGreaterEqual(result.score, 70)

    def test_missing_macros_rejected(self):
        result = score(QualityInput(name="Melk", kcal=46))
        self.assertTrue(result.reject)

    def test_atwater_mismatch_still_can_pass_with_other_points(self):
        result = score(
            QualityInput(
                name="Something",
                brand="AH",
                kcal=500,
                protein=1,
                carbs=1,
                fat=1,
                has_dutch_name=True,
                country_nl=True,
            )
        )
        self.assertIn("atwater_off", result.reasons)

    def test_generic_name_penalty(self):
        result = score(
            QualityInput(
                name="Melk",
                kcal=46,
                protein=3.4,
                carbs=4.6,
                fat=1.5,
                country_nl=True,
            )
        )
        self.assertIn("generic_name", result.reasons)


if __name__ == "__main__":
    unittest.main()
