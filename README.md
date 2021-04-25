# Snippets

Snippets is a simple code snippets manager.

- **Simple**: It's for code snippets. I'm not gonna turn this into a social media platform.
- **Privacy-focused**: You don't have to give your email to make an account.
- **Programmer-oriented**: You ever get annoyed of having to click "raw" to view code in a format most familiar to you? Yeah, me too.

## Getting Started

Note: This was only tested for Linux. macOS and Windows are unknown territories.

### Prerequisites
Clone the repository.

```sh
git clone git@github.com:mainhs/snippets.git

cd snippets/
```

Install the `nix` package manager.

```sh
curl -L https://nixos.org/nix/install | sh
```

At the project root directory, activate the nix shell environment. This will handle all* the dependencies needed for the project. See `shell.nix` for the dependency list.

```sh
nix-shell
```

**THIS IS VERY IMPORTANT:** Ensure that for anything that requires dependencies from `nix`, **run it in the environment**. This includes running your code editor from within the environment.

```sh
nix-shell

# In the activated nix environment
## Runs VSCode with the nix env
code .
```

You can also install the dependencies needed in your own preferred method. Check [shell.nix](shell.nix) for the list of dependencies.

### Project setup

Setup the project, initialize database, and run the server.

```sh
# ecto.setup should handle all the Elixir & npm
# dependencies needed for the project. It also
# creates, migrates, and seeds the database.
mix ecto.setup

# Runs the server in dev mode
mix phx.server 
```

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## License

[Snippets](https://github.com/mainhs/snippets) is licensed under the [Elastic License 2.0](LICENSE). Please read it before you decide to intend to do anything with the source code.