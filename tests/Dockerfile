FROM nanobox/build:build

# Remove existing engines, we don't want to test those
RUN rm -rf /opt/engines/*

# Create folders for this engine
RUN mkdir -p /opt/engines/python/bin && \
    mkdir -p /opt/engines/python/lib && \
    mkdir -p /opt/engines/python/templates

# Add in this engine's files
ADD bin/. /opt/engines/python/bin
ADD lib/. /opt/engines/python/lib
ADD templates/. /opt/engines/python/templates