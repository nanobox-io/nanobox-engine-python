#!/bin/bash

# Nanobox stashes the pip module src and bin dirs inside of a cache_dir
# at {{code_dir}}/.nanobox/pip. We need to set PATH to include the bin dir
# and PYTHONPATH to include the src dir

export PATH={{code_dir}}/.nanobox/pip/bin:$PATH
export PYTHONPATH={{code_dir}}/.nanobox/pip/src:$PYTHONPATH
