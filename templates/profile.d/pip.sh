# -*- mode: bash; tab-width: 2; -*-
# vim: ts=2 sw=2 ft=bash noet

mkdir -p ${HOME}/.cache
ln -sf {{code_dir}}/.pip-cache ${HOME}/.cache/pip
