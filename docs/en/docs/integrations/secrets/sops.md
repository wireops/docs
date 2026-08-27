# SOPS + age

SOPS is wireops's repository-scoped secret mechanism. It is always enabled and needs no Integration settings. Each repository receives its own age keypair; wireops decrypts a SOPS-encrypted `secrets.yaml` during sync.

## Add `secrets.yaml`

Place `secrets.yaml` alongside the stack configuration that needs it, encrypt it with the repository's public age recipient, and commit only the encrypted file.

```yaml
DATABASE_PASSWORD: change-me-before-encrypting
API_TOKEN: change-me-before-encrypting
```

The repository detail page exposes the public recipient used to encrypt the file. The plaintext values are overlaid at deploy time and should never be committed or pasted into regular Compose files.

## Check and operate

1. Encrypt a non-production test value with the repository recipient.
2. Commit the encrypted file and run a sync.
3. Confirm the workload receives the value without exposing it in logs.

If an age key is rotated, re-encrypt existing `secrets.yaml` files with the new recipient before the next deployment. Keep encrypted files in Git, but store recovery procedures and access to the server data carefully.
