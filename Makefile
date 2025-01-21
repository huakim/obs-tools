outdir ?= $(shell rpm --eval '%{_srcrpmdir}')

srpm:
	bash -x .copr/copr_fedora_install.sh || :
	bash -x .copr/copr_fedora_make_srpm.sh
	rpmbuild -D'%_srcrpmdir $(outdir)' -D'_sourcedir .osc.temp/_output_dir' -bs .osc.temp/_output_dir/*.spec
