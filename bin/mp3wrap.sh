#!/usr/bin/env bash
set -e

err_report() {
    echo "ERROR: on line $*: $(cat $0 | sed $1!d)" >&2
}

trap 'err_report $LINENO' ERR

uid=$(id -u)

if [ "${uid}" -eq 0 ]; then
    echo "Please run as user"
    exit
fi

pwd=$(pwd)

install="$1"

opts=( "${@:2}" )

. "${pwd}/bin/scripts/load.sh"

## Builds binaries
## Usage: ${script} <option> [optional]
## ${commands}

case "${install}" in

    "")
        source="audio"
        ;;

    "--target") # builds and runs specified target
        source="$2"
        opts=( "${@:3}" )
        ;;

    "--all") # builds and runs specified target
        source="audio"
        opts=( "${@:2}" )
        ;;

    *)
        help
        exit 8
        ;;

esac

for opt in ${opts[@]}; do
    case ${opt} in

        "")
            ;;

        "--silent") # [optional] suppress verbose output
            silent="--silent"
            ;;

        "--help") # [optional] shows command desctiption
            help
            exit 8
            ;;

        *)
            help
            exit 8
            ;;

    esac
done

if [[ "${silent}" == "--silent" ]]; then
    exec 2>&1 >/dev/null
fi

[ ! -d "${pwd}/output" ] && mkdir "${pwd}/output"

find "${source}" -type f -name "*.mp3" -exec echo {} \; | xargs mp3wrap "${pwd}/output/file.mp3"

if [ "${silent}" == "--silent" ]; then
    exec 1>&2 2>&-
fi

[[ $SHLVL -gt 2 ]] || echo OK

cd "${pwd}"
