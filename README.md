# Dotfiles

This repo contains the macOS setup that I like to make my machine feel cozy.

> **Note:** May _you_, the curious wanderer who ended up here, use it for inspiration. But be warned that it comes at your very own responsibility.

## Configure Ghostty (zsh)

Ghostty is configured with Fish as the default shell, using a custom Solarized Dark-inspired prompt.

1. Install Ghostty and syntax tools:

```bash
brew install ghostty zsh-syntax-highlighting zsh-autosuggestions
```

2. Symlink the Ghostty config:

```bash
mkdir -p ~/.config/ghostty
ln -s ~/.dotfiles/ghostty/config ~/.config/ghostty/config
```

> **IMP:** In `ghostty/config`, uncomment the section corresponding to `zsh`.

5. Remove the 'Last login ...' message:

```bash
touch ~/.hushlogin
```

<p align="center">
  <img width="854" height="532" alt="image" src="https://github.com/user-attachments/assets/7b5b9808-4876-49ce-8854-0d718160bc40" />
</p>

## Configure Terminal (bash)

1. Clone this repo in `~/` in a new machine
2. Add `~/.bashrc` with the following contents:

```bash
[ -n "$PS1" ] && source ~/.dotfiles/.bash_profile;
```

3. Add `~/.bash_profile` with the contents:

```bash
source ~/.dotfiles/.bash_profile;
```

4. In `Terminal > Settings` in the default profile:
    - Adjust the font to `SF Mono Regular 14`
    - Adjust the background color to `black` with `90%` opacity and `50%` blur.
    - Adjust the font color for `Text` and `Bold text` to white, and selection to `#755337`.
    - Adjust the window to `80 columns` and `30 rows`.
    - Adjust the 'ANSI blue' color to `#FFB500` (orange).

<p align="center">
  <img width="744" height="516" alt="image" src="https://github.com/user-attachments/assets/c6b5e3a7-e1c5-45ce-a04d-1d4e69ffeec5" />
</p>

## Configure VSCode

The settings file has to be symlinked so that VSCode uses the one in this repo:

- VSCode settings file: `~/Library/Application Support/Code/User/settings.json`

```bash
ln -s ~/.dotfiles/vscode/settings.json ~/Library/Application\ Support/Code/User/
ln -s ~/.dotfiles/vscode/tasks.json ~/Library/Application\ Support/Code/User/
ln -s ~/.dotfiles/vscode/keybindings.json ~/Library/Application\ Support/Code/User/
```

<p align="center">
  <img width="830" height="445" alt="image" src="https://github.com/user-attachments/assets/d6df8740-be61-409b-b7ff-3cb4b7d04a39" />
</p>

Requirements:

- Railgun theme

## Configure vim

Link config to the one in this repo:

```
ln -s ~/.dotfiles/.vimrc ~/.vimrc
```

<p align="center">
  <img width="703" height="404" alt="image" src="https://github.com/user-attachments/assets/c86c66c1-e4b9-4d6b-a788-93367dcb1c2e" />
</p>

## Configure jujutsu

Link config to the one in this repo:

```
ln -s ~/.dotfiles/jj/config.toml ~/.config/jj/config.toml
```

## Configure zed

Symlink config files:

```
ln -s ~/.dotfiles/zed/tasks.json ~/.config/zed/tasks.json
ln -s ~/.dotfiles/zed/settings.json ~/.config/zed/settings.json
ln -s ~/.dotfiles/zed/keymap.json ~/.config/zed/keymap.json
ln -s ~/.dotfiles/zed/debug.json ~/.config/zed/debug.json
ln -s ~/.dotfiles/zed/copy-with-location.sh ~/.config/zed/copy-with-location.sh
```

## Other configuration

1. In `~/` add a `.gitconfig` with the content:

```
[include]
  path = ~/.dotfiles/.my_gitconfig
```

5. Install the Git Autocompletion executable with:

```
curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash -o ~/.git-completion.bash
```

6. Run `.config_macos.sh` to config macOS settings.
7. Other settings:
    - Trackpad speed: `8/10`

**IMP: Always push changes made locally to keep them in sync here!**
