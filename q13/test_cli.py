import pytest

from greetlab.cli import main


def test_normal_name(capsys):
    import sys

    sys.argv = ["sdt-greet", "--name", "alice"]
    main()
    out = capsys.readouterr().out
    assert "Hello, alice!" in out


def test_blank_name_exits_nonzero():
    import sys

    sys.argv = ["sdt-greet", "--name", "   "]
    with pytest.raises(SystemExit) as exc_info:
        main()
    assert exc_info.value.code == 2
