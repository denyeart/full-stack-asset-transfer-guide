#!/bin/bash

set -eou pipefail

# All checks run in the workshop root folder
cd "$(dirname "$0")"/..

. checks/utils.sh

EXIT=0

must_declare WORKSHOP_CRYPTO

must_declare CORE_PEER_LOCALMSPID
must_declare CORE_PEER_ADDRESS
must_declare CORE_PEER_TLS_ENABLED
must_declare CORE_PEER_MSPCONFIGPATH
must_declare CORE_PEER_TLS_ROOTCERT_FILE
must_declare CORE_PEER_CLIENT_CONNTIMEOUT
must_declare CORE_PEER_DELIVERYTIMEOUT_CONNTIMEOUT
must_declare ORDERER_ENDPOINT
must_declare ORDERER_TLS_CERT



exit $EXIT
