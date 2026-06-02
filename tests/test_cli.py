"""
Tests for the interactive command-line interface.
"""

import sys
from io import StringIO

from epa_syllabifier.cli import PROMPT, WELCOME, main, run


def test_run_syllabifies_each_input_line():
    source = StringIO("andalûh\nguau\n\n")
    target = StringIO()

    run(source, target)

    assert target.getvalue() == "an·da·lûh\nguau\n"


def test_run_reports_multiple_words_and_continues():
    source = StringIO("hola mundo\ndía\n\n")
    target = StringIO()

    run(source, target)

    assert target.getvalue() == (
        "Error: word must be a single unit without whitespace\n" "dí·a\n"
    )


def test_run_interactive_session_exits_cleanly_on_eof():
    source = StringIO("tío\n")
    target = StringIO()

    run(source, target, interactive=True)

    assert target.getvalue() == f"{WELCOME}\n{PROMPT}tí·o\n{PROMPT}\n"


def test_main_uses_standard_streams(monkeypatch):
    source = StringIO("causa\n\n")
    target = StringIO()
    monkeypatch.setattr(sys, "stdin", source)
    monkeypatch.setattr(sys, "stdout", target)

    main()

    assert target.getvalue() == "cau·sa\n"
