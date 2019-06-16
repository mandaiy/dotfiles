# env
export DOTFILES=$HOME/.dotfiles
export EDITOR=nvim
export LANG=en_US.UTF-8
export LANGUAGE=en
export LC_ALL=en_US.UTF-8

export LSCOLORS=gxfxxxxxcxxxxxxxxxgxgx  # for GNU ls
export LS_COLORS='di=01;36:ln=01;35:ex=01;32'

HISTFILE=$HOME/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000

# zcompile
if [[ ! -e $HOME/.zshrc.zwc || $DOTFILES/.zshrc -nt $HOME/.zshrc.zwc ]]; then
    zcompile $HOME/.zshrc && echo "[zcompile] $DOTFILES/.zshrc compiled" 1>&2
fi

# alias
alias less='less --LINE-NUMBERS --raw-control-chars'
alias grep='grep --line-number --color=auto'

alias ls='ls --color=always --group-directories-first -v'  # --color=always does not work in BSD-ls
alias ll='ls -l --size --human-readable --classify'
alias la='ls -l --size --human-readable --classify --almost-all'
alias l='ls -C --classify'

alias rm='rm --interactive'
alias cp='cp --interactive'
alias mv='mv --interactive'

alias nvimdiff='nvim -d'

alias clear-escape='sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})*)?m//g"'

# options
autoload -Uz select-word-style; select-word-style default
autoload -U compinit; compinit
autoload -Uz colors; colors

autoload history-search-end

bindkey -v # vi bind

zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end

bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end

bindkey "^[[Z" reverse-menu-complete # enable shift tab

typeset -U path PATH

setopt always_last_prompt
setopt auto_cd
setopt auto_menu
setopt auto_pushd
setopt auto_param_slash
setopt auto_param_keys
setopt extended_glob
setopt extended_history
setopt glob
setopt glob_dots
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt hist_reduce_blanks
setopt inc_append_history # add history immediately
setopt interactive_comments
setopt list_packed
setopt long_list_jobs
setopt magic_equal_subst
setopt no_flow_control
setopt no_beep
setopt numeric_glob_sort
setopt pushd_ignore_dups
setopt print_eight_bit
setopt rec_exact
setopt share_history
setopt transient_rprompt

zstyle :compinstall filename '~/.zshrc'

zstyle ':completion:*' ignore-parents parent pwd
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z} r:|[._-]=*' # ignore case and enable partial-completion
zstyle ':completion:*' format '%B%d%b'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' completer _oldlist _complete _match _history _ignored _approximate _prefix
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:default' menu select=2
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin /usr/sbin /usr/bin /sbin /bin /usr/X11R6/bin
zstyle ':completion:*:process' command 'ps x -o pid,s,args'

zstyle ':zle:*' word-chars " /=;@:{},|"
zstyle ':zle:*' word-style unspecified


# bin
FPATH="$HOME/.zshrc.d/bin:$FPATH"

autoload -U leafdir
autoload -U abbrls
autoload -U ssh

function chpwd() {
	abbrls
}


# prompt
# %n: user name
# %m: hostname
# %W: date (mm/dd/yy)
# %*: time (hh:mm:ss)
# %~: current directory
# %#: user type (root: #, other: %)
function zle-line-init zle-keymap-select {
	case $KEYMAP in
		vicmd)
			mode="%F{cyan}NOR%f"
		;;
		main|viins)
			mode="%F{green}INS%f"
		;;
	esac

	if [ -n "${REMOTEHOST}${SSH_CONNECTION}" ]; then
		host="%F{yellow}%m%f"
	else
		host="%F{cyan}%m%f"
	fi

	if [ ! -z "$VIRTUAL_ENV" ]; then
		venv=" ($(basename $VIRTUAL_ENV))"
	else
		venv=""
	fi

	PROMPT="
<$mode> (%D %*) <%?> [%~]
$host$venv %# "

	zle reset-prompt
}

zle -N zle-line-init
zle -N zle-keymap-select

REPORTTIME=1
KEYTIMEOUT=1 # times out multi-char key combos as fast as possible. (1/100th of a second.)


# zplug
if [[ -d ~/.zplug ]]; then
	source ~/.zplug/init.zsh

	zplug "zplug/zplug", hook-build:'zplug --self-manage'

	zplug "mollifier/cd-gitroot"
	zplug "olivierverdier/zsh-git-prompt", use:zshrc.sh
	zplug "zsh-users/zsh-autosuggestions"
	zplug "zsh-users/zsh-completions"
	zplug "zsh-users/zsh-history-substring-search"
	zplug "zsh-users/zsh-syntax-highlighting", defer:2 # for delayed loading
	#zplug "b4b4r07/enhancd", use:init.sh

	if ! zplug check --verbose; then
		printf "Install? [y/N]: "
		if read -q; then
			echo; zplug install
		fi
	fi

	if zplug check olivierverdier/zsh-git-prompt; then
		RPROMPT='$(git_super_status)'
	fi

	zplug load
fi

if [[ -e ~/.zshrc.local ]]; then
	. ~/.zshrc.local # local rc will override configurations
fi


#if (which zprof > /dev/null) ; then
#	zprof | less
#fi
