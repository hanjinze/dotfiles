# /etc/skel/.bashrc
#
# This file is sourced by all *interactive* bash shells on startup,
# including some apparently interactive shells such as scp and rcp
# that can't tolerate any output.  So make sure this doesn't display
# anything or bad things will happen !


# Test for an interactive shell.  There is no need to set anything
# past this point for scp and rcp, and it's important to refrain from
# outputting anything in those cases.
if [[ $- != *i* ]] ; then
    # Shell is non-interactive.  Be done now!
    return
fi


# Put your fun stuff here.
PATH="/opt/android-sdk-update-manager/platform-tools/:~/bin/:$PATH"
EDITOR="/usr/bin/vim"
ANDROID_JAVA_HOME="/etc/java-config-2/current-system-vm"
export ANDROID_JAVA_HOME
export TERM='xterm-256color'
export LANG=en_US.utf8

. ~/.vim/bundle/powerline/powerline/bindings/bash/powerline.sh
#function _update_ps1() {
#    export PS1="$(~/dotfiles/powerline-shell/powerline-shell.py $?)"
#}

#export PROMPT_COMMAND="_update_ps1"
