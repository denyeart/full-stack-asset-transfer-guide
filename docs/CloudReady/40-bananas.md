# Gateway Client Application

[PREV: Install Chaincode](30-chaincode.md) <==> [NEXT: Teardown](90-teardown.md)

---

## Checks

```shell

just check-chaincode

```


## Register and enroll a new user at the org CA

```shell

# User organization MSP ID
export MSP_ID=Org1MSP        
export ORG=org1
export USERNAME=org1user
export PASSWORD=org1userpw

```

```shell

ADMIN_MSP_DIR=$WORKSHOP_CRYPTO/enrollments/${ORG}/users/rcaadmin/msp
USER_MSP_DIR=$WORKSHOP_CRYPTO/enrollments/${ORG}/users/${USERNAME}/msp
PEER_MSP_DIR=$WORKSHOP_CRYPTO/channel-msp/peerOrganizations/${ORG}/msp

fabric-ca-client  register \
  --id.name       $USERNAME \
  --id.secret     $PASSWORD \
  --id.type       client \
  --url           https://$WORKSHOP_NAMESPACE-$ORG-ca-ca.$WORKSHOP_INGRESS_DOMAIN \
  --tls.certfiles $WORKSHOP_CRYPTO/cas/$ORG-ca/tls-cert.pem \
  --mspdir        $WORKSHOP_CRYPTO/enrollments/$ORG/users/rcaadmin/msp

fabric-ca-client enroll \
  --url           https://$USERNAME:$PASSWORD@$WORKSHOP_NAMESPACE-$ORG-ca-ca.$WORKSHOP_INGRESS_DOMAIN \
  --tls.certfiles $WORKSHOP_CRYPTO/cas/$ORG-ca/tls-cert.pem \
  --mspdir        $WORKSHOP_CRYPTO/enrollments/$ORG/users/$USERNAME/msp

mv $USER_MSP_DIR/keystore/*_sk $USER_MSP_DIR/keystore/key.pem

```

## Go Bananas

- Set the gateway client to connect to the org1-peer1 as the newly enrolled `${USERNAME}`:
```shell

# Path to private key file
export PRIVATE_KEY=${USER_MSP_DIR}/keystore/key.pem

# Path to user certificate file
export CERTIFICATE=${USER_MSP_DIR}/signcerts/cert.pem

# Path to CA certificate
export TLS_CERT=${PEER_MSP_DIR}/tlscacerts/tlsca-signcert.pem

# Gateway peer SSL host name override
export HOST_ALIAS=${WORKSHOP_NAMESPACE}-${ORG}-peer1-peer.${WORKSHOP_INGRESS_DOMAIN}

# Gateway endpoint
export ENDPOINT=$HOST_ALIAS:443

```

```shell

pushd applications/trader-typescript

npm install

```

```shell

npm start create banana bananaman yellow

npm start getAllAssets

npm start transfer banana appleman Org1MSP

npm start getAllAssets

npm start transfer banana bananaman Org2MSP

npm start transfer banana bananaman Org1MSP

popd

```

## Gateway Load Balancing

- todo: set up a gateway Service alias in Kubernetes.
- todo: the peer CA cert needs a new SAN in the enrollment to accept the host name of the gateway service.   This works well with the Kube test network, but needs some work with the operator, which bootstraps the node TLS certs behind the scenes.
- todo: if we can't issue a new TLS cert for the peer with the gateway host SAN, try using the HOST_ALIAS as set above, connecting via the Gateway Service endpoint.  This may not work with the ingress routing.

---

[PREV: Install Chaincode](30-chaincode.md) <==> [NEXT: Teardown](90-teardown.md)
