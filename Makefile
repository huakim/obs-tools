outdir ?= $(shell rpm --eval '%{_srcrpmdir}')

srpm:
	.copr/copr_fedora_install.sh
	.copr/copr_fedora_make_srpm.sh
	rpmbuild -D'%_srcrpmdir $(outdir)' -D'_sourcedir .osc.temp/_output_dir' -bs .osc.temp/_output_dir/*.spec
