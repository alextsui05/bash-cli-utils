#!/bin/bash
source "bash-cli-utils/cli.sh"

function summarize
{
    python - $1 << EOF
import sys
fp = open(sys.argv[1], 'r')
vals = fp.readlines()
vals = map(lambda(x): x.split(" ")[1], vals)
vals = map(lambda(x): float(x), vals)
avg = sum(vals)/len(vals)

print "Average= {0}".format(avg)
print "Min= {0}".format(min(vals))
print "Max= {0}".format(max(vals))
EOF
}

function usage
{
    echo Usage: $(basename $0) output_dir
}

VERBOSE=false
DRY_RUN=false
while getopts ":hnv" opt; do
    case "${opt}" in
    h)
        usage
        exit 0
        ;;
    n)
        DRY_RUN=true
        ;;
    v)
        VERBOSE=true
        ;;
    \?)
        echo "Unrecognized option -${OPTARG}"
        usage
        exit 1
        ;;
    :)
        echo "Option -${OPTARG} requires an argument."
        usage
        exit 1
        ;;
    esac
done
shift $((OPTIND-1))

if [[ $# < 1 ]]; then
    usage
    exit 1
fi

OUTPUT_DIR=$1
if [[ ! -e "${OUTPUT_DIR}" ]]; then
    run mkdir -p "${OUTPUT_DIR}"
fi

DATA_FN="${OUTPUT_DIR}/data.txt"
create_empty "${DATA_FN}"
ITEMS=(data/*.txt)
for ITEM in "${ITEMS[@]}"; do
    LABEL=$(basename "${ITEM}" .txt)
    LABEL=$(shopt -s extglob; echo ${LABEL##+(0)})
    for LINE in $(cat "${ITEM}"); do
        debug "${LABEL} ${LINE}"
        redirect "${DATA_FN}" echo "${LABEL} ${LINE}"
    done
done

SUMMARY_FN="${OUTPUT_DIR}/summary.txt"
create_empty "${SUMMARY_FN}"
redirect "${SUMMARY_FN}" summarize "${DATA_FN}"
run cat "${SUMMARY_FN}"
