#!/bin/sh

# usage:
# push_gh-pages (from:)<dir> (to:)<branch>

set -e

PUSH_DIR="${1:-_site}"
PUSH_BRANCH="${2:-gh-pages}"

git --git-dir=.git --work-tree="${PUSH_DIR}" checkout --orphan "${PUSH_BRANCH}"
git --git-dir=.git --work-tree="${PUSH_DIR}" add --all
git --git-dir=.git --work-tree="${PUSH_DIR}" commit --allow-empty -m "autogen: update site"
git --git-dir=.git --work-tree="${PUSH_DIR}" push -f origin "${PUSH_BRANCH}"
