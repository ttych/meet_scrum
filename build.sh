#!/bin/sh

# usage:
# buid (to:)<dir>

set -e

BUILD_SRC="${1:-index.adoc}"
BUILD_DIR="${2:-_site}"

REAVEALJS_VERSION="${REAVEALJS_VERSION:-3.9.2}"
BUILD_REVEALJS_DIR="reveal.js-${REAVEALJS_VERSION}"

if [ ! -r "Gemfile" ]; then
    cat <<EOF > Gemfile
source 'https://rubygems.org'

gem 'asciidoctor-revealjs', '~> 4.1'
gem 'rouge', '~> 3.26'
EOF
fi

bundle

if [ ! -d "${BUILD_DIR}" ]; then
    mkdir -p "${BUILD_DIR}"
fi
# rm -Rf "${BUILD_DIR}"/*

if [ ! -d "${BUILD_DIR}/${BUILD_REVEALJS_DIR}" ]; then
    curl -L "https://github.com/hakimel/reveal.js/archive/${REAVEALJS_VERSION}.tar.gz" | tar -C "${BUILD_DIR}" -xz
fi

if ! pgrep -F httpd.pid >/dev/null 2>/dev/null; then
    ruby -run -ehttpd "${BUILD_DIR}" -p "${1:-5123}" &
    echo $! > httpd.pid
fi

bundle exec asciidoctor-revealjs \
       -a revealjsdir="${BUILD_REVEALJS_DIR}" \
       -D "${BUILD_DIR}" \
       "${BUILD_SRC}"
