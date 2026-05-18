# YubiKey commit signing

`.gitconfig` is configured to sign commits with an SSH key backed by a
YubiKey 5 FIDO2 credential. The private key material never leaves the
YubiKey. Run these steps once per machine.

> Signing is **opt-in** — `commit.gpgsign` is not set. Use the `gcsm` alias
> (`git commit -S -m`) for signed commits. Plain `git commit` still works
> without the YubiKey, so a fresh machine is never blocked.

## 1. Generate the key on the YubiKey

```sh
ssh-keygen -t ed25519-sk \
  -O resident \
  -O no-touch-required \
  -O application=ssh:git \
  -C "maxk@nrwl.io" \
  -f ~/.ssh/id_ed25519_sk
```

- `-O resident` — the credential is stored on the YubiKey itself. On any
  future machine you can pull it back with `cd ~/.ssh && ssh-keygen -K`
  instead of regenerating.
- `-O no-touch-required` — no tap per commit. The key still must be
  physically present; it just can't be exfiltrated from disk.
- The private file `~/.ssh/id_ed25519_sk` is only a handle — useless
  without the YubiKey — but still don't commit it.

## 2. Register the public key on GitHub

GitHub → Settings → SSH and GPG keys → **New SSH key** → Key type:
**Signing Key** → paste the contents of:

```sh
cat ~/.ssh/id_ed25519_sk.pub
```

## 3. Create the allowed-signers file (for local verification)

Lets `git log --show-signature` verify your own commits locally.

```sh
mkdir -p ~/.config/git
echo "maxk@nrwl.io namespaces=\"git\" $(cat ~/.ssh/id_ed25519_sk.pub)" \
  > ~/.config/git/allowed_signers
```

## 4. Verify

```sh
git commit -S --allow-empty -m "test: signing"
git log --show-signature -1
git reset --hard HEAD~1   # drop the test commit
```

You should see `Good "git" signature`.

## Notes

- The old GPG key (`A9018C6DF79245BA`) is no longer used by git. Once SSH
  signing is verified you can remove it from GitHub; commits previously
  signed with it stay verified. The on-disk `~/.gnupg` key isn't needed for
  git anymore — delete it only if nothing else depends on it.
- This is "Tier 2": signing on the YubiKey. Push auth still uses HTTPS +
  the `gh` token. Moving push auth onto the YubiKey too is a later step.
