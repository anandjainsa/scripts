#!/bin/sh
set -e

# git-pass
# ========

# This script allows easy usage of http://www.passwordstore.org/ with
# multiple, Git-managed stores. It works both as self-standing shell
# script (that can be committed to the repository itself), or as a Git
# subcommand (in which case it should reside somewhere in $PATH or in
# $(git --exec-prefix) and be named "git-pass"). All it does is set
# password store directory and invoke "pass", so you can just use it
# like you use "pass" and everything should work automagically.

# The script locates password store directory in the following way:
#
#   1. If a "pass.dir" Git config variable is set, use it
#   2. If any number of files named ".gpg-id" exist in the repository,
#      use a repo subdirectory that includes all of them
#   3. If no ".gpg-id" files exist, use repository root.

# This means, that if no store exists in the repo, you can run "git
# pass init -p ..." to initialize a store in repo's subdirectory.

# License (MIT)
# -------------

# Copyright (c) 2014 Maciej Pasternacki <maciej@3ofcoins.net>

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

_find_almost_password_store_git_dir () {
    # http://stackoverflow.com/a/17475354 wrapped in a shell function
    # to avoid quoting spaghetti
    git ls-files '.gpg-id' '**/.gpg-id' \
        | sed -e 'N;s/^\(.*\).*\n\1.*$/\1\n\1/;D'
}

_password_store_git_dir () {
    # Find the "almost store dir"
    _almost_password_store_git_dir="$(_find_almost_password_store_git_dir)"
    # If nothing was found, fall back to "."
    _almost_password_store_git_dir=${_almost_password_store_git_dir:-.}
    # Remove final component: either common part of couple
    # subdirectories, or file name.
    echo "${_almost_password_store_git_dir%/*}"
}

find_password_store_dir () {
    # No need for subshell here, even though we 'cd', because it is
    # only invoked as a command substitution, which is a subshell
    # already.
    cd "$(git config --get pass.dir || _password_store_git_dir)"
    pwd
}

SUBDIRECTORY_OK=1

. $(git --exec-path)/git-sh-setup

require_work_tree
cd_to_toplevel

export \
    PASSWORD_STORE_DIR="$(find_password_store_dir)" \
    PASSWORD_STORE_GIT="$(pwd)" \
    EDITOR="$(git var GIT_EDITOR)"

exec pass "${@}"
