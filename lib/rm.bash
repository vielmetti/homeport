#!/bin/bash

set -e

homeport module <<-usage
    usage: homeport <homeport options> unlisten <unlisten options>

    homeport options:

        -t, --tag <string>
            an optional tag for the image so you can create different images
usage

homeport_emit_evaluated "$@" && exit
homeport_labels $1 && shift

trap cleanup EXIT SIGTERM SIGINT

function cleanup() {
    local pids=$(jobs -pr)
    [ -n "$pids" ] && kill $pids
    [ ! -z "$dir" ] && rm -rf "$dir"
}

dir=$(mktemp -d -t homeport_unlisten.XXXXXXX)

docker kill "$homeport_container_name" || echo "Unable to kill $homeport_container_name" 1>&2
docker rm "$homeport_container_name"
