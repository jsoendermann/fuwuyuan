set -e

RED='\033[33;31m'
NC='\033[0m'

# TODO check all required env vars with function
if [[ -z $PFEIFE_URL ]]; then
  echo -e "${RED}Env var PFEIFE_URL is required${NC}"
  exit -1
fi

echo "Thanks for using pfeife!"

WORKDIR=/workdir
WEBHOOK_JSON_PREFIX='{"name": "web", "active": true, "events": ["push"], "config": {"url": "'
WEBHOOK_JSON_SUFFIX='", "content_type": "json"}}'

if [[ ! -d $WORKDIR ]]; then
  mkdir "$WORKDIR"
fi

IFS=','
read -ra BRANCHES_TO_WATCH_ARRAY <<< "$BRANCHES_TO_WATCH"

for BRANCH in "${BRANCHES_TO_WATCH_ARRAY[@]}"
do
  if [[ "$BRANCH" =~ ^(.*)#(.*)$ ]]; then
    printf "Installing webhook on ${BASH_REMATCH[1]}... "
    RESULT=$(curl \
      --silent \
      --user "$GITHUB_USERNAME:$GITHUB_AUTH_TOKEN" \
      --data "$WEBHOOK_JSON_PREFIX$PFEIFE_URL$WEBHOOK_JSON_SUFFIX" \
      "https://api.github.com/repos/${BASH_REMATCH[1]}/hooks")

    # TODO make this more robust
    MESSAGE=`echo "$RESULT" | jq '.message'`
    if [[ "$MESSAGE" == '"Validation Failed"' ]]; then
      ERROR_MESSAGE=`echo "$RESULT" | jq '.errors[0].message'`
      if [[ "$ERROR_MESSAGE" == '"Hook already exists on this repository"' ]]; then
        echo "Webhook already exists"
      else
        echo -e "${RED}${ERROR_MESSAGE}$NC"
        exit -1
      fi
    else
      echo "Done"
    fi
  fi
done


node http-server.js