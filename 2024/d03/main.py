from functools import reduce
from pathlib import Path
import re


def main():
    example_p1_result = process_file("./example-input.txt")
    example_p1_expected = 161
    example_p1_status = (
        "SUCCESS!"
        if example_p1_result == example_p1_expected
        else f"FAILED, expected {example_p1_expected}, but got {example_p1_result}"
    )
    print(f"""
          Part 1:
          Example:  {example_p1_status}
          Puzzle: {process_file('./puzzle-input.txt')}
          """)


def process_file(name: str):
    puzzle_input = Path(__file__).parent / name
    with open(puzzle_input, "rt") as f:
        return part1_process_lines(f.readlines())


def part1_process_lines(lines: list[str]) -> int:
    return sum(map(get_sum_of_products_for_line, lines))


def get_sum_of_products_for_line(line: str) -> int:
    def product_from_str(t: tuple[str, str]):
        return reduce(lambda a, b: a * b, map(int, t))

    pairs: list[tuple[str, str]] = re.findall(r"mul\((\d+),(\d+)\)", line)
    return sum(map(product_from_str, pairs))


if __name__ == "__main__":
    main()
