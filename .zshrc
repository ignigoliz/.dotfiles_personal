# ----------------------------------- Locale -----------------------------------
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8

# ------------------------------- PATH / toolchains -----------------------------
export PATH="/opt/homebrew/bin:$PATH"
export VIRTUAL_ENV_DISABLE_PROMPT=1

# --------------------------- Aliases & personal files --------------------------
# These files are plain `export`/`alias` definitions, valid in zsh too.
for file in ~/.dotfiles_personal/.{env_variables,aliases}; do
    [ -r "$file" ] && [ -f "$file" ] && source "$file"
done
[ -r ~/.aliases ] && [ -f ~/.aliases ] && source ~/.aliases

# ------------------------------- Video helpers ---------------------------------
bitrate() {
  if [ -z "${1:-}" ]; then echo "usage: bitrate <file>" >&2; return 1; fi
  ffprobe -v error -show_entries format=duration,size -of csv=p=0 "$1" \
    | awk -F, '{printf "%.0f kb/s\n", (8*$2)/$1/1000}'
}
videores() {
  if [ -z "${1:-}" ]; then echo "usage: videores <file>" >&2; return 1; fi
  ffprobe -v error -select_streams v:0 -show_entries stream=width,height -of csv=p=0 "$1" \
    | awk -F, '{print $1 "x" $2}'
}
videofps() {
  if [ -z "${1:-}" ]; then echo "usage: videofps <file>" >&2; return 1; fi
  ffprobe -v error -select_streams v:0 -show_entries stream=avg_frame_rate -of csv=p=0 "$1" \
    | awk -F/ 'NF==2 && $2!=0 {printf "%.3f fps\n", $1/$2; next} {print $0}'
}
videoframes() {
  if [ -z "${1:-}" ]; then echo "usage: videoframes <file>" >&2; return 1; fi
  ffprobe -v error -select_streams v:0 -count_frames \
    -show_entries stream=nb_read_frames -of csv=p=0 "$1"
}
videoinfo() {
  if [ -z "${1:-}" ]; then echo "usage: videoinfo <file>" >&2; return 1; fi
  local f="$1"
  printf "resolution: %s\n" "$(videores "$f")"
  printf "fps:        %s\n" "$(videofps "$f")"
  printf "bitrate:    %s\n" "$(bitrate "$f")"
  printf "frames:     %s\n" "$(videoframes "$f")"
}

# ---------------------------------- Prompt -------------------------------------
[ -r ~/.dotfiles/.zsh_prompt_style ] && source ~/.dotfiles/.zsh_prompt_style

# ----------------------------------- History -----------------------------------
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt APPEND_HISTORY INC_APPEND_HISTORY SHARE_HISTORY
setopt HIST_IGNORE_DUPS HIST_IGNORE_SPACE HIST_REDUCE_BLANKS

# --------------------------------- Shell options -------------------------------
setopt AUTO_CD            # `dir` ⇒ `cd dir`   (bash autocd)
setopt NO_CASE_GLOB       # case-insensitive globbing (bash nocaseglob)
setopt EXTENDED_GLOB
unsetopt BEEP

# ------------------------- Command timer (fish-like) ---------------------------
# Report how long a command took when it runs longer than this many seconds.
zmodload zsh/datetime
autoload -Uz add-zsh-hook
CMD_TIMER_THRESHOLD=5

# Shown right-aligned in RPROMPT; TRANSIENT_RPROMPT clears it once the next
# command is accepted (like fish), keeping scrollback clean.
setopt TRANSIENT_RPROMPT

__cmd_timer_preexec() { __cmd_timer_start=$EPOCHREALTIME }
__cmd_timer_precmd() {
    RPROMPT=''
    [[ -z "$__cmd_timer_start" ]] && return
    local elapsed=$(( EPOCHREALTIME - __cmd_timer_start ))
    unset __cmd_timer_start
    (( elapsed < CMD_TIMER_THRESHOLD )) && return

    local human
    if (( elapsed >= 3600 )); then
        printf -v human '%dh %dm %ds' \
            $(( elapsed / 3600 )) $(( (elapsed % 3600) / 60 )) $(( elapsed % 60 ))
    elif (( elapsed >= 60 )); then
        printf -v human '%dm %ds' $(( elapsed / 60 )) $(( elapsed % 60 ))
    else
        printf -v human '%.2fs' "$elapsed"
    fi
    RPROMPT="%F{61}↳%f %F{15}took%f %F{166}${human}%f"
}
add-zsh-hook preexec __cmd_timer_preexec
add-zsh-hook precmd __cmd_timer_precmd

# ----------------------------------- Conda / Brew ------------------------------
# Lazy init: we define a stub that performs the real initialization on first use, then hands
# off to the real `conda`. (auto_activate/changeps1 are persisted in ~/.condarc,
# so they don't need to be set on every startup.)
__CONDA_BASE="/opt/homebrew/Caskroom/miniconda/base"
conda() {
    unset -f conda  # prevent infinite recursion
    local __conda_setup
    if ! __conda_setup="$("$__CONDA_BASE/bin/conda" 'shell.zsh' 'hook' 2>/dev/null)"; then
        print -u2 "conda: failed to initialize via '$__CONDA_BASE/bin/conda shell.zsh hook'"
        return 1
    fi
    eval "$__conda_setup"
    conda "$@"
}

export HOMEBREW_AUTO_UPDATE_SECS=1296000   # every 15 days

# --------------------------------- Completion ----------------------------------
# Fish-like: menu selection + case-insensitive / partial matching, colorized.
autoload -Uz compinit && compinit
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*:descriptions' format '%F{166}%d%f'

# jujutsu completion: use the dynamic engine so bookmarks/revisions complete.
command -v jj >/dev/null 2>&1 && source <(COMPLETE=zsh jj)

# ------------------------- Fish-like interactive plugins -----------------------
# Gray inline suggestion from history (accept with → / End).
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh 2>/dev/null

# Syntax highlighting MUST be sourced last.
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 2>/dev/null
