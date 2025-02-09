REPOSDIR="${PWD}/.osc.temp/_reposdir"
mkdir -p "${REPOSDIR}"
typeset -i REPOS_ORDER=0
obs_repos_list | while IFS= read -r line; do
    curl -o "${REPOSDIR}/repo_${REPOS_ORDER}.repo" "${line}"
    REPOS_ORDER+=1
done
dnf install --setopt=reposdir="${REPOSDIR}" -y obs-build `obs_service_pkg_list`
obs_local_run
obs_service_run
