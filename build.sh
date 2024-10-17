#!/usr/bin/env bash

#------------------------------------------------------------------------------
# @file
# Builds the veriphor/hugo image and pushes it to Docker Hub.
#------------------------------------------------------------------------------

main() {

  # Restart Docker Engine (workaround for occassional network loss).
  sudo service docker restart

  # Get latest version tag.
  URL=https://api.github.com/repos/gohugoio/hugo/releases/latest
  VERSION_HUGO=$(curl -sL ${URL} | jq -r ".tag_name" | tr -d v)

  # Build the same image twice.
  docker image build --build-arg="VERSION_HUGO=${VERSION_HUGO}" --tag veriphor/hugo:"${VERSION_HUGO}" .
  docker image build --build-arg="VERSION_HUGO=${VERSION_HUGO}" --tag veriphor/hugo:latest .

  # Push the images to Docker Hub.
  docker login
  docker push veriphor/hugo:"${VERSION_HUGO}"
  docker push veriphor/hugo:latest

}

set -euo pipefail
main "$@"
