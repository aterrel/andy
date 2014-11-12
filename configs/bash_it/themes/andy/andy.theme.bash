#!/usr/bin/env bash
SCM_THEME_PROMPT_DIRTY=" ${red}✗"
SCM_THEME_PROMPT_CLEAN=" ${bold_green}✓"
SCM_THEME_PROMPT_PREFIX=" |"
SCM_THEME_PROMPT_SUFFIX="${green}|"

GIT_THEME_PROMPT_DIRTY=" ${red}✗"
GIT_THEME_PROMPT_CLEAN=" ${bold_green}✓"
GIT_THEME_PROMPT_PREFIX=" ${green}|"
GIT_THEME_PROMPT_SUFFIX="${green}|"

RVM_THEME_PROMPT_PREFIX="|"
RVM_THEME_PROMPT_SUFFIX="|"


function win-divider() {
    s="_"
    o=""
    let nl=$COLUMNS
    for i in `seq 1 $nl`; do o="${o}${s}"; done
    echo $o
}

function prompt_command() {
    #PS1="${bold_cyan}$(scm_char)${green}$(scm_prompt_info)${purple}$(ruby_version_prompt) ${yellow}\h ${reset_color}in ${green}\w ${reset_color}\n${green}→${reset_color} "
    #PS1="\n${yellow}$(ruby_version_prompt) ${purple}\h ${reset_color}in ${green}\w\n${bold_cyan}$(scm_char)${green}$(scm_prompt_info) ${green}→${reset_color} "
    PS1="$(win-divider)\n${yellow}$(date +%m-%d" "%H:%M:%S) ${purple}\u"@"${blue}\h ${reset_color}in ${green}\w\n${bold_cyan}$(scm_char)${green}$(scm_prompt_info) ${green}→${reset_color} "

}

PROMPT_COMMAND=prompt_command;
