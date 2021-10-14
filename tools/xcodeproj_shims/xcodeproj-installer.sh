#!/bin/bash

# Copies the xcodeproject from the bazel output directory to the BAZEL_WORKSPACE directory when ran
set -euo pipefail
readonly project_path="${PWD}/$(project_short_path)"
readonly dest="${BUILD_WORKSPACE_DIRECTORY}/$(project_short_path)/"
readonly tmp_dest=$(mktemp -d)/$(project_full_path)/

readonly installer="$(installer_short_path)"

rm -fr "${tmp_dest}"
mkdir -p "$(dirname $tmp_dest)"
cp -r "${project_path}" "$tmp_dest"
chmod -R +w "${tmp_dest}"

readonly stubs_dir="${tmp_dest}/bazelstubs"
mkdir -p "${stubs_dir}"

readonly installers_dir="${tmp_dest}/bazelinstallers"
mkdir -p "${installers_dir}"

readonly print_json_installers_dir="${stubs_dir}/print_json_leaf_nodes.runfiles/"
mkdir -p "${print_json_installers_dir}"

# The new build system leaves a subdirectory called XCBuildData in the DerivedData directory which causes incremental build and test attempts to fail at launch time.
# The error message says "Cannot attach to pid." This error seems to happen in the Xcode IDE, not when the project is tested from the xcodebuild command.
# Therefore, we force xcode to use the legacy build system by adding the contents of WorkspaceSettings.xcsettings to the generated project.
mkdir -p "$tmp_dest/project.xcworkspace/xcshareddata/"
# cp "$(workspacesettings_xcsettings_short_path)" "$tmp_dest/project.xcworkspace/xcshareddata/"

chmod -R +w "${tmp_dest}"

# if installing into the root of the workspace, remove the path entry entirely
sed -i.bak -E -e 's|^([[:space:]]*path = )../../..;$|\1.;|g' "${tmp_dest}/project.pbxproj"
# always trim three ../ from path, since that's "bazel-out/darwin-fastbuild/bin"
sed -i.bak -E -e 's|([ "])../../../|\1|g' "${tmp_dest}/project.pbxproj"
rm "${tmp_dest}/project.pbxproj.bak"

mkdir -p "$(dirname "${dest}")"
rsync --recursive --quiet --copy-links "${tmp_dest}" "${dest}"
