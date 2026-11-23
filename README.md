# Llavero for Appflare

This release contains the compiled credential vault Worker, browser assets, D1 migrations and a local recovery-kit utility. The Worker and its SQLite-backed Durable Objects run in the account you choose. Each installation requires Cloudflare Access and a GitHub OAuth application belonging to its operator.

1. Add the publisher's catalog to Appflare and select Llavero. Choose a permanent Worker name and hostname. Register the GitHub callback at `https://<hostname>/api/auth/oauth2/callback/github`.
2. Download `prepare.mjs` from the exact Git revision named in the catalog entry. Use Node 24 on your own machine. On macOS run the following, substituting the account, Worker name and workers.dev subdomain shown by Appflare.

   ```sh
   node prepare.mjs --worker vault --account <account-id> --workers-subdomain <subdomain> --kit ~/llavero-vault.kit.json --clipboard pbcopy
   ```

   Use `--hostname keys.example.com` for a custom domain. Linux Wayland uses `--clipboard wl-copy` and Windows uses `--clipboard clip.exe`. Use a local clipboard with history and device sharing switched off. The utility seals and reopens the recovery kit before handing over any key. Follow each prompt, save the claim code in your password manager, and enter the root key and claim-code digest in the indicated secret fields. Back up the encrypted kit and store the passphrase separately. If interrupted during preparation, repeat with `--resume` before installing and use the new claim code and digest.
3. Enter your allowed owner email and OAuth credentials. Generate the session secret in Appflare. Complete the install. Verify an anonymous visit reaches Cloudflare Access. Sign in as your allowed owner, visit `/setup`, and claim using the saved code. Reusing the code must fail. Confirm an unrelated identity cannot read the vault.
4. Keep the same root key through upgrades. Rehearse recovery with a synthetic credential before storing real credentials. The recovery kit recovers the root key. Retain the installation's D1 and Durable Object data for a complete restore.

The release includes the Apache-2.0 license, first-party NOTICE and third-party notices. [Catalog and signing key](https://github.com/gmackie/appflare-catalog)
