pushd "$(realpath $(dirname $0))/"
temp_dir="$(mktemp -d)"
mkdir "${temp_dir}/SOURCES"
dnf install -y sed perl-generators rpm-build
cp * "${temp_dir}/SOURCES/"
rpmbuild "-DONLY_PACKAGE_MANAGERS $(basename $(realpath $(which dnf)))" "-DNO_COPR_TOOLS yes" "-D_topdir ${temp_dir}" --bb "${temp_dir}/SOURCES/obs-tools.spec"
dnf install -y "${temp_dir}/RPMS"/noarch/*.noarch.rpm
popd
