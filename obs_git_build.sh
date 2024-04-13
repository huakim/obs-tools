#!/bin/bash
url="$1"
if [[ -z "$2" ]]
then
name="$(echo $1 | sed 's~.*/~~; s~.git$~~;')"
else
name="$2"
fi
outdir="${3:-_output_dir}"
git clone --depth 1 "$url" "$name"

pushd "$name"
obs_pkg_install
obs_service_run
cp -R .osc/_output_dir "../${outdir}"
popd
