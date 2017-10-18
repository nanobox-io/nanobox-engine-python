#!/bin/bash

# Here we get to be a bit clever. pip will store it's cache (deps, etc)
# in the site-packages dir. Changing this is not easily configurable, so we'll
# essentially setup a cache dir in ~/.nanobox/pip_cache, and symlink
# the site-packages to the cached location.

site_packages="{{data_dir}}/lib/{{runtime}}/site-packages"
cache_dir="{{code_dir}}/.nanobox/pip_cache/site-packages"

# remove site-packages if it's a directory
if [[ -d ${site_packages} ]]; then
  rm -rf ${site_packages}
fi

# if site-packages isn't a symlink, create it
if [[ ! -s ${site_packages} ]]; then
  mkdir -p ${cache_dir}
  ln -s ${cache_dir} ${site_packages}
fi
