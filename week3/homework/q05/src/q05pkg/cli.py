import click


@click.command()
@click.argument("name", default="World")
def main(name: str) -> None:
    """向 NAME 问好（q05 发布演示包）。"""
    click.echo(f"Hello, {name}!")


if __name__ == "__main__":
    main()