# dotfiles

![Screenshot of the shell prompt](https://media.giphy.com/media/l2QZR9exGEB6CRzpK/giphy.gif)

## Installation

```bash
curl -#L https://github.com/0xadada/dotfiles/tarball/master | tar -xzv
cd 0xadada-dotfiles-*
./bootstrap.sh
```

Bootstrap will install the dotfiles, and install core utilities:

* Bash shell, latest version
* Homebrew, [cask and its packages](https://github.com/0xadada/dotfiles/blob/master/Brewfile)
* `asdf` (with latest Stable Elixir, Erlang, NodeJS, Python 2 & 3, Ruby)

To update, `cd` into your local `dotfiles` repository and then:

```bash
./bootstrap.sh
```

## macOS hacker defaults

When setting up a new Macbook, you may want to set some sensible macOS defaults:

```bash
./.macos
```

## Add custom commands without creating a new fork

If `~/.bash_custom` exists, it will be sourced along with the other files. You
can use this to add a few custom commands without the need to fork this entire
repository, or to add commands you don’t want to commit to a public repository.

## Author

| [![twitter/0xADADA](https://github.com/0xadada.png)](https://twitter.com/0xadada "Follow @0xADADA on Twitter") |
|---|
| [0xADADA](https://0xADADA.pub/) |

## Thanks to…

* [Mathias Bynens](http://twitter.com/mathias) and his [dotfiles repository](https://github.com/mathiasbynens/dotfiles)
* @ptb and [his _OS X Lion Setup_ repository](https://github.com/ptb/Mac-OS-X-Lion-Setup)
* [Ben Alman](http://benalman.com/) and his [dotfiles repository](https://github.com/cowboy/dotfiles)
* [Chris Gerke](http://www.randomsquared.com/) and his [tutorial on creating an OS X SOE master image](http://chris-gerke.blogspot.com/2012/04/mac-osx-soe-master-image-day-7.html) + [_Insta_ repository](https://github.com/cgerke/Insta)
* [Cătălin Mariș](https://github.com/alrra) and his [dotfiles repository](https://github.com/alrra/dotfiles)
* [Gianni Chiappetta](http://gf3.ca/) for sharing his [amazing collection of dotfiles](https://github.com/gf3/dotfiles)
* [Jan Moesen](http://jan.moesen.nu/) and his [ancient `.bash_profile`](https://gist.github.com/1156154) + [shiny _tilde_ repository](https://github.com/janmoesen/tilde)
* [Lauri ‘Lri’ Ranta](http://lri.me/) for sharing [loads of hidden preferences](http://osxnotes.net/defaults.html)
* [Matijs Brinkhuis](http://hotfusion.nl/) and his [dotfiles repository](https://github.com/matijs/dotfiles)
* [Nicolas Gallagher](http://nicolasgallagher.com/) and his [dotfiles repository](https://github.com/necolas/dotfiles)
* [Sindre Sorhus](http://sindresorhus.com/)
* [Tom Ryder](http://blog.sanctum.geek.nz/) and his [dotfiles repository](https://github.com/tejr/dotfiles)
* [Kevin Suttle](http://kevinsuttle.com/) and his [dotfiles repository](https://github.com/kevinSuttle/dotfiles) and [OSXDefaults project](https://github.com/kevinSuttle/OSXDefaults), which aims to provide better documentation for [`~/.osx`](https://mths.be/osx)
* [Haralan Dobrev](http://hkdobrev.com/)
* anyone who [contributed a patch](https://github.com/mathiasbynens/dotfiles/contributors) or [made a helpful suggestion](https://github.com/mathiasbynens/dotfiles/issues)
