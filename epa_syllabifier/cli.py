"""
Interactive command-line interface for manual syllabification checks.
"""

import sys
from typing import TextIO

from .syllabicator import syllabify

PROMPT = "epa> "
WELCOME = "Escribe una palabra EPA por línea. Pulsa Intro sin texto para salir."


def run(source: TextIO, target: TextIO, *, interactive: bool = False) -> None:
    """Read one word per line and print its syllables separated by hyphens."""
    if interactive:
        target.write(f"{WELCOME}\n")

    while True:
        if interactive:
            target.write(PROMPT)
            target.flush()

        line = source.readline()
        if line == "":
            if interactive:
                target.write("\n")
            return

        word = line.strip()
        if not word:
            return

        try:
            result = "-".join(syllabify(word))
        except ValueError as error:
            target.write(f"Error: {error}\n")
        else:
            target.write(f"{result}\n")


def main() -> None:
    """Run the command-line interface using the standard streams."""
    run(sys.stdin, sys.stdout, interactive=sys.stdin.isatty())
