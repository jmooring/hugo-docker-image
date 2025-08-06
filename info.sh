#!/usr/bin/env bash

#------------------------------------------------------------------------------
# @file
# Displays information about the container and installed applications.
#------------------------------------------------------------------------------

main() {

  os=$(lsb_release -d | awk -F: '{print $2}' | tr -d "\t")
  arch=$(uname -m)

  version_asciidoctor=$(asciidoctor --version | awk '/Asciidoctor/ {print $2}')
  version_brotli=$(brotli --version | awk '{print $2}')
  version_dart_sass=$(sass --version)
  version_git=$(git --version | awk '{print $3}')
  version_go=$(go version | awk '{print $3}' | sed 's/go//')
  version_gzip=$(gzip --version | awk '/gzip/ {print $2}')
  version_hugo=$(hugo version | awk '{print $2}' | awk -F- '{print $1}' | sed 's/v//')
  version_node=$(node --version | sed 's/v//')
  version_npm=$(npm --version)
  version_pagefind=$(pagefind --version | awk '{print $2}')
  version_pandoc=$(pandoc --version | grep -m1 pandoc | awk '{print $2}')
  version_python3=$(python3 --version | awk '{print $2}')
  version_rst2html=$(rst2html --version | awk '{print $3}' | tr -d ',')
  version_ruby=$(ruby --version | awk '{print $2}')
  version_zstd=$(zstd --version | awk '{print $5}'  | tr -d ',')

  heredoc=$(cat <<EOT
${os} ($arch)

Application   Version
-----------   ---------
asciidoctor   ${version_asciidoctor}
brotli        ${version_brotli}
dart sass     ${version_dart_sass}
git           ${version_git}
go            ${version_go}
gzip          ${version_gzip}
hugo          ${version_hugo}
node          ${version_node}
npm           ${version_npm}
pagefind      ${version_pagefind}
pandoc        ${version_pandoc}
python3       ${version_python3}
rst2html      ${version_rst2html}
ruby          ${version_ruby}
zstd          ${version_zstd}
EOT
)

  printf "\n%s\n\n" "${heredoc}"

}

# set -euo pipefail
main "$@"
