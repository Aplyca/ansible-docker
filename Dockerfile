FROM alpine

LABEL Mauricio Sanchez <msanchez@aplyca.com>

RUN apk --update --no-cache add py-pip openssh-client
    
ENV ANSIBLE_VERSION "2.7.10"

RUN apk --update --no-cache add gcc make libffi-dev musl-dev openssl-dev python-dev && \
    pip install cffi pycrypto packaging && \
    wget -q https://github.com/ansible/ansible/archive/v${ANSIBLE_VERSION}.tar.gz && \
    tar xzf v${ANSIBLE_VERSION}.tar.gz && \
    make -C ansible-${ANSIBLE_VERSION} install && \
    rm -rf ansible-${ANSIBLE_VERSION} v${ANSIBLE_VERSION}.tar.gz && \
    apk del --purge gcc make libffi-dev musl-dev openssl-dev python-dev && \
    pip uninstall -y packaging

RUN mkdir -p /etc/ansible && \
    echo "127.0.0.1 ansible_connection=local" > /etc/ansible/hosts    

WORKDIR /app

CMD ["ansible"]
