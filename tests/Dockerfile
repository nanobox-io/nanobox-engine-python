FROM nanobox/build:beta

# Remove existing engines, we don't want to test those
RUN rm -rf /opt/engines/*

# Create folders for this engine
RUN mkdir -p /opt/engines/python/bin && \
    mkdir -p /opt/engines/python/lib && \
    mkdir -p /opt/engines/python/templates

RUN curl https://codeload.github.com/nanobox-io/nanobox-engine-nodejs/tar.gz/master | \
    tar -xzC /opt/engines/pyton --strip-components 1

# Add in this engine's files
ADD bin/. /opt/engines/python/bin
ADD lib/. /opt/engines/python/lib
ADD templates/. /opt/engines/python/templates