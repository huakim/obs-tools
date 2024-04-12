Name: obs-tools
Version: 2
Release: 0
License: LGPL
Summary: %{name}
BuildArch: noarch

Source0: obs_service_run.pl
Source1: obs_service_list.pl
Requires: (/usr/bin/perl or perl-interpreter or perl)
%global _use_internal_dependency_generator 0
%global __find_requires %{_rpmconfigdir}/perl.req

%description
%{summary}.

%install
install -Dm755 %{SOURCE0} %{buildroot}%{_bindir}/obs_service_run
install -Dm755 %{SOURCE1} %{buildroot}%{_bindir}/obs_service_list

%files
%attr(755, root, root) %{_bindir}/*

