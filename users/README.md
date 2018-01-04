# Provision users for a workshop

This terraform module can provision users for a workshop. The following permission are granted:
- IAMUpdateCredentials: too allow developers to change their password and create an access key
- SystemAdministrator: allow basic actions too most EC2 resources and other common stuff

## Input
A map of email to a Keybase username or a public pgp key.

## Output
A map of username to password, passwords are encrypted using the provided pgp key or the public key listed in Keybase and Base64 encoded. Users can decrypt their password with their private pgp key:

`echo <<encrypted key>> | base64 -D | gpg2 -d`

Or using Keybase directly:

`echo <<encrypted key>> | base64 -D | keybase gpg -d`

Users must change their password on first login. Next you can create an access key in the AWS console.
