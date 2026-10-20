#!/bin/bash

set -x

STEP="${STEP:-step-cli}"
FORCE="${FORCE:-0}"

echo "Creating root certificate"

[ "$FORCE" != y ] || rm -rf rootCA
mkdir -p rootCA
[ -f rootCA/cert.pem -a -f rootCA/key.pem ] || \
"$STEP" certificate create \
    --profile root-ca \
    --no-password --insecure \
    "FMI Root CA" rootCA/cert.pem rootCA/key.pem

echo "Creating Intermediate A certificate"

[ "$FORCE" != y ] || rm -rf intermediateACA
mkdir -p intermediateACA
[ -f intermediateACA/cert.pem -a -f intermediateACA/key.pem ] || \
"$STEP" certificate create --profile intermediate-ca \
    --no-password --insecure \
    --ca rootCA/cert.pem --ca-key rootCA/key.pem \
    "Company A Intermediate CA" \
    intermediateACA/cert.pem intermediateACA/key.pem

create_leaf_cert() {
    dir="$1"
    subj="$2"
    intermediate="$3"
    shift 3

    [ "$FORCE" != y ] || rm -rf "$dir"
    mkdir -p "$dir"

    [ -f "$dir/cert.pem" -a -f "$dir/key.pem" ] || {
        "$STEP" certificate create --csr \
            --no-password --insecure \
            "$subj" "$dir/csr.pem" "$dir/key.pem"
        
        "$STEP" certificate sign \
            --omit-cn-san \
            "$dir/csr.pem" \
            "$intermediate/cert.pem" "$intermediate/key.pem" "$@" \
            > "$dir/cert.pem"
    }
}

echo "Creating first leaf certificate"

create_leaf_cert leaf/A/leaf1 "/CN=FMU1/C=Company A" intermediateACA
