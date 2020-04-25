#!/usr/bin/env bash

set -em

source ${SCRIPTS_DIR}/lib/debug_functions
source ${SCRIPTS_DIR}/lib/utils

### Functions ###

function test_with_e2e_tests {
    set -o pipefail 

    cd ${DAPPER_SOURCE}/test/e2e

    go test -v -args -v=2 -logtostderr=true -ginkgo.v -ginkgo.randomizeAllSpecs \
        -dp-context cluster1 \
        -ginkgo.reportFile ${DAPPER_OUTPUT}/e2e-junit.xml 2>&1 | \
        tee ${DAPPER_OUTPUT}/e2e-tests.log
}

### Main ###

declare_kubeconfig

test_with_e2e_tests
