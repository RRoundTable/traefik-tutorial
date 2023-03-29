#!/bin/sh
# Generate a self-signed certificate with subjectAltName (SAN).
mkdir -p certificates
openssl req -x509 -newkey rsa:4096 -sha256 -days 365 -nodes \
  -keyout certificates/whoami.local.key \
  -out certificates/whoami.local.crt \
  -subj "/CN=whoami.local" \
  -addext "subjectAltName=DNS:whoami.local" \
  -addext "extendedKeyUsage=serverAuth"
