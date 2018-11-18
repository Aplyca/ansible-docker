FROM alpine

LABEL Mauricio Sanchez <msanchez@aplyca.com>

ENV ANSIBLE_VERSION "2.7.2"

RUN apk --update --no-cache add py-pip gcc make libffi-dev musl-dev openssl-dev python-dev && \
    pip install packaging cffi && \
    wget -q https://github.com/ansible/ansible/archive/v${ANSIBLE_VERSION}.tar.gz && \
    tar xzf v${ANSIBLE_VERSION}.tar.gz && \
    cd ansible-${ANSIBLE_VERSION} && \
    make install && \
    cd .. && rm -rf ansible-${ANSIBLE_VERSION} v${ANSIBLE_VERSION}.tar.gz && \
    apk del --purge gcc make libffi-dev musl-dev openssl-dev python-dev && \
    pip uninstall -y packaging

RUN mkdir -p /etc/ansible && \
    echo "127.0.0.1 ansible_connection=local" > /etc/ansible/hosts    

WORKDIR /app

CMD ["ansible"]