import sys
import unittest
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))

from nevo_import import apply_portions_and_aliases, natural_name
from portions import load_portion_rules, load_portions, resolve_portion


class PortionRulesTest(unittest.TestCase):
    def setUp(self):
        self.rules = load_portion_rules()

    def test_every_group_has_a_fallback(self):
        groups = {rule.category for rule in self.rules}
        without = [
            group
            for group in groups
            if not any(r.category == group and r.pattern is None for r in self.rules)
        ]
        self.assertEqual(without, [], "groep zonder fallback-regel")

    def test_first_matching_rule_wins(self):
        cases = [
            ("Beschuit naturel", "Brood", "1 stuk", 10),
            ("Tarwebrood volkoren gem v fijn en grof", "Brood", "1 snee", 35),
            ("Ei kippen- gekookt gem", "Eieren", "1 ei", 50),
            ("Bier pils", "Alcoholische dranken", "1 glas", 250),
            ("Whisky", "Alcoholische dranken", "1 glaasje", 35),
            ("Koffie bereid", "Niet-alcoholische dranken", "1 kop", 125),
            ("Kaas 30+ jong", "Kaas", "1 plak", 20),
            ("Melk halfvolle", "Melk en melkproducten", "1 glas", 200),
            ("Yoghurt magere", "Melk en melkproducten", "1 schaaltje", 150),
            ("Omelet/roerei", "Samengestelde gerechten", "1 omelet", 120),
        ]
        for name, category, label, grams in cases:
            with self.subTest(name=name):
                portion = resolve_portion(name, category, self.rules)
                self.assertIsNotNone(portion)
                self.assertEqual(portion["label"], label)
                self.assertEqual(portion["grams"], grams)

    def test_stroop_is_not_read_as_suiker(self):
        sweet = "Suiker, snoep, zoet beleg en zoete sauzen"
        self.assertEqual(resolve_portion("Stroop suiker-", sweet, self.rules)["grams"], 15)
        self.assertEqual(resolve_portion("Suiker kristal-", sweet, self.rules)["grams"], 4)

    def test_rijst_is_not_read_as_ijs(self):
        sweet = "Suiker, snoep, zoet beleg en zoete sauzen"
        self.assertEqual(resolve_portion("Stroop rijstmout-", sweet, self.rules)["label"], "1 eetlepel")
        self.assertEqual(resolve_portion("IJs water-", sweet, self.rules)["label"], "1 bolletje")

    def test_unknown_category_has_no_portion(self):
        self.assertIsNone(resolve_portion("Iets nieuws", "Onbekende groep", self.rules))

    def test_snapshot_omelet_is_120g(self):
        from pathlib import Path
        import json

        snapshot = Path(__file__).resolve().parents[3] / "assets" / "food" / "nevo_snapshot.min.json"
        if not snapshot.exists():
            self.skipTest("geen snapshot in deze checkout")
        data = json.loads(snapshot.read_text())
        omelet = next(i for i in data["items"] if i.get("nevoCode") == "5321")
        self.assertEqual(omelet["servingLabel"], "1 omelet")
        self.assertEqual(omelet["servingG"], 120)


class NaturalNameTest(unittest.TestCase):
    def test_moves_the_dash_suffix_to_the_front(self):
        self.assertEqual(natural_name("Melk karne-"), "karnemelk")
        self.assertEqual(natural_name("Ketchup tomaten-"), "tomatenketchup")
        self.assertEqual(natural_name("Rijst zilvervlies- gekookt"), "zilvervliesrijst gekookt")

    def test_returns_none_without_a_dash_suffix(self):
        self.assertIsNone(natural_name("Aardappelen rauw"))
        self.assertIsNone(natural_name("Hummus"))


class ApplyOverlayTest(unittest.TestCase):
    def test_exact_portion_beats_the_group_rule(self):
        code = next(iter(load_portions()))
        items = [
            {"nevoCode": code, "name": "Pasta witte rauw", "category": "Graanproducten en meelsoorten"},
            {"nevoCode": "999999", "name": "Pasta witte rauw", "category": "Graanproducten en meelsoorten"},
        ]
        apply_portions_and_aliases(items)
        override, by_rule = items
        self.assertEqual(override["servingG"], load_portions()[code]["grams"])
        self.assertEqual(by_rule["servingLabel"], "1 opscheplepel")


if __name__ == "__main__":
    unittest.main()
