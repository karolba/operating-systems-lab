#!/bin/bash -eu

function print_help () {
    echo "This script allows to search over movies database"
    echo -e "-d DIRECTORY\n\tDirectory with files describing movies"
    echo -e "-a ACTOR\n\tSearch movies that this ACTOR played in"
    echo -e "-t QUERY\n\tSearch movies with given QUERY in title"
    echo -e "-y YEAR\n\tSearch movies newer than YEAR"
    echo -e "-f FILENAME\n\tSaves results to file (default: results.txt)"
    echo -e "-x\n\tPrints results in XML format"
    echo -e "-h\n\tPrints this help message"
}

function print_error () {
    echo -e "\e[31m\033[1m${*}\033[0m" >&2
}

function get_movies_list () {
    local -r MOVIES_DIR=${1}
    local -r MOVIES_LIST=$(cd "${MOVIES_DIR}" && realpath ./*)
    echo "${MOVIES_LIST}"
}

function query_title () {
    # Returns list of movies from ${1} with ${2} in title slot
    local -r MOVIES_LIST=${1}
    local -r QUERY=${2}

    local RESULTS_LIST=()
    for MOVIE_FILE in ${MOVIES_LIST}; do
        if grep "^| Title" "${MOVIE_FILE}" | grep -q "${QUERY}"; then
            RESULTS_LIST+=( "${MOVIE_FILE}" )
        fi
    done
    echo "${RESULTS_LIST[@]:-}"
}

function query_actor () {
    # Returns list of movies from ${1} with year gt ${2}
    local -r MOVIES_LIST=${1}
    local -r QUERY=${2}

    local RESULTS_LIST=()
    for MOVIE_FILE in ${MOVIES_LIST}; do
        if grep "^| Actors" "${MOVIE_FILE}" | grep -q "${QUERY}"; then
            RESULTS_LIST+=( "${MOVIE_FILE}" )
        fi
    done
    echo "${RESULTS_LIST[@]:-}"
}

function query_year () {
    # Returns list of movies from ${1} with ${2} in actor slot
    local -r MOVIES_LIST=${1}
    local -r QUERY=${2}

    local RESULTS_LIST=()
    for MOVIE_FILE in ${MOVIES_LIST}; do
        if (( $(grep '^| Year: ' "${MOVIE_FILE}" | cut -d\  -f3) > QUERY )); then
            RESULTS_LIST+=( "${MOVIE_FILE}" )
        fi
    done
    echo "${RESULTS_LIST[@]:-}"
}

function query_plot () {
    # Returns list of movies from ${1} with plot ~ ${2}, ${3} specifies extra grep opts
    local -r MOVIES_LIST=${1}
    local -r QUERY=${2}

    local RESULTS_LIST=()
    for MOVIE_FILE in ${MOVIES_LIST}; do
        if grep -E '^\| Plot: ' "${MOVIE_FILE}" | grep -qE"${3}" "${QUERY}"; then
            RESULTS_LIST+=( "${MOVIE_FILE}" )
        fi
    done
    echo "${RESULTS_LIST[@]:-}"
}

function print_xml_format () {
    local -r FILENAME=${1}

    local TEMP;
    TEMP=$(cat "${FILENAME}")

    # change Actor: to <Actor> and others too
    TEMP=$(echo "${TEMP}" | sed -r 's/^\| ([^:]*): /  <\1>/')

    # append tag after each line
    TEMP=$(echo "${TEMP}" | sed -r 's/([A-Za-z]+).*/\0<\/\1>/')

    # replace first line of equals signs
    TEMP=$(echo "${TEMP}" | sed '2s/===*/<movie>/')

    # replace the last line with </movie>
    TEMP=$(echo "${TEMP}" | sed '$s/===*/<\/movie>/')

    echo "${TEMP}"
}

function print_movies () {
    local -r MOVIES_LIST=${1}
    local -r OUTPUT_FORMAT=${2}

    for MOVIE_FILE in ${MOVIES_LIST}; do
        if [[ "${OUTPUT_FORMAT}" == "xml" ]]; then
            print_xml_format "${MOVIE_FILE}"
        else
            cat "${MOVIE_FILE}"
        fi
    done
}


while getopts ":hd:t:a:f:xy:R:i" OPT; do
  case ${OPT} in
    h)
        print_help
        exit 0
        ;;
    d)
        MOVIES_DIR=${OPTARG}
        ;;
    t)
        SEARCHING_TITLE=true
        QUERY_TITLE=${OPTARG}
        ;;
    f)
        FILE_4_SAVING_RESULTS=${OPTARG}
        if [[ ${FILE_4_SAVING_RESULTS} != *.txt ]]; then
            FILE_4_SAVING_RESULTS="${FILE_4_SAVING_RESULTS}.txt"
        fi
        ;;
    a)
        SEARCHING_ACTOR=true
        QUERY_ACTOR=${OPTARG}
        ;;
    x)
        OUTPUT_FORMAT="xml"
        ;;
    y)
        SEARCHING_YEAR=true
        QUERY_NEWER_THAN_YEAR=${OPTARG}
        ;;
    R)
        SEARCHING_PLOT=true
        QUERY_PLOT=${OPTARG}
        ;;
    i)
        SEARCHING_PLOT_IGNORE_CASE=true;
        ;;
    \?)
        print_error "ERROR: Invalid option: -${OPTARG}"
        exit 1
        ;;
  esac
done

if [[ -z ${MOVIES_DIR+x} ]]; then
    print_error "ERROR: Option -d is mandatory"
    print_help
    exit 1
fi

if [[ ! -d ${MOVIES_DIR} ]]; then
    print_error "ERROR: '$MOVIES_DIR' is not a directory"
    exit 1
fi

MOVIES_LIST=$(get_movies_list "${MOVIES_DIR}")

if ${SEARCHING_TITLE:-false}; then
    MOVIES_LIST=$(query_title "${MOVIES_LIST}" "${QUERY_TITLE}")
fi

if ${SEARCHING_ACTOR:-false}; then
    MOVIES_LIST=$(query_actor "${MOVIES_LIST}" "${QUERY_ACTOR}")
fi

if ${SEARCHING_YEAR:-false}; then
    MOVIES_LIST=$(query_year "${MOVIES_LIST}" "${QUERY_NEWER_THAN_YEAR}")
fi

if ${SEARCHING_PLOT:-false}; then
    MOVIES_LIST=$(query_plot "${MOVIES_LIST}" "${QUERY_PLOT}" "${SEARCHING_PLOT_IGNORE_CASE+'i'}")
fi

if ((${#MOVIES_LIST} < 1)); then
    echo "Found 0 movies :-("
    exit 0
fi

if [[ "${FILE_4_SAVING_RESULTS:-}" == "" ]]; then
    print_movies "${MOVIES_LIST}" "${OUTPUT_FORMAT:-raw}"
else
    print_movies "${MOVIES_LIST}" "${OUTPUT_FORMAT:-raw}" | tee "${FILE_4_SAVING_RESULTS}"
fi
