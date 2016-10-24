# -*- mode: bash; tab-width: 2; -*-
# vim: ts=2 sw=2 ft=bash noet

if [ ! -s ${HOME}/.cache/pip ]; then
  mkdir -p ${HOME}/.cache/pip
  ln -sf {{code_dir}}/.pip-cache ${HOME}/.cache/pip
fi
