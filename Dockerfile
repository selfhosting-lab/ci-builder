FROM fedora:31
LABEL maintainer='ben.fairless@gmail.com' \
      description='Standardised Docker image for SHL CI pipeline' \
      url='https://github.com/selfhosting-lab/ci-builder'

ENV USER='user' \
    PYTHON_VERSION='3.7.6' \
    ANSIBLE_VERSION='2.9.6' \
    TERRAFORM_VERSION='0.12.24' \
    RUBY_VERSION='2.6.5' \
    PODMAN_VERSION='1.8.1' \
    CA_CERTS='/etc/ssl/certs/ca-bundle.crt' \
    BUNDLE_DEFAULT_INSTALL_USES_PATH='true'

# Set up user
RUN groupadd -g 990 ${USER} \
 && useradd -r -u 990 -g ${USER} ${USER} -m \
 && mkdir -p /builds \
 && chown ${USER}:${USER} /builds

# Install utilities
RUN dnf install -y unzip curl git which redhat-rpm-config gcc-c++ \
    '@Development Tools' 

# Install Terraform
RUN curl -L -o /tmp/terraform.zip https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
 && unzip -q /tmp/terraform.zip -d /usr/bin/ \
 && rm -f /tmp/terraform.zip

# Install Ruby
RUN dnf install -y "ruby-${RUBY_VERSION}" "ruby-devel-${RUBY_VERSION}" \
    rubygems rubygem-bundler

# Install Python & Ansible
RUN dnf install -y "python3-${PYTHON_VERSION}" python3-pip python3-passlib sshpass \
 && pip3 install ansible=="${ANSIBLE_VERSION}"

# Install Podman
RUN dnf install -y "podman-${PODMAN_VERSION}" "podman-docker-${PODMAN_VERSION}" \
 && touch /etc/containers/nodocker

# Clean up
RUN dnf clean all

# Runtime config
USER root
WORKDIR /builds
CMD ["/bin/bash", "-l"]
