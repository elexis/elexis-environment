# Using MinIO as S3 service for Elexis-Environment

[Minio](https://github.com/minio/) is an open-source high-performance, S3 compatible object storage

Medelexis remarks:
* https://redmine.medelexis.ch/issues/25224

## Install MinIO

This depends on your operating system. You have to use a trusted and robust machine, and configure a certificate to provide an HTTPS endpoint.

Be sure to select a tough ROOT password.

## EE Configuration

Login to the MinIO console using your root password anc create an access key
in `User/Access Keys`. Just copy the `Access Key` and `Secret Key` value.

On the EE console, execute the following command
```
./ee cmd minio-mc ee-initialize [your_access_key] [your_secret_key]
```
this will initialize a separate, restricted user for every required service
and update the secret variables in `.env`

(you may run this command as often as you want, it will update the secret keys on every run)

DELETE the `Access Key` you just generated.