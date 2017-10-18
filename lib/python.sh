# -*- mode: bash; tab-width: 2; -*-
# vim: ts=2 sw=2 ft=bash noet

# source the deps functions
. ${engine_lib_dir}/deps.sh

# Copy the code into the live directory which will be used to run the app
publish_release() {
  nos_print_bullet "Moving build into live app directory..."
  rsync -a $(nos_code_dir)/ $(nos_app_dir)
}

# Determine the python runtime to install. This will first check
# within the boxfile.yml, then will rely on default_runtime to
# provide a sensible default
runtime() {
  echo $(nos_validate \
    "$(nos_payload "config_runtime")" \
    "string" "$(default_runtime)")
}

# Provide a default python version.
default_runtime() {
  echo "python-2.7"
}

# The pip package will look something like py27-pip so
# we need to fetch the condensed runtime to use for the package
condensed_runtime() {
  version=$(runtime)
  echo "${version//[.thon-]/}"
}

# In the data directory, the dir will look like python2.7 so
# we need to fetch to lib runtime whenever we're messing with libs
lib_runtime() {
  version=$(runtime)
  echo "${version//[-]/}"
}

# Install the python runtime along with any dependencies.
install_runtime_packages() {
  pkgs=("$(runtime)" \
        "$(condensed_runtime)-setuptools" \
        "$(condensed_runtime)-pip")
  
  # add packages that are usually part of the stdlib
  pkgs+=(\
    "$(condensed_runtime)-cElementTree" \
    "$(condensed_runtime)-curses" \
    "$(condensed_runtime)-expat" \
    "$(condensed_runtime)-readline" \
    "$(condensed_runtime)-sqlite3")
  
  # add any client dependencies
  pkgs+=("$(query_dependencies)")

  nos_install ${pkgs[@]}
}

# Uninstall build dependencies
uninstall_build_packages() {
  pkgs=("$(condensed_runtime)-pip")

  # if pkgs isn't empty, let's uninstall what we don't need
  if [[ ${#pkgs[@]} -gt 0 ]]; then
    nos_uninstall ${pkgs[@]}
  fi
}

# Here we get to be a bit clever. Python will store it's cache (deps, etc)
# in the site-packages dir. Changing this is not easily configurable, so we'll
# essentially setup a cache dir in ~/.nanobox/pip_cache, and symlink
# the site-packages to the cached location. Also, we'll copy anything
# into the cache on the first run.
# 
# Additionally, we'll set some environment variables specifically for python
setup_python_env() {
  # ensure python doesn't buffer even when not attached to a pty
  nos_template_file \
    "env.d/PYTHONUNBUFFERED" \
    "$(nos_etc_dir)/env.d/PYTHONUNBUFFERED"
    
  # Ensure the cache destination exists for site-packages
  if [[ ! -d "$(nos_code_dir)/.nanobox/pip_cache/site-packages" ]]; then
    mkdir -p "$(nos_code_dir)/.nanobox/pip_cache/site-packages"
  fi
  
  # If anything exists before we symlink, copy it into the cache
  if [[ -d "$(nos_data_dir)/lib/$(lib_runtime)/site-packages" ]]; then
    mv \
      "$(nos_data_dir)/lib/$(lib_runtime)/site-packages/*" \
      "$(nos_code_dir)/.nanobox/pip_cache/site-packages"
  fi
  
  # set the profile script that correctly sets up the links
  set_python_profile_script
}

# Generate the payload to render the python profile template
python_profile_payload() {
  cat <<-END
{
  "code_dir": "$(nos_code_dir)",
  "data_dir": "$(nos_data_dir)",
  "runtime": "$(lib_runtime)"
}
END
}

# Profile script to ensure symlinks for pip
set_python_profile_script() {
  mkdir -p "$(nos_etc_dir)/profile.d"
  nos_template \
    "profile.d/pip.sh" \
    "$(nos_etc_dir)/profile.d/pip.sh" \
    "$(python_profile_payload)"
}

# fetch the user-specified pip install command or use a default
pip_install_cmd() {
  echo $(nos_validate \
    "$(nos_payload "config_pip_install")" \
    "string" "$(default_pip_install)")
}

# the default pip install cmd when a user-specified cmd is not present
default_pip_install() {
  echo "pip install -I -r requirements.txt"
}

# Install dependencies via pip from requirements.txt
pip_install() {
  if [[ -f $(nos_code_dir)/requirements.txt ]]; then
    cd $(nos_code_dir)
    nos_run_process "Running pip install" \
      "$(pip_install_cmd)"
    cd - >/dev/null
  fi
}
