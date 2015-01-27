#!/bin/bash

set -uo pipefail

PATH="/bin:${PATH}"
IFS="$(printf '\n\t')"

get_scriptname(){
  set -e
  local scriptname=$(basename ${0})
  set +e

  echo ${scriptname}
  return 0
}

get_workdir(){
  set -e
  local workdir="$(pwd)/$(dirname ${0})"
  if [ "$(dirname ${0})" = "." ]; then
    local workdir="$(pwd)"
  fi
  set +e

  echo ${workdir}
  return 0
}

get_dotfiles(){
  set -e
  local workdir="$(get_workdir)"
  local scriptname="$(get_scriptname)"
  set +e

  ls -1 ${workdir} |
  grep -v "README.md" |
  grep -v ${scriptname}
  return 0
}

main()
{
  local workdir="$(get_workdir)"

  while read files
  do
    local filepath="${workdir}/${files}"
    local tofilepath="${HOME}/.${files}"
    if [[ -e "${tofilepath}" ]]; then
      echo "${tofilepath} already exists."
    else
      ln -s "${filepath}" "${tofilepath}"
    fi
  done < <(get_dotfiles)
}

main
