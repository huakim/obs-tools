Name: obs-tools
Version: 2
Release: 0
License: LGPL
Summary: %{name}
BuildArch: noarch

Source0: obs_service_run.pl
Source1: obs_service_list.pl
Source2: obs_copr_build.sh
Source3: obs_dnf_install.sh
Source4: obs_git_build.sh

Requires: (%{_bindir}/perl or perl-interpreter or perl)
Requires: cpio
%global _use_internal_dependency_generator 0
%global __find_requires %{_rpmconfigdir}/perl.req

%description
%{summary}.

%install
install -Dm755 %{SOURCE0} %{buildroot}%{_bindir}/obs_service_run
install -Dm755 %{SOURCE1} %{buildroot}%{_bindir}/obs_service_list
install -Dm755 %{SOURCE2} %{buildroot}%{_bindir}/obs_copr_build
install -Dm755 %{SOURCE3} %{buildroot}%{_bindir}/obs_pkg_install
install -Dm755 %{SOURCE4} %{buildroot}%{_bindir}/obs_git_build

%files
%attr(755, root, root) %{_bindir}/obs_service_run
%attr(755, root, root) %{_bindir}/obs_service_list

%package copr
Summary: %{name}
Requires: %{name}-pkg
Requires: (%{_bindir}/rpmbuild or rpm-build or rpmbuild)

%description copr
%{summary}.

%files copr
%attr(755, root, root) %{_bindir}/obs_copr_build

%package pkg
Summary: %{name}
Requires: %{name}
Requires: (dnf or dnf5 or microdnf or zypper or apt-rpm or %{_bindir}/dnf or %{_bindir}/dnf5 or %{_bindir}/microdnf or %{_bindir}/zypper or %{_bindir}/apt-rpm)
Requires: (%{_bindir}/bash or bash)

%description pkg
%{summary}.

%files pkg
%attr(755, root, root) %{_bindir}/obs_pkg_install

%package git
Summary: %{name}
Requires: %{name}-pkg
Requires: (%{_bindir}/git or git)

%description git
%{summary}.

%files git
%attr(755, root, root) %{_bindir}/obs_git_build
