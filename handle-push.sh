set -e

args=("$@")
BRANCH_NAME=${args[1]}

echo "Building ${args[0]}#$BRANCH_NAME"

# TODO move this to constants.sh
# WORKDIR=/workdir
WORKDIR=/workdir

if [[ ${args[0]} =~ ^(.*)/(.*)$ ]]; then
  USERNAME=${BASH_REMATCH[1]}
  REPO_NAME=${BASH_REMATCH[2]}

  USER_DIR="${WORKDIR}/${USERNAME}"
  REPO_DIR="${USER_DIR}/${REPO_NAME}"

  if [[ ! -d "$USER_DIR" ]]; then
    echo "Creating ${USER_DIR}"
    mkdir $USER_DIR
  fi

  # TODO Lock at this point

  if [[ ! -d "$REPO_DIR" ]]; then
    git clone https://${GITHUB_USERNAME}:${PRIMLO_GITHUB_AUTH_TOKEN}@github.com/${USERNAME}/${REPO_NAME}.git "$REPO_DIR"
  fi

  # (
    cd "$REPO_DIR"
    git checkout $BRANCH_NAME
    git pull

    DATE=$(date -u "+%F-%H%M%S")
    ARCHIVE_NAME="${USERNAME}_${REPO_NAME}_${BRANCH_NAME}_${DATE}.tar.bz2"
    tar -cjvf "../../$ARCHIVE_NAME" .

    cd ../..

    curl \
      --unix-socket /var/run/docker.sock \
      -H "Content-Type: application/x-tar" \
      -H "Transfer-Encoding:chunked" \
      --data-binary "@${ARCHIVE_NAME}" \
      "http://localhost/build?t=pfeifesocket1"
    
    rm -f "$ARCHIVE_NAME"
  # )
fi
