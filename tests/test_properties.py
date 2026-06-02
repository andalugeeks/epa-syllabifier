"""
Property tests for the syllabifier invariants.
"""

from itertools import product

import pytest

from epa_syllabifier import syllabify
from epa_syllabifier.syllabicator import FULL_SET

MAX_EXHAUSTIVE_WORD_LENGTH = 4


@pytest.mark.properties
def test_valid_alphabet_combinations_round_trip_without_empty_syllables():
    """Check short EPA character combinations exhaustively."""
    alphabet = sorted(FULL_SET)

    for length in range(1, MAX_EXHAUSTIVE_WORD_LENGTH + 1):
        for letters in product(alphabet, repeat=length):
            word = "".join(letters)
            syllables = syllabify(word)

            assert "".join(syllables) == word
            assert all(syllables)


@pytest.mark.properties
def test_alphabet_characters_are_case_insensitive():
    """Check that every EPA alphabet character accepts uppercase input."""
    for character in FULL_SET:
        assert "".join(syllabify(character.upper())) == character
