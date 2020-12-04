FROM alpine:3.12.0
## Install Ansible
ENV ANSIBLE_VERSION '2.9.12'
RUN apk --no-cache add python3 py-pip openssl ca-certificates && \
    apk --no-cache add --virtual install-dependencies \
                        python3-dev libffi-dev openssl-dev build-base && \
    pip install --upgrade pip cffi && \
    pip install --upgrade pywinrm ansible\==${ANSIBLE_VERSION} && \
    apk del install-dependencies            && \
    rm -rf /var/cache/apk/*
## Install Packer
ENV PACKER_VERSION '1.6.1'
ENV PACKER_ZIP_URL "https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip"
RUN apk --no-cache add --virtual install-dependencies \
                        curl libarchive-tools && \
    curl -L ${PACKER_ZIP_URL} | bsdtar xvf - -C /usr/sbin && \
    chmod +x /usr/sbin/packer && \
    apk del install-dependencies && \
    rm -rf /var/cache/apk/*
## Add provisioning scripts
ADD base /tmp/work/base