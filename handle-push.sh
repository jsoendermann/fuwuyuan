echo "Building ${@[1]}"

# TODO move this to constants.sh
WORKDIR=/workdir

if [[ ${@[1]} =~ ^(.*)/(.*)$ ]]; then
  echo ${BASH_REMATCH[@]}
  echo ${BASH_REMATCH[1]}
  echo ${BASH_REMATCH[2]}

  # if [[ ! -d "${WORKDIR}/${BASH_REMATCH[1]}" ]]; then
  #   mkdir "${WORKDIR}/${BASH_REMATCH[1]}"
  # fi

  # cd 
fi