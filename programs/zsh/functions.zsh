############################
##### Custom Functions #####
############################

# Things to perform after a directory change.
function chpwd() {
    emulate -L zsh

    # Fetch if this is a Git repo.
    [[ -d .git ]] || git rev-parse --git-dir > /dev/null 2>&1
    if [[ "$?" == "0" ]]; then
        echo -e "Fetching from git in the background..."
        (git fetch 2&>/dev/null &)
    fi

    export __zsh_chpwd_just_happened=1
}

# Run right before the prompt.
function precmd() {
    # If the cd just happend...
    if [[ "$__zsh_chpwd_just_happened" == "1" ]]; then
        # Automatically list directory contents.
        ls --color -Fa

        # Run the post-cd command if it exists
        [[ ! -z "$POST_CD_COMMAND" ]] && $POST_CD_COMMAND
    fi
    unset __zsh_chpwd_just_happened
}

# "delete" files (use ~/tmp as a recycle bin)
function del() {
    mv $* $HOME/tmp
}

# Convert MD files to PDF using pandoc
function md2pdf() {
    filename=$(basename "$1")
    extension="${filename##*.}"
    filename="${filename%.*}"

    [[ "$extension" != "md" ]] && echo "Must be markdown file" && return

    pandoc -V geometry:margin=1in -o $filename.pdf $1
}

# Check the spelling of a word using aspell
function spell() {
    # Default to GB spelling, or if the second param exists, use it to specify
    # a different language.
    if [[ -z "$2" ]]; then; lang="en_GB"; else; lang="$2"; fi
    echo "$1" | aspell -a -l "$lang"
}

# Use the https://gitignore.io API to retrieve gitignores
function wgitignore() {
    ignores=$(printf ",%s" "$*[@]")
    ignores=${ignores:1}
    wget "https://www.gitignore.io/api/${ignores}" -O - >> .gitignore
}
