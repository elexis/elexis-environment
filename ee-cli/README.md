# BCL

Derivation of SierraSoftworks' [Bash CLI](https://github.com/SierraSoftworks/bash-cli).

Bash CLI was borne of the need to provide a common entrypoint into a range of scripts
and tools for a project. Rather than port the scripts to something like Go or Python,
or merge them into a single bash script, we opted to build a framework which allows
and executable to be presented as a sub-command.

BCL is a modification of that.

## Installation

When installing

```sh
git clone git@github.com:sdsdkkk/bcl.git
cd bcl
./cli setup install

# Enable autocomplete for zsh
cat <<EOF >> ~/.zshrc
# BCL autocomplete
autoload -U +X compinit && compinit
autoload -U +X bashcompinit && bashcompinit
source ~/.bash_completion
EOF
```

When uninstalling.

```sh
./cli setup uninstall
```

## Example Usage

```sh
bcl init my-project
cd my-project
bcl create test-command
```

## Package Management
BCL has a built-in simple git-based package management capabilities to publish CLI tools using git
repositories. This is useful to have an internal tooling distribution system in our organization.

```
bcl package install
```

The package installation command will read a file named `BCLFile` from the directory it's run on.
Here's an example `BCLFile`.

```
git@github.com:sample-org/sample-release-repo.git
sample-package1-v1.0.0-release
sample-package2-v1.0.0-release
```

The command will read the `BCLFile`, take the first line as the source package distribution
repository and iterate the rest of the lines as the release branch name of the repository.

See [this repository](https://github.com/sdsdkkk/branch-test) to see how the packages are managed
using git branches. The packages will be put inside the `cli` subdirectory of the execution directory.

```
bcl package publish [package_name]
```

The command will read the `BUILD` file on the CLI tool project directory. The following is a sample
`BUILD` file.

```
sample-package1-v1.0.0-release
git@github.com:sample-org/sample-release-repo.git
```

The first line should contain the name of the distribution branch, the second line should contain
the git repository it's located in.

## Adding Commands
Bash CLI commands are just a stock-standard script with a filename that matches the command name.
These scripts are contained within your `app` folder, or within nested folders there if you want
to create a tree-based command structure.

BCL does practically the same thing as Bash CLI, only with a few adjustments.

For example, the script `app/test/hello` would be available through `bcl test hello`. Any arguments
passed after the command will be curried through to the script, making it trivial to pass values and
options around as needed.

The simplest way to add a command however, is to just run `bcl create [command name]`
and have it plop down the files for you to customize.

### Contextual Help
Bash CLI provides tools which enable your users to easily discover how to use your command line without
needing to read your docs (a travesty, we know). To make this possible, you'll want to add two extra
files for each command.

The first, `[command].usage` should define the arguments list that your command expects to receive,
something like `NAME [MIDDLE_NAMES...] SURNAME`. This file is entirely optional, leaving it out will
have Bash CLI present the command as if it didn't accept arguments.

The second, `[command].help` is used to describe the arguments that your command accepts, as well as
provide a bit of additional context around how it works, when you should use it etc.

In addition to providing help for commands, you may also provide it for directories to explain what
their sub-commands are intended to achieve. To do this, simply add a `.help` file to the directory.
