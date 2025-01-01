Name: obs-tools
Version: 12
Release: 1
License: LGPL
Summary: %{name}
BuildArch: noarch
BuildRequires: (rpm-build-perl or perl-generators or %{_rpmconfigdir}/perl.req)
BuildRequires: (sed or %{_bindir}/sed)
Source0: obs_service_run.pl
Source1: obs_service_list.pl
Source2: obs_copr_build.pl
Source3: obs_dnf_install.sh
Source4: obs_git_build.sh
Source5: obs_service_build.sh
Source6: obs_local_run.pl
Source7: pkg_check_available.sh
Source8: obs_service_pkg_list.sh

Requires: (%{_bindir}/perl or perl-interpreter or perl)
Requires: cpio
Requires: sed

%global __perl_requires %{_rpmconfigdir}/perl.req

#(echo -e "{SOURCE0}\n{SOURCE1}" | '{_rpmconfigdir}/perl.req' | sed 's~^~Requires: ~' )

%description
%{summary}.

%install
install -Dm755 %{SOURCE0} %{buildroot}%{_bindir}/obs_service_run
install -Dm755 %{SOURCE1} %{buildroot}%{_bindir}/obs_service_list
install -Dm755 %{SOURCE8} %{buildroot}%{_bindir}/obs_service_pkg_list
install -Dm755 %{SOURCE2} %{buildroot}%{_bindir}/obs_copr_build
%{lua:
for key, value in pairs({ dnf = 'provides', dnf5 = 'provides', zypper = 'search --provides --match-exact', microdnf = 'provides' })
do
rpm.define('pkg_manager_name '..key)
rpm.define('pkg_manager_provides '..key..' '..value)
print( rpm.expand( [[
  cat %{SOURCE3} | sed "s/dnf/%{pkg_manager_name}/g;" > %{buildroot}%{_bindir}/obs_"%{pkg_manager_name}"_install
  chmod 755 %{buildroot}%{_bindir}/obs_"%{pkg_manager_name}"_install

  cat %{SOURCE7} | sed "s/dnf provides/%{pkg_manager_provides}/g;" > %{buildroot}%{_bindir}/"%{pkg_manager_name}_check_available"
  chmod 755 %{buildroot}%{_bindir}/"%{pkg_manager_name}_check_available"
]] ))
end
}
install -Dm755 %{SOURCE4} %{buildroot}%{_bindir}/obs_git_build
install -Dm755 %{SOURCE5} %{buildroot}%{_bindir}/obs_service_build
install -Dm755 %{SOURCE6} %{buildroot}%{_bindir}/obs_local_run

%files
%attr(755, root, root) %{_bindir}/obs_service_run
%attr(755, root, root) %{_bindir}/obs_service_list
%attr(755, root, root) %{_bindir}/obs_local_run
%attr(755, root, root) %{_bindir}/obs_service_pkg_list

%package copr
Summary: %{name}
Requires: %{name}-pkg
Requires: %{name}-build
Requires: (%{_bindir}/rpmbuild or rpm-build or rpmbuild)

%description copr
%{summary}.

%files copr
%attr(755, root, root) %{_bindir}/obs_copr_build

%{lua:
pkgs = {'dnf', 'dnf5', 'microdnf', 'zypper'}
for _, p in ipairs(pkgs)
do
rpm.define("pkg_manager_name "..p)
print(rpm.expand([[

%%package %{pkg_manager_name}-pkg
Provides: %{name}-pkg
Summary: %{name}
Requires: %{name}
Requires: (%{pkg_manager_name} or %{_bindir}/%{pkg_manager_name})
Requires: (%{_bindir}/bash or bash)

%%description %{pkg_manager_name}-pkg
%{summary}.

%%post %{pkg_manager_name}-pkg
%{_sbindir}/update-alternatives --install '%{_bindir}/obs_pkg_install' obs_pkg_install '%{_bindir}/obs_%{pkg_manager_name}_install' 25

%%postun %{pkg_manager_name}-pkg
%{_sbindir}/update-alternatives --remove obs_pkg_install '%{_bindir}/obs_%{pkg_manager_name}_install' || :

%%files %{pkg_manager_name}-pkg
%%attr(755, root, root) %{_bindir}/obs_%{pkg_manager_name}_install


%%package %{pkg_manager_name}-pkg-checkaval
Provides: %{name}-pkg-checkaval
Summary: %{name}
Requires: (%{pkg_manager_name} or %{_bindir}/%{pkg_manager_name})
Requires: (%{_bindir}/bash or bash)

%%description %{pkg_manager_name}-pkg-checkaval
%{summary}.

%%post %{pkg_manager_name}-pkg-checkaval
%{_sbindir}/update-alternatives --install '%{_bindir}/pkg_check_available' pkg_check_available '%{_bindir}/%{pkg_manager_name}_check_available' 25

%%postun %{pkg_manager_name}-pkg-checkaval
%{_sbindir}/update-alternatives --remove pkg_check_available '%{_bindir}/%{pkg_manager_name}_check_available' || :

%%files %{pkg_manager_name}-pkg-checkaval
%%attr(755, root, root) %{_bindir}/%{pkg_manager_name}_check_available

]]))
end
}

%package git
Summary: %{name}
Requires: %{name}-pkg
Requires: (%{_bindir}/git or git)

%description git
%{summary}.

%files git
%attr(755, root, root) %{_bindir}/obs_git_build

%package build
Summary: %{name}
Requires: %{name}
Requires: rpm-build

%description build
%{summary}.

%files build
%attr(755, root, root) %{_bindir}/obs_service_build









