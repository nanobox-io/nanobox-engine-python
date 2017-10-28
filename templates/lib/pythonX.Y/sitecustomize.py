"""
`Site customizations`__ for running Python on nanobox.

The idea is to make builds faster by storing site-packages, pip caches, and
virtualenvs with the /app rather than in /data.

The trick is to make it so 1) everything gets installed to that location by
default, yet 2) virtualenvs (virtualenv, pipenv, python -m venv) still work
as expected without developers changing the way the interact with pip,
virtualenv, or pipenv.

.. __: https://docs.python.org/3.6/library/site.html
"""
import os
import site
import sys


# Different virtualenv libraries and different versions of Python handle
# tracking system and virtualenv prefixes in different ways. (Some use
# base_prefix, others real_prefix.) This logic lets us reliably figure out if
# the interpreter is running in a virtualenv.
BASE = getattr(sys, 'base_prefix', None)
REAL = getattr(sys, 'real_prefix', None)
IN_VENV = (REAL is not None and REAL != sys.prefix or
           BASE is not None and BASE != sys.prefix)

NANO = '{{pycache}}'
NANO_PKGS = os.path.join(NANO, 'lib/{{pydirname}}/site-packages')

if not IN_VENV:
    site.PREFIXES.append(NANO)
    site.addsitedir(NANO_PKGS)

    # Only tell pip where to install src checkouts when not in a virtualenv;
    # we don't want virtualenvs and/or system installs clobbering each other.
    os.environ.setdefault('PIP_SRC', '{{pycache}}/pip/src')

# These should be set anytime the interpreter is run because they benefit every
# environment without clobbering each other.
os.environ.setdefault('PIP_CACHE_DIR', '{{pycache}}/pip/cache')
os.environ.setdefault('WORKON_HOME', '{{pycache}}/venvs')
