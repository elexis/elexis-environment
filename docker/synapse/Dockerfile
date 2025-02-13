FROM docker.io/matrixdotorg/synapse:v1.124.0
RUN /usr/local/bin/pip install synapse-s3-storage-provider
RUN mkdir /data && chown -R 991:991 /data
# workaround until https://github.com/matrix-org/synapse-s3-storage-provider/pull/101
# is merged and released
COPY s3_storage_provider_patched.py /usr/local/lib/python3.11/site-packages/s3_storage_provider.py