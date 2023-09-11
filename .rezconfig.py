# rez-2.103.4
# Copyright Contributors to the Rez project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


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
import sys


###############################################################################
# Variables
###############################################################################

_tmp_path_map = {
    "darwin": "/var/tmp/rez/",
    "linux": "/var/tmp/rez/",
    "linux2": "/var/tmp/rez/",
    #"win32": "C:/rez/",
}


###############################################################################
# Paths
###############################################################################

# Map for different paths per platform
_path_map = {
    # MacOS
    "darwin": "/Volumes/z/Applications_and_Programs/rez/",
    # Linux
    "linux": "/mnt/z/rez/",
    "linux2": "/mnt/z/rez/",
    # Windows
    "win32": "Z:/Applications_and_Programs/rez/",
}

# The path that Rez will locally install packages to when rez-build is used
local_packages_path = "~/packages"

# The package search path. Rez uses this to find packages. A package with the
# same name and version in an earlier path takes precedence.
packages_path = [
    local_packages_path,
    "{}/packages/core".format(_path_map[sys.platform]),
    "{}/packages/pip".format(_path_map[sys.platform]),
    "{}/packages/third-party".format(_path_map[sys.platform]),
]

# The path that Rez will deploy packages to when rez-release is used. For
# production use, you will probably want to change this to a site-wide location.
release_packages_path = "{}/packages/core".format(_path_map[sys.platform])

# Where temporary files go. Defaults to appropriate path depending on your
# system - for example, *nix distributions will probably set this to "/tmp". It
# is highly recommended that this be set to local storage, such as /tmp.
tmpdir = "{}".format(_tmp_path_map[sys.platform])


###############################################################################
# Package Caching
#
# Note: "package caching" refers to copying variant payloads to a path on local
# disk, and using those payloads instead. It is a way to avoid fetching files
# over shared storage, and is unrelated to memcached-based caching of resolves
# and package definitions as seen in the "Caching" config section.
#
###############################################################################

# Whether a package is cachable or not, if it does not explicitly state with
# the 'cachable' attribute in its package definition file. If None, defaults
# to packages' relocatability (ie cachable will == relocatable).
default_cachable = None

# The path where rez locally caches variants. If this is None, then package
# caching is disabled.
cache_packages_path = "{}/packages_cache".format(_tmp_path_map[sys.platform])


###############################################################################
# Package Resolution
###############################################################################

# Override platform values from Platform.os and arch.
# This is useful as Platform.os might show different
# values depending on the availability of lsb-release on the system.
# The map supports regular expression e.g. to keep versions.
# Please note that following examples are not necessarily recommendations.
#
#     platform_map = {
#         "os": {
#             r"Scientific Linux-(.*)": r"Scientific-\1",                 # Scientific Linux-x.x -> Scientific-x.x
#             r"Ubuntu-14.\d": r"Ubuntu-14",                              # Any Ubuntu-14.x      -> Ubuntu-14
#             r'CentOS Linux-(\d+)\.(\d+)(\.(\d+))?': r'CentOS-\1.\2', '  # Centos Linux-X.Y.Z -> CentOS-X.Y
#         },
#         "arch": {
#             "x86_64": "64bit",                                          # Maps both x86_64 and amd64 -> 64bit
#             "amd64": "64bit",
#         },
#     }
platform_map = {
    "x86_64": "64bit",  # Linux
    "AMD64": "64bit",  # Windows
}

# Package filter. One or more filters can be listed, each with a list of
# exclusion and inclusion rules. These filters are applied to each package
# during a resolve, and if any filter excludes a package, that package is not
# included in the resolve. Here is a simple example:
#
#     package_filter:
#         excludes:
#         - glob(*.beta)
#         includes:
#         - glob(foo-*)
#
# This is an example of a single filter with one exclusion rule and one inclusion
# rule. The filter will ignore all packages with versions ending in '.beta',
# except for package 'foo' (which it will accept all versions of). A filter will
# only exclude a package iff that package matches at least one exclusion rule,
# and does not match any inclusion rule.
#
# Here is another example, which excludes all beta packages, and all packages
# except 'foo' that are released after a certain date. Note that in order to
# use multiple filters, you need to supply a list of dicts, rather than just a
# dict:
#
#     package_filter:
#     - excludes:
#       - glob(*.beta)
#     - excludes:
#       - after(1429830188)
#       includes:
#       - foo  # same as range(foo), same as glob(foo-*)
#
# This example shows why multiple filters are supported - with only one filter,
# it would not be possible to exclude all beta packages (including foo), but also
# exclude all packages after a certain date, except for foo.
#
# Following are examples of all the possible rules:
#
# example             | description
# --------------------|----------------------------------------------------
# glob(*.beta)        | Matches packages matching the glob pattern.
# regex(.*-\\.beta)   | Matches packages matching re-style regex.
# requirement(foo-5+) | Matches packages within the given requirement.
# before(1429830188)  | Matches packages released before the given date.
# after(1429830188)   | Matches packages released after the given date.
# *.beta              | Same as glob(*.beta)
# foo-5+              | Same as range(foo-5+)
package_filter = dict(
    excludes = [
        "*.dev",
        "*.dev.*"
    ]
)

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
# "Parent variables" override this behaviour - they are appended/prepended to,
# rather than being overwritten. If you set "all_parent_variables" to true, then
# all variables are considered parent variables, and the value of "parent_variables"
# is ignored. Be aware that if you make variables such as PATH, PYTHONPATH or
# app plugin paths parent variables, you are exposing yourself to potentially
# incorrect behaviour within a resolved environment.
#parent_variables = [
#    "PATH",
#]

# Defines paths to initially set $PATH to, if a resolve appends/prepends $PATH.
# If this is an empty list, then this initial value is determined automatically
# depending on the shell (for example, *nix shells create a temp clean shell and
# get $PATH from there; Windows inspects its registry).
#standard_system_paths = []


###############################################################################
# Debugging
###############################################################################

# Turn on all warnings
warn_all = False

# Turn on all debugging messages
#debug_all = True
debug_none = True


###############################################################################
# Package Build/Release
###############################################################################
# The release hooks to run when a release occurs. Release hooks are plugins - if
# a plugin listed here is not present, a warning message is printed. Note that a
# release hook plugin being loaded does not mean it will run - it needs to be
# listed here as well. Several built-in release hooks are available, see
# rezplugins/release_hook.
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

# The viewer used to view file diffs. On osx, set this to "open -a <your-app>"
# if you want to use a specific app.
difftool = "meld"


###############################################################################
# Misc
###############################################################################

# Optional variables. A dict type config for storing arbitrary data that can be
# accessed by the [optionvars](Package-Commands#optionvars) function in packages
# *commands*.
#
# This is like user preferences for packages, which may not easy to define in
# package's definition file directly due to the differences between machines/
# users/pipeline-roles.
#
# Example:
#
#     # in your rezconfig.py
#     optionvars = {
#         "userRoles": ["artist"]
#     }
#
# And to access:
#
#     # in package.py
#     def commands():
#         roles = optionvars("userRoles", default=None) or []
#         if "artist" in roles:
#             env.SOMETHING_FRIENDLY = "Yes"
#
# Note that you can refer to values in nested dicts using dot notation:
#
#     def commands():
#         if optionvars("nuke.lighting_tools_enabled"):
#             ...
#
optionvars = {
    "locations": ["home",],
    "departments": ["pipeline", "supervision",],
}


###############################################################################
# Rez-1 Compatibility
###############################################################################

# Warn or disallow when a package is found to contain old rez-1-style commands.
warn_old_commands = False

# If True, Rez will continue to generate the given environment variables in
# resolved environments, even though their use has been deprecated in Rez-2.
# The variables in question, and their Rez-2 equivalent (if any) are:
#
# REZ-1              | REZ-2
# -------------------|-----------------
# REZ_REQUEST        | REZ_USED_REQUEST
# REZ_RESOLVE        | REZ_USED_RESOLVE
# REZ_VERSION        | REZ_USED_VERSION
# REZ_PATH           | REZ_USED
# REZ_RESOLVE_MODE   | not set
# REZ_RAW_REQUEST    | not set
# REZ_IN_REZ_RELEASE | not set
rez_1_environment_variables = False

# If True, Rez will continue to generate the given CMake variables at build and
# release time, even though their use has been deprecated in Rez-2.  The
# variables in question, and their Rez-2 equivalent (if any) are:
#
# REZ-1   | REZ-2
# --------|---------------
# CENTRAL | REZ_BUILD_TYPE
rez_1_cmake_variables = False

# If True, override all compatibility-related settings so that Rez-1 support is
# deprecated. This means that:
# * All warn/error settings in this section of the config will be set to
#   warn=False, error=True;
# * rez_1_environment_variables will be set to False.
# * rez_1_cmake_variables will be set to False.
# You should aim to do this - it will mean your packages are more strictly
# validated, and you can more easily use future versions of Rez.
disable_rez_1_compatibility = True


###############################################################################
# Plugin Settings
###############################################################################

# Settings specific to certain plugin implementations can be found in the
# "rezconfig" file accompanying that plugin. The settings listed here are
# common to all plugins of that type.

plugins = dict(
    release_hook=dict(
        emailer=dict(
            smtp_host="smtp",
            sender="pipeline@.com",
            recipients="pipeline@.com",
        ),
    ),
    build_system=dict(
        cmake=dict(
            install_pyc=False
        )
    ),
    release_vcs=dict(
        check_tag=True
    )
)
