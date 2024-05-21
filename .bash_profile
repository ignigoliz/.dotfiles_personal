# GLOBAL BASH CONFIGURATIONS:

# -------------------------------------------- Basic Info ----------------------------------------------------

# Regarding .bashrc:
# when a "bash" command is run, .bashrc gets executed, and then this bash_profile file is executed.
# check '~/<DOTFILES_LOCATION>/.bash_prompt' for the concrete bash style configurations
# check '~/<DOTFILES_LOCATION>/.aliases' for the aliases set up

# ------------------------------------------ Other .dotfiles --------------------------------------------------

# Load the shell dotfiles, and then some:
# * ~/.path can be used to extend `$PATH`.
# * ~/.extra can be used for other settings you don’t want to commit.
for file in ~/.dotfiles_personal/.{path,bash_prompt_style,exports,aliases,functions,extra,env_variables}; do
	[ -r "$file" ] && [ -f "$file" ] && source "$file"; # man test
done;
unset file;

# -------------------------------------------- PATH Setup ----------------------------------------------------

export PATH="$HOME/bin:$PATH";
export PATH="/opt/homebrew/bin:$PATH";

# ----------------------------------------------- GIT --------------------------------------------------------

if [ -f ~/.git-completion.bash ]; then
  . ~/.git-completion.bash
fi

# ------------------------------------------ Extra Settings ---------------------------------------------------

# Case-insensitive name expansion (globbing) (used in pathname expansion)
shopt -s nocaseglob;
# Append to the Bash history file, rather than overwriting it
shopt -s histappend;
# Autocorrect typos in path names when using `cd`
shopt -s cdspell;

# Enable some Bash 4 features when possible:
# * `autocd`, e.g. `**/qux` will enter `./foo/bar/baz/qux`
# * Recursive globbing, e.g. `echo **/*.txt`
for option in autocd globstar; do
	shopt -s "$option" 2> /dev/null;
done;

# Add tab completion for many Bash commands
if which brew &> /dev/null && [ -r "$(brew --prefix)/etc/profile.d/bash_completion.sh" ]; then
        source "$(brew --prefix)/etc/profile.d/bash_completion.sh";
elif [ -f /etc/bash_completion ]; then
        source /etc/bash_completion;
fi;
        
# Enables git autocompletion. Install with brew install git bash-completion
[ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion || {
    # if not found in /usr/local/etc, try the brew --prefix location
    [ -f "$(brew --prefix)/etc/bash_completion.d/git-completion.bash" ] && \
        . $(brew --prefix)/etc/bash_completion.d/git-completion.bash
}


# Enable tab completion for `g` by marking it as an alias for `git`
if type _git &> /dev/null; then
        complete -o default -o nospace -F _git g;
fi;

# Add tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards
[ -e "$HOME/.ssh/config" ] && complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2- | tr ' ' '\n')" scp sftp ssh;

# Add tab completion for `defaults read|write NSGlobalDomain`
# You could just use `-g` instead, but I like being explicit
complete -W "NSGlobalDomain" defaults;

# Add `killall` tab completion for common apps
complete -o "nospace" -W "Contacts Calendar Dock Finder Mail Safari iTunes SystemUIServer Terminal Twitter" killall;
        
export BASH_SILENCE_DEPRECATION_WARNING=1
