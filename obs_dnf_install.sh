#!/bin/bash
declare -a AR
AR=()
for i in $(obs_service_list)
do
   AR+=(obs-service-"$i")
done

for i in dnf dnf5 zypper microdnf apt-rpm;
do
  if command -v "${i}"; then
    "${i}" install -y "${AR[@]}"
    break
  fi
done
