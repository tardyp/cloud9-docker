# ------------------------------------------------------------------------------
# Based on a work at https://github.com/docker/docker.
# ------------------------------------------------------------------------------

FROM debian
MAINTAINER Pierre Tardy <tardyp@gmail.com>

# ------------------------------------------------------------------------------
# Install base
RUN apt-get update && \
    apt-get install -y build-essential g++ curl libssl-dev apache2-utils git libxml2-dev sshfs supervisord && \

# ------------------------------------------------------------------------------
# Install Node.js
   curl -sL https://deb.nodesource.com/setup_5.x | bash - && \
   apt-get install -y nodejs && \

# ------------------------------------------------------------------------------
# Install Cloud9
  git clone https://github.com/c9/core.git /cloud9
WORKDIR /cloud9
RUN scripts/install-sdk.sh && \

# Tweak standlone.js conf
   sed -i -e 's_127.0.0.1_0.0.0.0_g' /cloud9/configs/standalone.js && \
   apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Add supervisord conf
ADD conf/cloud9.conf /etc/supervisor/conf.d/

# ------------------------------------------------------------------------------
# Add volumes
RUN mkdir /workspace
VOLUME /workspace

# ------------------------------------------------------------------------------
# Clean up APT when done.

# ------------------------------------------------------------------------------
# Expose ports.
EXPOSE 80
EXPOSE 3000

# ------------------------------------------------------------------------------
# Start supervisor, define default command.
CMD ["supervisord", "-c", "/etc/supervisor/supervisord.conf"]
