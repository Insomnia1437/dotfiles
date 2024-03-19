# GNUPG

## Abbreviation

- A    =>    Authentication
- C    =>    Certify
- E    =>    Encrypt
- S    =>    Sign
- ?    =>    Unknown capability
- sec  =>    Secret Key
- ssb  =>    Secret SuBkey
- pub  =>    Public Key
- sub  =>    Public Subkey
## Usage

### Create

```shell
$ gpg --full-gen-key
gpg (GnuPG) 2.4.5; Copyright (C) 2024 g10 Code GmbH
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.

Please select what kind of key you want:
   (1) RSA and RSA
   (2) DSA and Elgamal
   (3) DSA (sign only)
   (4) RSA (sign only)
   (9) ECC (sign and encrypt) *default*
  (10) ECC (sign only)
  (14) Existing key from card
Your selection?
Please select which elliptic curve you want:
   (1) Curve 25519 *default*
   (4) NIST P-384
   (6) Brainpool P-256
Your selection?
Please specify how long the key should be valid.
         0 = key does not expire
      <n>  = key expires in n days
      <n>w = key expires in n weeks
      <n>m = key expires in n months
      <n>y = key expires in n years
Key is valid for? (0)
Key does not expire at all
Is this correct? (y/N) y

GnuPG needs to construct a user ID to identify your key.
...
```

### Show
```shell
$ gpg --list-keys --fingerprint $(KEYID) 
# $ gpg -k --fingerprint $(KEYID) 
```

### edit & add sub key

```shell
$ gpg --edit-key $(KEYID)
$ gpg --expert --edit-key $(KEYID)
```

### Revoke
```shell
$ gpg --armor --output master_revoke.asc --gen-revoke $(KEYID)
```

### Export

> GPG includes the master key along with all its associated subkeys in the export by default

```shell
$ gpg --armor --output pub.gpg --export $(MASTER_KEYID)
$ gpg --armor --output priv.gpg --export-secret-keys $(MASTER_KEYID)

# # for subkeys
# $ gpg --output subkeys_priv.gpg --export-secret-subkeys $(MASTER_KEYID)
# # or
# $ gpg --output subkeys_priv.gpg --export-secret-subkeys $(SUB1_KEYID)! [$(SUB2_KEYID)! ..]
```

### Delete
```shell
$ gpg --delete-secret-keys $(KEYID)
$ gpg --delete-keys $(KEYID)

$ gpg-connect-agent "delete_key $(KEYID)" /bye
```

### Sign
```shell
$ gpg --sign input.txt

# for ASCII format
$ gpg --clearsign input.txt

# separate sign and text
$ gpg --armor --detach-sign --default-key $(KEYID) input.txt
# if not specifying a `default-key`,
# The selection of this default key follows GPG's internal logic,
# which typically prioritizes keys based on their
# capabilities, preferences, and possibly their creation or expiration dates.
$ gpg --armor --detach-sign input.txt

# veriy sign
$ gpg --verify demo.txt.asc demo.txt
```

### Sign git commit

```shell
# tell git about your key
$ git config --global user.signingkey $(KEYID)
# Sign all commits by default
$ git config --global commit.gpgsign true

# If error occurs
$ git commit -S -m "update"
error: gpg failed to sign the data
fatal: failed to write commit object

# On macOS
$ brew install pinentry-mac
$ echo "pinentry-program $(which pinentry-mac)" >> ~/.gnupg/gpg-agent.conf

# On wsl
$ echo "use-agent\npinentry-mode loopback" >> ~/.gnupg/gpg.conf
```