# AUTOGENERATED FILE
FROM resin/ts7700-buildpack-deps:jessie

ENV NODE_VERSION 6.10.3

RUN curl -SLO "http://resin-packages.s3.amazonaws.com/node/v$NODE_VERSION/node-v$NODE_VERSION-linux-armel.tar.gz" \
	&& echo "" | sha256sum -c - \
	&& tar -xzf "node-v$NODE_VERSION-linux-armel.tar.gz" -C /usr/local --strip-components=1 \
	&& rm "node-v$NODE_VERSION-linux-armel.tar.gz" \
	&& npm config set unsafe-perm true -g --unsafe-perm \
	&& rm -rf /tmp/*

CMD ["echo","'No CMD command was set in Dockerfile! Details about CMD command could be found in Dockerfile Guide section in our Docs. Here's the link: http://docs.resin.io/deployment/dockerfile"]
