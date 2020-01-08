# Acquiring an HTTPS certificate

A certificate (consisting of two files `certificate.crt`, containing the public and `certificate.key` , containing the private key) is the technological requirement for providing encrypted (not readable by others)
communication.

Certificates are bound to hostnames. That is, if this server's name is `ee.demopraxis.ch` we have
to acquire an SSL certificate for this hostname.

There exist several [types](https://aboutssl.org/type-of-ssl/) of certificates. Cost and effort to acquire one differ.

## Letsencrypt

The most popular and even free-of-char solution is [letsencrypt](https://letsencrypt.org/de/). 

It however
only works if the hostname, one wants to acquire the certificate for, is publically accessible (to prove domain ownership).
There exists a [solution](https://blog.heckel.io/2018/08/05/issuing-lets-encrypt-certificates-for-65000-internal-servers/) to gather a certificate for an non-internet facing host, but it is not easy to use. 

In addition to this
letsencrypt certificates are only valid for 3 months, before they have to be reacquired.

Due to this, if you install elexis-environment we recommend a solution by a commercial provider.

## Commercial certificates

There exist several providers for commercial certificates. The advantage of these
certificates, is that they are valid for a up to 4 years, before they have to be replaced, and that they can by acquired by proving the ownership of the domain via mail. 

## Acquiring an HTTPS certificate

We fix an example for such a certificate using [www.interssl.com)](https://www.interssl.com/de/). We register a _SECTIGO PositiveSSL Single Domain_ certificate.

A certificate valid for 2 years can be bought for € 25,--

After buying a voucher for the certificate, we have to configure it, and entering a CSR (Certificate Signing Request) is required. This CSR was generated during the `configure.sh` process (into the `assets/web/ssl` directory). If this process failed, you do not yet have a CSR.

You have to copy the contents of this file into the field `Input CSR` in the browser.

The type of the server is: `other`

On the next step `Domain Verification` select an email address you have access to, as the authorization key is sent there.

After validating the certificate using the key that arrived via email, the certificate is also delivered via email as a zip file.

## Installing the certificate

The zip package consists of 4 certificate files. Those files need to be combined into a single certificate chain file. Use the following
commands to do so, or this [link](https://gist.github.com/gangsta/9d011dc0da614db27d5b22ed2044799f) for details.

`cat SectigoRSADomainValidationSecureServerCA.crt USERTrustRSAAddTrustCA.crt AddTrustExternalCARoot.crt >> CA_bundle.crt`

`cat ee_medevit_at.crt CA_bundle.crt >> certificate.crt`

The resulting `certificate.crt` file hast to be copied to `site/` and the
existing file `site/myserver.key` (your private key) should also be copied to `site/certificate.key`.

Be careful not to loose these files.

## Hardening

CAA Record (if set to a specific ssl cert provider, only this provider may generate certificates for the specific host)