# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000

bindkey -v
# End of lines configured by zsh-newuser-install
#
# The following lines were added by compinstall
zstyle :compinstall filename '~/.zshrc'

autoload -Uz compinit
compinit

# $B>.J8;z$G$bBgJ8;z$K%^%C%A$5$;$k(B
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
# ../ $B$N8e$O:#$$$k%G%#%l%/%H%j$rJd40$5$;$J$$(B
zstyle ':completion:*' ignore-parents parent pwd ..
# sudo $B$N8e$m$G%3%^%s%IL>$rJd40$5$;$k(B
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin \
	/usr/sbin /usr/bin /sbin /bin /usr/X11R6/bin
# ps $B%3%^%s%I$N%W%m%;%9L>Jd40(B
zstyle ':completion:*:process' command 'ps x -o pid,s,args'
# End of lines added by compinstall

export LANG=ja_JP.UTF-8

# $B%U%!%$%kL>$,F|K\8l$N$b$N$rI=<(2DG=$K(B
setopt print_eight_bit

setopt no_beep
setopt auto_cd
setopt auto_pushd
setopt pushd_ignore_dups
setopt magic_equal_subst
setopt share_history
setopt hist_ignore_all_dups
setopt hist_save_nodups
setopt hist_ignore_space
setopt hist_reduce_blanks
setopt auto_menu
setopt extended_glob

# $BC18l6h@Z$j$N;XDj(B
autoload -Uz select-word-style
select-word-style default
zstyle ':zle:*' word-chars " /=;@:{},|"
zstyle ':zle:*' word-style unspecified



alias -g G='| grep'
alias -g L='| less'
alias la='ls -l -a'
alias lf='ls -F -a -l | grep -v /'
alias ldir='ls -F | grep /'
alias ll='ls -l'
alias up='cd ..'
alias vi='vim'


PROMPT="%{${fg[red]}%}[%n@%m]%{${reset_color}%} %~
%# "

[ -f ~/.zshrc.local ] && source ~/.zshrc.local
