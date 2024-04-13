#!/bin/bash
declare -a AR
AR=()
for i in $(obs_service_list)
do
   AR+=(obs-service-"$i")
done

for i in dnf dnf5 zypper microdnf apt-rpm do
  pkg="$(command -v $i)"
  if [[ -n "${pkg}" ]]; then
    ${pkg} install -y "${AR[@]}"
    break
  fi
done
