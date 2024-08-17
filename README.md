# .dotfiles

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
