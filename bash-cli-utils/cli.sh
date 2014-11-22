function debug
{
    if $VERBOSE; then
        echo "$*"
    fi
}

function redirect
{
    local OUT=$1
    shift
    if $DRY_RUN; then
        echo "$*" \>\> ${OUT}
    else
        run "$@" >> ${OUT}
    fi
}

function run
{
    if $DRY_RUN; then
        echo "$*"
    else
        debug "$*"
        eval "$@"
    fi
}

function create_empty
{
    local OUT=$1
    shift
    if $DRY_RUN; then
        echo ":" \> ${OUT}
    else
        : > ${OUT}
    fi
}

