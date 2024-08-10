# SPDX-License-Identifier: Apache-2.0
# Copyright Contributors to the Rez Project


"""
Rez configuration settings.

Settings are determined in the following way (higher number means higher
precedence):

1) The setting is first read from the rez installation config file;
2) The setting is then overridden if it is present in another settings file(s)
   pointed at by the $REZ_CONFIG_FILE environment variable. Note that multiple
   files are supported, separated by os.pathsep;
3) The setting is further overriden if it is present in $HOME/.rezconfig,
  UNLESS $REZ_DISABLE_HOME_CONFIG is 1;
4) The setting is overridden again if the environment variable $REZ_XXX is
   present, where XXX is the uppercase version of the setting key. For example,
   "image_viewer" will be overriden by $REZ_IMAGE_VIEWER. List values can be
   separated either with "," or blank space. Dict values are in the form
   "k1:v1,k2:v2,kn:vn";
5) The setting can also be overriden by the environment variable $REZ_XXX_JSON,
   and in this case the string is expected to be a JSON-encoded value;
6) This is a special case applied only during a package build or release. In
   this case, if the package definition file contains a "config" section,
   settings in this section will override all others.

Note that in the case of plugin settings (anything under the "plugins" section
of the config), (4) and (5) do not apply.

Variable expansion can be used in configuration settings. The following
expansions are supported:
- Any property of the system object: Eg "{system.platform}" (see system.py)
- Any environment variable: Eg "${HOME}"

The following variables are provided if you are using rezconfig.py files:
- 'rez_version': The current version of rez.

Paths should use the path separator appropriate for the operating system
(based on Python's os.path.sep).  So for Linux paths, / should be used. On
Windows \ (unescaped) should be used.

"""

# flake8: noqa

import os
import platform


###############################################################################
# Variables
###############################################################################

# Maps for different paths per platform
_path_map = {
    "darwin": "/Volumes/z/Applications_and_Programs/Academy_Software_Foundation-rez",
    "Linux": "/mnt/z/Applications_and_Programs/Academy_Software_Foundation-rez",
    "Windows": "Z:/Applications_and_Programs/Academy_Software_Foundation-rez",
}

_path_map_local = {
    "darwin": "/mnt/c/rez",
    "Linux": "/mnt/c/rez",
    "Windows": "C:/rez",
}


###############################################################################
# Paths
###############################################################################

# The path that Rez will locally install packages to when rez-build is used
local_packages_path = "~/packages"

# The package search path. Rez uses this to find packages. A package with the
# same name and version in an earlier path takes precedence.
packages_path = [
    local_packages_path,
    f"{_path_map[platform.system()]}/packages/core",
    f"{_path_map[platform.system()]}/packages/pip",
    f"{_path_map[platform.system()]}/packages/third-party",
]

# The path that Rez will deploy packages to when :ref:`rez-release` is used. For
# production use, you will probably want to change this to a site-wide location.
release_packages_path = f"{_path_map[platform.system()]}/packages/core"

# Where temporary files go. Defaults to appropriate path depending on your
# system. For example, \*nix distributions will probably set this to :file:`/tmp`. It
# is highly recommended that this be set to local storage, such as :file:`/tmp`.
tmpdir = f"{_path_map_local[platform.system()]}/tmp"


###############################################################################
# Package Caching
#
# Package caching refers to copying variant payloads to a path on local
# disk, and using those payloads instead. It is a way to avoid fetching files
# over shared storage, and is unrelated to memcached-based caching of resolves
# and package definitions as seen in the "Caching" config section.
#
###############################################################################

# Whether a package is cachable or not, if it does not explicitly state with
# the :attr:`cachable` attribute in its package definition file. If None, defaults
# to packages' relocatability (ie cachable == relocatable).
default_cachable = None

# The path where rez locally caches variants. If this is None, then package
# caching is disabled.
cache_packages_path = f"{_path_map_local[platform.system()]}/packages_cache"


###############################################################################
# Package Resolution
###############################################################################

# Override platform values from Platform.os and arch.
# This is useful as Platform.os might show different
# values depending on the availability of ``lsb-release`` on the system.
# The map supports regular expression, e.g. to keep versions.
# 
# .. note::
#    The following examples are not necessarily recommendations.
#
# .. code-block:: python
#
#    platform_map = {
#        "os": {
#            r"Scientific Linux-(.*)": r"Scientific-\1",                 # Scientific Linux-x.x -> Scientific-x.x
#            r"Ubuntu-14.\d": r"Ubuntu-14",                              # Any Ubuntu-14.x      -> Ubuntu-14
#            r'CentOS Linux-(\d+)\.(\d+)(\.(\d+))?': r'CentOS-\1.\2', '  # Centos Linux-X.Y.Z -> CentOS-X.Y
#        },
#        "arch": {
#            "x86_64": "64bit",                                          # Maps both x86_64 and amd64 -> 64bit
#            "amd64": "64bit",
#        },
#    }
platform_map = {
    "x86_64": "64bit",  # Linux
    "AMD64": "64bit",  # Windows
}

# One or more filters can be listed, each with a list of
# exclusion and inclusion rules. These filters are applied to each package
# during a resolve, and if any filter excludes a package, that package is not
# included in the resolve. Here is a simple example:
#
# .. code-block:: python
#
#    package_filter = {
#        'excludes': 'glob(*.beta)',
#        'includes': 'glob(foo-*)',
#    }
#
# This is an example of a single filter with one exclusion rule and one inclusion
# rule. The filter will ignore all packages with versions ending in ``.beta``,
# except for package ``foo`` (which it will accept all versions of). A filter will
# only exclude a package if that package matches at least one exclusion rule,
# and does not match any inclusion rule.
#
# Here is another example, which excludes all beta and dev packages, and all
# packages except ``foo`` that are released after a certain date. Note that in
# order to use multiple filters, you need to supply a list of dicts, rather
# than just a dict:
#
# .. code-block:: python
#
#    package_filter = [
#        {
#            'excludes': ['glob(*.beta)', 'glob(*.dev)']
#        },
#        {
#            'excludes': ['after(1429830188)'],
#            'includes': ['foo'],  # same as range(foo), same as glob(foo-*)
#        }
#    ]
#
# This example shows why multiple filters are supported. With only one filter,
# it would not be possible to exclude all beta and dev packages (including foo),
# but also exclude all packages after a certain date, except for foo.
#
# Following are examples of all the possible rules:
#
# ======================== ====================================================
# Example                  Description
# ======================== ====================================================
# ``glob(*.beta)``         Matches packages matching the glob pattern.
# ``regex(.*-\\.beta)``    Matches packages matching re-style regex.
# ``range(foo-5+)``        Matches packages within the given requirement.
# ``before(1429830188)``   Matches packages released before the given date.
# ``after(1429830188)``    Matches packages released after the given date.
# ``*.beta``               Same as glob(\*.beta).
# ``foo-5+``               Same as range(foo-5+).
# ======================== ====================================================
package_filter = [
    {
        "excludes": [
            "glob(*.dev)",
            "glob(*.dev.*)",
        ]
    }
]

# If True, unversioned packages are allowed. Solve times are slightly better if
# this value is False.
allow_unversioned_packages = False


###############################################################################
# Environment Resolution
###############################################################################

# Rez's default behaviour is to overwrite variables on first reference. This
# prevents unconfigured software from being used within the resolved environment.
# For example, if PYTHONPATH were to be appended to and not overwritten, then
# python modules from the parent environment would be (incorrectly) accessible
# within the Rez environment.
#
# "Parent variables" override this behaviour. They are appended/prepended to,
# rather than being overwritten. If you set :data:`all_parent_variables` to :data:`True`, then
# all variables are considered parent variables, and the value of :data:`parent_variables`
# is ignored. Be aware that if you make variables such as ``PATH``, :envvar:`PYTHONPATH` or
# app plugin paths parent variables, you are exposing yourself to potentially
# incorrect behaviour within a resolved environment.
#parent_variables = [
#    "PATH",
#]

# The default shell type to use when creating resolved environments (eg when using
# :ref:`rez-env`, or calling :meth:`.ResolvedContext.execute_shell`). If empty or None, the
# current shell is used (for eg, "bash").
#
# .. versionchanged:: 3.0.0
#    The default value on Windows was changed to "powershell".
#default_shell = ""

# Defines paths to initially set ``$PATH`` to, if a resolve appends/prepends ``$PATH``.
# If this is an empty list, then this initial value is determined automatically
# depending on the shell (for example, \*nix shells create a temp clean shell and
# get ``$PATH`` from there; Windows inspects its registry).
#standard_system_paths = []


###############################################################################
# Debugging
###############################################################################

# Turn on all debugging messages
#debug_all = True

# Turn off all debugging messages. This overrides :data:`debug_all`.
debug_none = True


###############################################################################
# Package Build/Release
###############################################################################

# The release hooks to run when a release occurs. Release hooks are plugins. If
# a plugin listed here is not present, a warning message is printed. Note that a
# release hook plugin being loaded does not mean it will run. It needs to be
# listed here as well. Several built-in release hooks are available, see
# :gh-rez:`src/rezplugins/release_hook`.
release_hooks = [
    "emailer",
]

# Prompt for release message using an editor. If set to False, there will be
# no editor prompt.
if not os.getenv("CI"):  # No prompt during GitLab CI as to not accidentally prevent release
    prompt_release_message = True


###############################################################################
# Appearance
###############################################################################

# The viewer used to view file diffs. On macOS, set this to ``open -a <your-app>``
# if you want to use a specific app.
difftool = "delta"


###############################################################################
# Misc
###############################################################################

# A dict type config for storing arbitrary data that can be
# accessed by the :func:`optionvars` function in packages
# :func:`commands`.
#
# This is like user preferences for packages, which may not easy to define in
# package's definition file directly due to the differences between machines/users/pipeline-roles.
#
# Example:
#
# .. code-block:: python
#
#    # in your rezconfig.py
#    optionvars = {
#        "userRoles": ["artist"]
#    }
#
# And to access:
#
# .. code-block:: python
#
#    # in package.py
#    def commands():
#        roles = optionvars("userRoles", default=None) or []
#        if "artist" in roles:
#            env.SOMETHING_FRIENDLY = "Yes"
#
# Note that you can refer to values in nested dicts using dot notation:
#
# .. code-block:: python
#
#    def commands():
#        if optionvars("nuke.lighting_tools_enabled"):
#            ...
optionvars = {
    "locations": ["home",],
    "departments": ["pipeline", "supervision",],
}


###############################################################################
# Plugin Settings
###############################################################################

# Settings specific to certain plugin implementations can be found in the
# "rezconfig" file accompanying that plugin. The settings listed here are
# common to all plugins of that type.

plugins = {
    "release_vcs": {
        "check_tag": True,
    },
    "build_system": {
        "cmake": {
            "install_pyc": False,
        },
    },
    "release_hook": {
        "emailer": {
            "smtp_host": "smtp",
            "sender": "pipeline@.com",
            "recipients": "pipeline@.com",
        },
    },
}
