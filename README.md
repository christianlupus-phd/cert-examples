# ⚠️ SECURITY WARNING: DO NOT USE IN PRODUCTION ⚠️

> **This repository contains publicly exposed private keys.**  
> These keys are **completely unsecure** and must **never** be used in any production, staging, or real-world environment. They are provided strictly for educational, testing, and demonstration purposes to illustrate the certificate structure expected by the [`ls-sign`](https://github.com/christianlupus-phd/ls-sign) repository.

---

# Certificate Examples for `ls-sign`

This repository provides a set of dummy X.509 certificates and private keys that mirror the Public Key Infrastructure (PKI) hierarchy used in the [`ls-sign`](https://github.com/christianlupus-phd/ls-sign) standard. 

Its primary purpose is to serve as a reference and exchange format, allowing developers to understand the expected file structure, test parsing logic, and perform local development without needing to generate their own test PKI from scratch.

## 📜 Certificate Hierarchy & File Mapping

The PKI follows a standard 3-tier hierarchy: **Root CA → Intermediate CA → Leaf Certificate**. Below is the exact mapping of which file corresponds to which entity:

| Hierarchy Level | Directory | Certificate File | Private Key File | Additional Files |
| :--- | :--- | :--- | :--- | :--- |
| **Root CA** | `rootCA/` | [`cert.pem`](./rootCA/cert.pem) | [`key.pem`](./rootCA/key.pem) | *None* |
| **Intermediate CA** | `intermediateACA/` | [`cert.pem`](./intermediateACA/cert.pem) | [`key.pem`](./intermediateACA/key.pem) | *None* |
| **Leaf Certificate** | `leaf/A/leaf1/` | [`cert.pem`](./leaf/A/leaf1/cert.pem) | [`key.pem`](./leaf/A/leaf1/key.pem) | [`csr.pem`](./leaf/A/leaf1/csr.pem) *(Certificate Signing Request)* |

### 🔍 Chain of Trust

When validating the leaf certificate, the full chain of trust is established as follows:
1. The **Leaf Certificate** (`leaf/A/leaf1/cert.pem`) is signed by the **Intermediate CA**.
2. The **Intermediate CA** (`intermediateACA/cert.pem`) is signed by the **Root CA**.
3. The **Root CA** (`rootCA/cert.pem`) is the self-signed trust anchor.

## 📂 Repository Structure

```text
.
├── rootCA/
│   ├── cert.pem          # Root CA public certificate
│   └── key.pem           # Root CA private key (⚠️ DUMMY/INSECURE)
├── intermediateACA/
│   ├── cert.pem          # Intermediate CA public certificate
│   └── key.pem           # Intermediate CA private key (⚠️ DUMMY/INSECURE)
├── leaf/
│   └── A/
│       └── leaf1/
│           ├── cert.pem  # Leaf public certificate
│           ├── key.pem   # Leaf private key (⚠️ DUMMY/INSECURE)
│           └── csr.pem   # Certificate Signing Request used to generate the leaf cert
├── build.sh              # Shell script used to generate this dummy PKI structure
└── README.md             # This file
```

## 💡 Usage with ls-sign

If you are working with the [`ls-sign`](https://github.com/christianlupus-phd/ls-sign) repository, you can use these files to:

- Test certificate parsing, validation, and signing logic.
- Understand the expected directory layout and file naming conventions.
- Run local integration tests without configuring a real, secure PKI.

_Note: When integrating with [`ls-sign`](https://github.com/christianlupus-phd/ls-sign), ensure you point your configuration or environment variables to these dummy paths only in local/test environments._

## 🛠️ Regenerating the Certificates

If you need to reset or modify the dummy certificates, you can use the provided shell script:

```bash
chmod +x build.sh
./build.sh
```

(Review the contents of `build.sh` before execution to understand the OpenSSL commands and subject parameters being used.)

## 📄 License & Disclaimer

This repository is intended for educational and testing purposes only. Use at your own risk, and remember: never commit real private keys to a public repository.


