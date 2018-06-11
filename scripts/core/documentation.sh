#!/usr/bin/env bash

function extract_help() {
    grep "^##?" "${1:-}" \
        | cut -c 5-
}

function docs::_eval() {
    local readonly docopts="$1"
    local readonly file="$2"
    shift 2
    local help="$(extract_help "$file")"
    if [[ ${1:-} = "--version" ]]; then
        local readonly version_code=$(grep "^ #?" "$file" | cut -c 5- || echo "unversioned")
        local git_info=$(cd "$(dirname "$file")" && git log -n 1 --pretty=format:'%h%n%ad%n%an%n%s' --date=format:'%Y-%m-%d %Hh%M' -- "$(basename "$file")")
        local version="$(echo -e "${version_code}\n${git_info}")"
        eval "$($docopts -h "${help}" -V "${version}" : "${@}")"
    else
        eval "$($docopts -h "${help}" : "${@}")"
    fi
}

function docs::go_eval() {
    echo "GO DOCS"
    docs::_eval "$DOTFILES/scripts/core/docopts/docopts" "$0" "$@"
}

function docs::python_eval() {
    echo "PYTHON DOCS"
    docs::_eval "$DOTFILES/scripts/core/docopts/docopts_py.sh" "$0" "$@"
}

function docs::eval() {
    if platform::command_exists "python"; then
        docs::python_eval "$@"
    else  
        docs::go_eval "$@"
    fi
}
