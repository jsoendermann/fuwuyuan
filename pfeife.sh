set -e

echo "Thanks for using pfeife!"

workdir=/workdir
http_requests_file="$workdir/http_requests"

mkdir "$workdir"

ncat --keep-open --listen 8080 > $http_requests_file &

while true
do
    if [[ -s $http_requests_file ]]; then
        cat $http_requests_file
        # Execute checker script
        # Reply back with nc
        : > $http_requests_file
    fi
    sleep 1
done
