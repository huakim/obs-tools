#!/bin/sh
if [[ -z "${NO_SERVICE_RUN}" ]]; then
  obs_local_run
  obs_service_run
fi
pushd .osc.temp/_output_dir
rpmbuild "-D_sourcedir $PWD" "${@}" *.spec
popd
