from collections.abc import Iterable
from functools import reduce
from pathlib import Path


CHAR_TYPE = str
LINE_TYPE = str
LINES_TYPE = Iterable[LINE_TYPE]


def process_file(file_path: Path) -> int:
    return reduce(sum_, map(combine_first_and_last_digits, open(file_path)))


def sum_(x, y):
    return x + y


def combine_first_and_last_digits(line: LINE_TYPE) -> int:
    return int(first_digit(line) + first_digit(line[::-1]))


def first_digit(line: LINE_TYPE) -> CHAR_TYPE:
    return next(filter(is_digit, line))


def is_digit(char: CHAR_TYPE) -> bool:
    return 48 <= ord(char) <= 57
