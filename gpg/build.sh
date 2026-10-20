#!/bin/bash

here=$(dirname "$0")
export GNUPGHOME="$here/gnupg"

rm -rf $GNUPGHOME
mkdir $GNUPGHOME

gpg --passphrase '' --batch --quick-generate-key "Company A" default default never

gpg --armor --export 'Company A' > "$here/companyA.asc"
