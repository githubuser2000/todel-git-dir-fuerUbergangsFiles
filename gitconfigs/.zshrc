# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# The following lines were added by compinstall

zstyle ':completion:*' completer _expand _complete _ignored _correct _approximate
zstyle ':completion:*' format '3 %d'
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list 'm:{[:lower:]}={[:upper:]} m:{[:lower:][:upper:]}={[:upper:][:lower:]} r:|[]=** r:|=** l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle :compinstall filename '/home/alex/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall
# Lines configured by zsh-newuser-install
HISTFILE=$HOME/.zsh_history
HISTSIZE=100000
SAVEHIST=100000
setopt appendhistory autocd extendedglob nomatch notify
unsetopt beep
bindkey -v
zle -N zle-line-init
zle -N zle-keymap-select


# Use lf to switch directories and bind it to ctrl-o
lfcd () {
    tmp="$(mktemp)"
    lf -last-dir-path="$tmp" "$@"
    if [ -f "$tmp" ]; then
        dir="$(cat "$tmp")"
        rm -f "$tmp"
        [ -d "$dir" ] && [ "$dir" != "$(pwd)" ] && cd "$dir"
    fi
}
bindkey -s '^o' 'lfcd\n'
bindkey -s '^y' 'rp\n'
bindkey -s '^v' 'nvim -c VimwikiTabIndex\n'
bindkey -s '^b' 'nvim -S ~/myRepos/reta/`ls -r ~/myRepos/reta | grep -e '\.nvim$' | head -1`\n'
bindkey -s '^s' 'steam steam://rungameid/281990\n'
#bindkey -s '^e' '/usr/bin/emacsclient -c -a "/usr/bin/emacs"&\n'

typeset -A key
key=(
  BackSpace  "${terminfo[kbs]}"
  Home       "${terminfo[khome]}"
  End        "${terminfo[kend]}"
  Insert     "${terminfo[kich1]}"
  Delete     "${terminfo[kdch1]}"
  Up         "${terminfo[kcuu1]}"
  Down       "${terminfo[kcud1]}"
  Left       "${terminfo[kcub1]}"
  Right      "${terminfo[kcuf1]}"
  PageUp     "${terminfo[kpp]}"
  PageDown   "${terminfo[knp]}"
)
        function zle-line-init () {
            printf '%s' "${terminfo[smkx]}"
            zle reset-prompt  # <----- this line
        }
        function zle-line-finish () {
            printf '%s' "${terminfo[rmkx]}"
            zle reset-prompt  # <----- this line
        }
# Finally, make sure the terminal is in application mode, when zle is
# active. Only then are the values from $terminfo valid.
if (( ${+terminfo[smkx]} )) && (( ${+terminfo[rmkx]} )); then
    function zle-line-init () {
        printf '%s' "${terminfo[smkx]}"
    }
    function zle-line-finish () {
        printf '%s' "${terminfo[rmkx]}"
    }
    zle -N zle-line-init
    zle -N zle-line-finish
fi
# End of lines configured by zsh-newuser-install
source ~/powerlevel10k/powerlevel10k.zsh-theme
source ~/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

parent_pid=$(ps -o ppid= -p $$);ifzsh=`ps -p \`echo ${parent_pid}\` -o comm= | grep zsh | wc -l`
if [ $ifzsh -eq 1 ]; then
    #echo "Eine weitere Bash-Sitzung wurde innerhalb der aktuellen Bash-Sitzung gestartet."
    typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet
PATH=~/bin:${PATH}:~/Eigene-Dateien/myRepos/reta
LD_LIBRARY_PATH=~/lib:$LD_LIBRARY_PATH
C_INCLUDE_PATH=~/include:$C_INCLUDE_PATH

# Allgemeine Aliase
alias ll='ls -lh'                      # Detaillierte Anzeige im langen Format
alias la='ls -a'                       # Zeigt alle Dateien einschließlich versteckter an
alias lsa='ls -la'                     # Alle Dateien und Verzeichnisse im langen Format

# Kopieren
alias cpv='cp -v'                      # Kopieren mit Fortschrittsanzeige
alias cps='cp -i'                      # Kopieren mit Bestätigungsabfrage

# Verschieben
alias mvf='mv -f'                     # Verschieben ohne Nachfrage
alias mvi='mv -i'                     # Verschieben mit Bestätigungsabfrage

# Suchen
alias grep='grep --color=auto'        # Grep-Ausgabe farblich hervorheben

# Speicherplatz
alias dfh='df -h'                     # Freier Speicherplatz in menschenlesbarem Format
alias duh='du -h'                     # Größe von Verzeichnissen und Dateien in menschenlesbarem Format

# Prozesse
alias psaux='ps aux'                  # Alle laufenden Prozesse anzeigen

# Befehlsverlauf
alias h='history'                    # Zeigt den Befehlsverlauf an

# Dateiberechtigungen
alias chmodx='chmod +x'               # Datei ausführbar machen

alias ll='ls -l --color=auto'
alias la='ls -A --color=auto'
alias gf='grep -i'
alias lshuman='ls -lh --color=auto'
alias gitcommit='git add . && git commit -m'
alias gf='grep -i'
alias lshuman='ls -lh --color=auto'
alias gitcommit='git add . && git commit -m'

alias task="/opt/scripts/task"
alias v="/usr/local/bin/nvim"
alias dir="lsd -ltrah"
alias cddoc="cd ~/Eigene-Dateien/Dokumente"
alias cdreta="cd ~/Eigene-Dateien/Eigene-Dateien/myRepos/reta"
alias cdrepos="cd ~/Repos"
alias cdmyrepos="cd ~/Eigene-Dateien/Eigene-Dateien/myRepos/"
alias cdtxt="cd ~/Eigene-Dateien/Dokumente/txt-tagebuch"
alias cdoc="cddoc"
alias blog="cdtxt"
alias myR="cdmyrepos"
alias R="cdrepos"
alias cdbup="cd /home/alex/Eigene-Dateien/ak_dirsys_4/Backup"
alias bup="cdbup"
dotf="find ${HOME} -maxdepth 1 -name '.*' -type f"
alias cmddotfiles="echo ${dotf}"
alias dotfiles="zsh -c \"${dotf}\""
alias aksync="rsync -axHAWXS"

clip() {
cat ${1} | wl-copy
}
copyclip() {
  xclip -selection clipboard "$@"
}

erst=true
PKG_CONFIG_PATH=/usr/local/lib/pkgconfig/
export SDL_VIDEODRIVER=dummy
export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/usr/local/lib"
export exec_prefix=/usr

#else
    #echo "Keine weitere Bash-Sitzung läuft innerhalb der aktuellen Bash-Sitzung."
#PATH=${PATH}
fi

#rsync -avz -e "export a=`ssh v6a \"cd /home/alex;a=\`find . -maxdepth 1 -name '.*' -type f | sed 's/\.\///g' | sed 's/\s/,/g'\`\"`" v6a:/home/alex/{"$a"} R
#rsync -avz v6a:/home/alex/{.a.txt.swp,.bash_profile,.ReTaPromptHistory,.bash_logout,.p10k.zsh,.lesshst,.zshrc.zni,.gitconfig,.google_authenticator,.zcompdump,.bash_history,.python_history,.viminfo,.bashrc,.zshrc,.histfile}  ~/Eigene-Dateien/ak_dirsys_4/Backup/v6/home/alex/
##find . -maxdepth 1 -name '.*' -type f | sed 's/\.\///g' | tr "\n" "," | cat  -
#params2 "{.a.txt.swp,.bash_profile,.ReTaPromptHistory,.bash_logout,.p10k.zsh,.lesshst,.zshrc.zni,.gitconfig,.google_authenticator,.zcompdump,.bash_history,.python_history,.viminfo,.bashrc,.zshrc,.histfile}" R
# aksync /home/alex/{.bash_logout,.profile,.sommelierrc,.bash_history,.python_history,.bashrc,.shell.pre-oh-my-zsh,.p10k.zsh,.zcompdump-penguin-5.8,.zcompdump-penguin-5.8.zwc,.sudo_as_admin_successful,.bash_history.2023-12-24,.gitconfig,.vimrc4nv,.recently-used,.wget-hsts,.ReTaPromptHistory.old2024-04,.ReTaPromptHistory,.sqlite_history,.viminfo,.zcompdump-penguin-5.9,.zcompdump-penguin-5.9.zwc,.Xauthority,.zsh_history,.lesshst,.zshrc} v6a:/home/alex/Eigene-Dateien/ak_dirsys_4/Backup/2024-09-l3-bup/home/alex/
# cd /home/alex;find . -maxdepth 1 -name '.*' -type f | sed 's/\.\///g' | tr "\n" "," | cat  -;cd -
# rsync -avz v6a:/home/alex/{.a.txt.swp,.bash_profile,.ReTaPromptHistory,.bash_logout,.p10k.zsh,.lesshst,.zshrc.zni,.gitconfig,.google_authenticator,.zcompdump,.bash_history,.python_history,.viminfo,.bashrc,.zshrc,.histfile}  ~/Eigene-Dateien/ak_dirsys_4/Backup/v6/home/alex/
#
#RAPZERR() {
#  FAILED_COMMAND=$1
#}
#
#precmd() {
#  if [[ $? -ne 0 ]]; then
#    rpb $FAILED_COMMAND
#    FAILED_COMMAND=""
#  fi
#}
HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000000
SAVEHIST=10000000
setopt BANG_HIST                 # Treat the '!' character specially during expansion.
setopt EXTENDED_HISTORY          # Write the history file in the ":start:elapsed;command" format.
setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
setopt SHARE_HISTORY             # Share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire duplicate entries first when trimming history.
setopt HIST_IGNORE_DUPS          # Don't record an entry that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Delete old recorded entry if new entry is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a line previously found.
setopt HIST_IGNORE_SPACE         # Don't record an entry starting with a space.
setopt HIST_SAVE_NO_DUPS         # Don't write duplicate entries in the history file.
setopt HIST_REDUCE_BLANKS        # Remove superfluous blanks before recording entry.
setopt HIST_VERIFY               # Don't execute immediately upon history expansion.
setopt HIST_BEEP
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
opath=($HOME/.zsh/zsh-completions/src $fpath)
source ~/.zsh/zsh-git-prompt/zshrc.sh
PROMPT='%B%m%~%b$(git_super_status) %# '
source $HOME/.zsh-vi-mode/zsh-vi-mode.plugin.zsh
export DISPLAY=":1"
#typeset -g POWERLEVEL9K_INSTANT_PROMPT=on
#rp
#rpDaemon.sh
typeset -g POWERLEVEL9K_INSTANT_PROMPT=on
echo tmux attach orOder tmux detach
echo "tmux ctrl+b ? session, client, window, pane"
echo r=tmux attach
typeset -g POWERLEVEL9K_INSTANT_PROMPT=off
alias v="nvim"
alias r="tmux attach"
alias v6g="ssh -X -L 5901:localhost:5901 v6a"
alias rr="tmux attach"
alias rrr="tmux detach"
#source $HOME/.zsh-vi-mode/zsh-vi-mode.plugin.zsh
alias v6="ssh v6a"
alias dir="lsd -ltrah"
alias rpmake="/home/alex/Eigene-Dateien/myRepos/rpmake"

# Optionen setzen
setopt no_nomatch        # verhindert Fehler bei nicht passenden Globs
setopt completeinword    # bessere Tab-Vervollständigung
unsetopt nomatch         # erlaubt auch nicht passende Muster

# Completion neu initialisieren
autoload -Uz compinit
compinit -u              # -u verhindert Kompilierungsfehler bei alten .zcompdump-Dateien

zstyle ':completion:*' matcher-list ''
PATH=$HOME/bin:${PATH}:$HOME/Eigene-Dateien/myRepos/reta:$HOME/Eigene-Dateien/myRepos/todel-git-dir-fuerUbergangsFiles

export EDITOR=nvim
export VISUAL=nvim
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey -M vicmd 'v' edit-command-line
bindkey -M vicmd 'k' history-beginning-search-backward
bindkey -M vicmd 'j' history-beginning-search-forward

# Interaktives Skriptausführen
runfile() {
    local file="$1"
    if [[ ! -f "$file" ]]; then
        echo "Datei nicht gefunden: $file"
        return 1
    fi

    echo "========== Inhalt von: $file =========="
    cat "$file"
    echo "======================================="
    echo -n "Ausführen? (j/n): "
    read -r choice
    if [[ "$choice" == "j" ]]; then
        case "$file" in
            *.sh) bash "$file" ;;
            *.py) python3 "$file" ;;
            *) echo "Unbekannter Dateityp"; return 2 ;;
        esac
    else
        echo "Abgebrochen."
    fi
}

