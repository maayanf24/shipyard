ifneq (,$(DAPPER_HOST_ARCH))

# Running in Dapper

ifeq (,$(findstring --cluster_settings,$(CLUSTERS_ARGS)))
    CLUSTER_SETTINGS_FLAG = --cluster_settings $(DAPPER_SOURCE)/scripts/cluster_settings
    CLUSTERS_ARGS += $(CLUSTER_SETTINGS_FLAG)
    DEPLOY_ARGS += $(CLUSTER_SETTINGS_FLAG)
endif

include $(SHIPYARD_DIR)/Makefile.inc

TARGETS := $(shell ls -p scripts | grep -v -e /)

e2e:
	$(MAKE) clusters CLUSTERS_ARGS="--cluster_settings $(DAPPER_SOURCE)/scripts/e2e_cluster_settings"
	./scripts/kind-e2e/e2e.sh

# Add any project-specific arguments here
$(TARGETS):
	./scripts/$@

.PHONY: $(TARGETS)

# Project-specific targets go here
validate: vendor/modules.txt

else

# Not running in Dapper

# Shipyard-specific starts
clusters deploy release validate: dapper-image

dapper-image: export SCRIPTS_DIR=./scripts/shared

dapper-image:
	$(SCRIPTS_DIR)/build_image.sh -i shipyard-dapper-base -f package/Dockerfile.dapper-base $(dapper_image_flags)

.DEFAULT_GOAL := validate
# Shipyard-specific ends

include Makefile.dapper

endif

# Disable rebuilding Makefile
Makefile Makefile.dapper Makefile.inc: ;
