# dotenv.nu

This module exposes commands to interact with `.env` files. In addition to
parsing them, this module can load them into your environment (automatically or
manually).

```nushell
use dotenv.nu
dotenv load
```

## Commands

**Parsing:**

```nushell
dotenv parse [file] # Parse a dotenv file
dotenv parse tree [file] # Recursively parse dotenv files
dotenv collect # Collect parsed dotenv files into a single record

# You can manually load all variables defined in a dotenv file with:
dotenv parse | dotenv collect | load-env
```

**Loading:**

```nushell
dotenv load [file] # Load a dotenv file into $env
dotenv load tree [file] # Recursively load dotenv files into $env

dotenv autoenv enable # Automatically load dotenv files into $env
dotenv autoenv disable # Disable autoenv
```

## Installation

Clone this repository, then import it with `use dotenv.nu`:

```nushell
git clone --depth=1 https://github.com/TehPers/dotenv.nu
use dotenv.nu
```

A good place to import this repository is into a library directory. Check the
value of `$NU_LIB_DIRS` to see which directories are library directories. If
cloned into a library directory, you can `use dotenv.nu` from any directory.

If you don't want to run `use dotenv.nu` in every session before using the
`dotenv` commands, then add `use dotenv.nu` to your config. Run `config nu` to
edit the config.

You can upgrade or downgrade at any time from within the cloned repository using
standard `git` commands:

```nushell
cd dotenv.nu
git pull
```

Uninstall by deleting the cloned repository. If you modified your config to load
this module, then revert the relevant changes.

## License

See [`LICENSE`](./LICENSE) for the full license.
