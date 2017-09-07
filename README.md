Configuration files, which I share among work stations.

# Generic features

* Deployment to home directory with GNU [stow](https://www.gnu.org/software/stow/)
* Possibility to work in-place without deployment
* Fast file selection with FZF
* Grepper
* Zsh plugins with [zplug](https://github.com/zplug/zplug)

# Features for C++

* YouCompleteMe and clang\_complete working out of the box
* Tynier custom deployment of YCM (see `ycm-update.sh`)
* `.cproj` system to facilitate C++ project management for vim-rtags and YCM
  (see `cproj-init` and `cproj-scan`)
* vim-rtags for code navigation
* ConqueGDB with QtCreator-like keybindings

# Installation

First clone the repository to a working directory:

```
  git clone https://github.com/sakhnik/dotfiles --depth 1
  cd dotfiles/
```

Then you need to configure the distribution: download zplug plugins,
download vim plugins, install and build YouCompleteMe. For this, execute:

```
  ./config.sh
```

To install to the home directory (optional), execute the script
[deploy.sh](https://github.com/sakhnik/dotfiles/blob/master/deploy.sh):

```
  ./deploy.sh
```

It will create symlinks from home to the working directory.

To launch zsh for use in-place,

```
   ./zsh.sh
```

# Showcase

## Writing and navigating C++ code

[![asciicast](https://asciinema.org/a/qV8uazTba3VwTIw2791gTuL95.png)](https://asciinema.org/a/qV8uazTba3VwTIw2791gTuL95?autoplay=1)
