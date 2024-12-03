from functools import reduce
from pathlib import Path
import re


def main():
    example_p1_result = process_file_p1("./example-input.txt")
    example_p1_expected = 161
    example_p1_status = (
        "SUCCESS!"
        if example_p1_result == example_p1_expected
        else f"FAILED, expected {example_p1_expected}, but got {example_p1_result}"
    )

    example_p2_result = process_file_p2("./example-input-p2.txt")
    example_p2_expected = 48
    example_p2_status = (
        "SUCCESS!"
        if example_p2_result == example_p2_expected
        else f"FAILED, expected {example_p2_expected}, but got {example_p2_result}"
    )
    print(f"""
          Part 1:
          Example:  {example_p1_status}
          Puzzle: {process_file_p1('./puzzle-input.txt')}

          Part 2:
          Example:  {example_p2_status}
          Puzzle: {process_file_p2('./puzzle-input.txt')}
          """)


def process_file_p1(name: str):
    puzzle_input = Path(__file__).parent / name
    with open(puzzle_input, "rt") as f:
        return part1_process_lines(f.readlines())


def process_file_p2(name: str):
    puzzle_input = Path(__file__).parent / name
    with open(puzzle_input, "rt") as f:
        return part2_process_content(f.read())


def part2_process_content(content: str) -> int:
    pair_matches = re.finditer(r"mul\((\d+),(\d+)\)", content)
    do_pattern_rev = re.compile(r"\)\(od")
    dont_pattern_rev = re.compile(r"\)\(t'nod")

    def is_in_enabled_range(m: re.Match) -> bool:
        idx = m.start()
        # Search backwards from the current index
        do_match = do_pattern_rev.search(content[idx::-1])
        dont_match = dont_pattern_rev.search(content[idx::-1])

        if dont_match is None:  # No don't found, we are at the first enabled range
            return True
        if do_match is None:  # Don't found, but no do
            return False
        return (
            do_match.start() < dont_match.start()
        )  # Is do closer than don't in the preceding content?

    filtered_pair_matches = filter(is_in_enabled_range, pair_matches)
    return sum(map(product_from_match, filtered_pair_matches))


def product_from_match(m: re.Match) -> int:
    return int(m.group(1)) * int(m.group(2))


def part1_process_lines(lines: list[str]) -> int:
    return sum(map(get_sum_of_products_for_line, lines))


def get_sum_of_products_for_line(line: str) -> int:
    pairs = get_mul_pairs(line)
    return get_sum_of_products(pairs)


def get_mul_pairs(s: str) -> list[tuple[str, str]]:
    return re.findall(r"mul\((\d+),(\d+)\)", s)


def get_sum_of_products(ls_of_str_tup: list[tuple[str, str]]) -> int:
    def product_from_str(t: tuple[str, str]):
        return reduce(lambda a, b: a * b, map(int, t))

    return sum(map(product_from_str, ls_of_str_tup))


if __name__ == "__main__":
    main()
