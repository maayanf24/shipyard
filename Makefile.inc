k8s_version ?= 1.14.6
deploytool ?= operator
release_tag ?= latest
repo ?= quay.io/submariner
cable_driver ?= ''

SCRIPTS_DIR ?= /opt/shipyard/scripts

cleanup:
	$(SCRIPTS_DIR)/cleanup.sh

clusters:
	$(SCRIPTS_DIR)/clusters.sh --k8s_version $(k8s_version) $(CLUSTERS_ARGS)

deploy: clusters
	$(SCRIPTS_DIR)/deploy.sh --deploytool $(deploytool) --cable_driver $(cable_driver) $(DEPLOY_ARGS)

release:
	$(SCRIPTS_DIR)/release.sh --tag $(release_tag) --repo $(repo) $(release_images) $(RELEASE_ARGS)

ifeq (go.mod,$(wildcard go.mod))
# If go.mod exists (as determined above), assume we're vendoring
vendor/modules.txt: go.mod
	go mod download
	go mod vendor
endif
