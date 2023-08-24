#COLORS
GREEN  := $(shell tput -Txterm setaf 2)
WHITE  := $(shell tput -Txterm setaf 7)
YELLOW := $(shell tput -Txterm setaf 3)
RESET  := $(shell tput -Txterm sgr0)

# Add the following 'help' target to your Makefile
# And add help text after each target name starting with '\#\#'
# A category can be added with @category
HELP_FUN = \
    %Targets; \
    while(<>) { push @{$$help{$$2 // 'options'}}, [$$1, $$3] if /^([a-zA-Z\-]+)\s*:.*\#\#(?:@([a-zA-Z\-]+))?\s(.*)$$/ }; \
    print "\n${WHITE}usage:\n"; \
	print "  ${YELLOW}make <target>                  ${GREEN} replace the <target> with one of below operations.\n\n"; \
    for (sort keys %help) { \
    print "${WHITE}$$_:${RESET}\n"; \
    for (@{$$help{$$_}}) { \
    $$sep = " " x (32 - length $$_->[0]); \
    print "  ${YELLOW}$$_->[0]${RESET}$$sep${GREEN}$$_->[1]${RESET}\n"; \
    }; \
    print "\n"; }

help: ##@others show target help options.
	@perl -e '$(HELP_FUN)' $(MAKEFILE_LIST)

clear-clutter: FORCE ##@others clears ".terrform" dir and associated state and *.log files
	@find . -name "*.terraform*" -exec rm -rf {} \;
	@find . -name "*.terraform.lock.hcl*" -exec rm {} \;
	@find . -name "*terraform.tfstate*" -exec rm {} \;
	@find . -name "*terraform.tfstate.backup*" -exec rm {} \;
	@find . -name "*.log" -exec rm -rf {} \;

aws-nuke-install: FORCE ##@install installs the aws-nuke binary & moves to the /usr/local/bin/aws-nuke
	brew install wget \
	&& wget -c --no-verbose https://github.com/rebuy-de/aws-nuke/releases/download/v2.15.0/aws-nuke-v2.15.0-darwin-amd64.tar.gz -O - | tar -xz \
	&& mv ./aws-nuke-v2.15.0-darwin-amd64 /usr/local/bin/aws-nuke \
	&& aws-nuke version

aws-nuke-install-linux: FORCE ##@install installs the aws-nuke binary for linux distribution for CI & moves to the /bin/aws-nuke
	wget -c --no-verbose https://github.com/rebuy-de/aws-nuke/releases/download/v2.15.0/aws-nuke-v2.15.0-linux-amd64.tar.gz -O - | tar -xz \
	&& sudo mv aws-nuke-v2.15.0-linux-amd64 /bin/aws-nuke \
	&& chmod +x /bin/aws-nuke

aws-nuke-scan: FORCE ##@aws-nuke scans all the resources it can remove, SYNTAX: make aws-nuke-scan account="{ACCOUNT_ALIAS}"
	cd ./aws/nuke-configs ;\
	aws-nuke -c $(account)-account.yml --force

aws-nuke-destroy: FORCE ##@aws-nuke destroys the resources apart from those which are filtered/unsupported, but will ask for confirmations. SYNTAX: make aws-nuke-destroy account="{ACCOUNT_ALIAS}"
	cd ./aws/nuke-configs ;\
	aws-nuke -c $(account)-account.yml --no-dry-run

tf-init: FORCE ##@terraform initializes terraform
	cd tf-infrastructure/${CLOUD} ;\
	terraform init -backend-config=./backend-config.hcl

tf-quality: FORCE ##@terraform terraform lint and validate
	cd tf-infrastructure/${CLOUD} ;\
	terraform fmt --diff --check --recursive && \
	terraform validate

tf-plan: FORCE ##@terraform terraform plan to show the resources to be provisioned
	cd tf-infrastructure/${CLOUD} ;\
	terraform plan

tf-apply: FORCE ##@terraform terraform apply to destroy the resources provisioned
	cd tf-infrastructure/${CLOUD} ;\
	terraform apply

aws-nuke-training: FORCE ##@github-actions nuke/destroy resources in AWS `Training Account` in CI, [DO NOT RUN LOCALLY]
	./aws/aws-nuke-exec.sh training

aws-nuke-se-practices: FORCE ##@github-actions nuke/destroy resources in AWS `SE Practices` account in CI, [DO NOT RUN LOCALLY]
	./aws/aws-nuke-exec.sh se-practices

azure-nuke-resource-groups: FORCE ##@github-actions nuke/destroy resource groups in Azure account in CI, [DO NOT RUN LOCALLY]
	./azure/azure-rg-nuke.sh

gcp-nuke-projects: FORCE ##@github-actions nuke/destroy projects in GCP account in CI, [DO NOT RUN LOCALLY]
	./gcp/gcp-projects-nuke.sh

FORCE:
