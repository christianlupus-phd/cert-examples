# ⚠️ SECURITY WARNING: DO NOT USE IN PRODUCTION ⚠️

> **This repository contains publicly exposed private keys.**  
> These keys are **completely unsecure** and must **never** be used in any production, staging, or real-world environment. They are provided strictly for educational, testing, and demonstration purposes to illustrate the certificate structure expected by the [`ls-sign`](https://github.com/christianlupus-phd/ls-sign) repository.

---

# Certificate Examples for `ls-sign`

This repository provides a set of dummy X.509 certificates and private keys that mirror the Public Key Infrastructure (PKI) hierarchy used in the [`ls-sign`](https://github.com/christianlupus-phd/ls-sign) standard. 

Its primary purpose is to serve as a reference and exchange format, allowing developers to understand the expected file structure, test parsing logic, and perform local development without needing to generate their own test PKI from scratch.

## 📜 X.509 Certificate Hierarchy & File Mapping

The X.509 certificates follow a standard 3-tier hierarchy: **Root CA → Intermediate CA → Leaf Certificate**. Below is the exact mapping of which file corresponds to which entity:

| Hierarchy Level | Directory | Certificate File | Private Key File | Additional Files |
| :--- | :--- | :--- | :--- | :--- |
| **Root CA** | `x509/rootCA/` | [`cert.pem`](./x509/rootCA/cert.pem) | [`key.pem`](./x509/rootCA/key.pem) | *None* |
| **Intermediate CA** | `x509/intermediateACA/` | [`cert.pem`](./x509/intermediateACA/cert.pem) | [`key.pem`](./x509/intermediateACA/key.pem) | *None* |
| **Leaf Certificate** | `x509/leaf/A/leaf1/` | [`cert.pem`](./x509/leaf/A/leaf1/cert.pem) | [`key.pem`](./x509/leaf/A/leaf1/key.pem) | [`csr.pem`](./x509/leaf/A/leaf1/csr.pem) *(Certificate Signing Request)* |

### 🔍 Chain of Trust

When validating the leaf certificate, the full chain of trust is established as follows:
1. The **Leaf Certificate** (`x509/leaf/A/leaf1/cert.pem`) is signed by the **Intermediate CA**.
2. The **Intermediate CA** (`x509/intermediateACA/cert.pem`) is signed by the **Root CA**.
3. The **Root CA** (`x509/rootCA/cert.pem`) is the self-signed trust anchor.

## 📜 GPG Keyring Structure for Testing

The `gpg/` folder contains a dummy GnuPG keyring structure for testing OpenPGP signing and verification operations. It includes a `gnupg/` subfolder mirroring the typical GnuPG keyring layout (folders and files GnuPG creates during key generation), as well as an exported ASCII-armored public key (`companyA.asc`).

| Element | Location |
| :--- | :--- |
| Keyring directory (GnuPG's working folder) | `gpg/gnupg/` |
| Public key database | [`pubring.kbx`](./gpg/gnupg/pubring.kbx) |
| Trust database | [`trustdb.gpg`](./gpg/gnupg/trustdb.gpg) |
| Private keys (encrypted) | `gpg/gnupg/private-keys-v1.d/` |
| Exported key (ASCII armor) | [`companyA.asc`](./gpg/companyA.asc) |

### gnupg/ Subfolder

The `gpg/gnupg/` subfolder mimics GnuPG's default directory layout:

| Element | Location |
| :--- | :--- |
| Revocation certificates | `gpg/gnupg/openpgp-revocs.d/` |
| Private keys | `gpg/gnupg/private-keys-v1.d/` |
| Public key ring | `gpg/gnupg/pubring.kbx` |
| Trust database | `gpg/gnupg/trustdb.gpg` |

### 🔍 OpenPGP Chain of Trust

Unlike X.509's hierarchical PKI (CA → sub-CA → leaf), OpenPGP uses a **flat, peer-based trust model**. There is no certificate issuer or chain concept.

- Keys have no issuer/parent relationship.
- Trust is set explicitly by each user for each key.
- `trustdb.gpg` stores the results of those trust decisions per user.
- No transitive trust ("Alice trusts Bob, so Alice trusts Bob's certificate") exists.

Trust is configuration-driven. For example, to export keys from `companyA.asc` to a local keyring (for testing only):

```bash
gpg --import companyA.asc
gpg --edit-key <fingerprint>   # manually set trust level
```

## 📂 Repository Structure

```text
.
├── x509/
│   ├── rootCA/
│   │   ├── cert.pem          # Root CA public certificate
│   │   └── key.pem           # Root CA private key (⚠️ DUMMY/INSECURE)
│   ├── intermediateACA/
│   │   ├── cert.pem          # Intermediate CA public certificate
│   │   └── key.pem           # Intermediate CA private key (⚠️ DUMMY/INSECURE)
│   └── leaf/
│       └── A/
│           └── leaf1/
│               ├── cert.pem  # Leaf public certificate
│               ├── key.pem   # Leaf private key (⚠️ DUMMY/INSECURE)
│               └── csr.pem   # Certificate Signing Request used to generate the leaf cert
├── gpg/
│   ├── gnupg/                      # GnuPG keyring (created by build.sh)
│   │   ├── pubring.kbx            # PGP public key ring
│   │   ├── trustdb.gpg            # Trust database
│   │   ├── private-keys-v1.d/     # Encrypted private keys
│   │   ├── openpgp-revocs.d/      # Revocation certificates
│   │   ├── config                 # Example trust settings
│   │   └── .gnupg                 # Config directory with gpg.conf, etc.
│   ├── build.sh                   # Shell script to generate the dummy GPG keyring
│   └── companyA.asc               # Exported ASCII-armored public key
└── README.md                      # This file
```

## 💡 Usage with ls-sign

If you are working with the [`ls-sign`](https://github.com/christianlupus-phd/ls-sign) repository, you can use these files to:

- Test certificate parsing, validation, and signing logic.
- Understand the expected directory layout and file naming conventions.
- Run local integration tests without configuring a real, secure PKI.

_Note: When integrating with [`ls-sign`](https://github.com/christianlupus-phd/ls-sign), ensure you point your configuration or environment variables to these dummy paths only in local/test environments._

## 🛠️ Regenerating the Certificates

To build the x509 certificates, go to the folder `x509` and call `./build.sh` there.

For the GPG keyring, it is generated by the `gpg/build.sh` script.

## 📄 License & Disclaimer

This repository is intended for educational and testing purposes only. Use at your own risk, and remember: never commit real private keys to a public repository.


