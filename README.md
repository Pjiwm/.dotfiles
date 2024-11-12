# .dotfiles
my dotfiles for Unix like machines. (Mac/linux)

Has been used on Pop!_OS 22.04 and macOS Sequoia.

## Requirements

### Stow

```
apt install stow
```

## Installation

Clone the repository
```
$ git clone git@github.com:Pjiwm/.dotfiles.git
$ cd .dotfiles
```

Install used software if needed (nvim, tmux etc.)
```
$ chmod +x install.sh
$ ./setup.sh
```

Use GNU stow to create symlinks

```
$ stow .
```

## Terminal
I use Alacritty as my terminal.
Config files are provided, but installation has to be done manually.

## Font
Nerd font used is [JetBrains Mono](https://www.jetbrains.com/lp/mono/)

