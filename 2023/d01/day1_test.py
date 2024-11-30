from pathlib import Path

import day1


def test_part1():
    input_file = Path(__file__).parent / "test_input.txt"
    res = day1.process_file(input_file)
    assert res == 12 + 38 + 15 + 77
