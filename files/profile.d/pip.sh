#!/bin/bash

# Nanobox stashes the pip module src and bin dirs inside of a cache_dir
# at /app/.nanobox/pip. We need to set PATH to include the bin dir
# and PYTHONPATH to include the src dir

PYTHONPATH=/app/.nanobox/pip/src:$PYTHONPATH
PATH=/app/.nanobox/pip/bin
