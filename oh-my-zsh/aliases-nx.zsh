function nxra {
    npx nx@latest run-many --target=$1 --parallel --all
}

alias ydocs='yarn documentation'