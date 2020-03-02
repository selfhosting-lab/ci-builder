FROM ruby:2.7.0
LABEL maintainer='ben.fairless@gmail.com' \
      description='Standardised Docker image for SHL CI pipeline' \
      url='https://github.com/selfhosting-lab/ci-builder'

ENV USER='user' \
    HOME="/home/user" \
    CA_CERTS='/etc/ssl/cert.pem' \
    ANSIBLE_VERSION='2.9.5' \
    TERRAFORM_VERSION='0.12.21' \
    RUBY_VERSION='2.7.0' \
    BUNDLE_DEFAULT_INSTALL_USES_PATH='true'

# Set up user
RUN groupadd -g 990 ${USER} \
 && useradd -r -u 990 -g ${USER} ${USER} -m -d ${HOME} \
 && mkdir -p ${HOME}/.ssh \
 && chown -R ${USER}:${USER} ${HOME} \
 && chmod 0700 ${HOME}/.ssh

# Install Ansible
RUN apt-get update \
 && apt-get install python3 python3-pip sshpass -y \
 && apt-get clean \
 && pip3 install ansible=="${ANSIBLE_VERSION}"

# Install Terraform
RUN curl -L -o /tmp/terraform.zip https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
 && unzip -q /tmp/terraform.zip -d /usr/bin/ \
 && rm -f /tmp/terraform.zip

# Runtime config
USER root
WORKDIR /builds
CMD ["/bin/bash", "-l"]
