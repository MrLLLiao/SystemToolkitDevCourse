import typer

app = typer.Typer()


@app.command()
def greet(name: str = typer.Argument("World")):
    """向 NAME 问好。"""
    typer.echo(f"Hello, {name}!")


def main():
    app()


if __name__ == "__main__":
    main()