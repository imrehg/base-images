# AUTOGENERATED FILE
FROM resin/intel-edison-debian:jessie

ENV NODE_VERSION 4.8.3

RUN buildDeps='curl build-essential python' \
	&& set -x \
	&& apt-get update && apt-get install -y $buildDeps --no-install-recommends \
	&& rm -rf /var/lib/apt/lists/* \
	&& curl -SLO "http://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-x86.tar.gz" \
	&& echo "0138e4199863a482611d0df517a318b17f1ca9df21bd8c1136030947fd8155b5  node-v4.8.3-linux-x86.tar.gz" | sha256sum -c - \
	&& tar -xzf "node-v$NODE_VERSION-linux-x86.tar.gz" -C /usr/local --strip-components=1 \
	&& rm "node-v$NODE_VERSION-linux-x86.tar.gz" \
	&& npm install mraa@$MRAA_VERSION \
	&& npm cache clear \
	&& npm config set unsafe-perm true -g --unsafe-perm \
	&& apt-get purge -y --auto-remove $buildDeps \
	&& rm -rf /tmp/*

CMD ["echo","'No CMD command was set in Dockerfile! Details about CMD command could be found in Dockerfile Guide section in our Docs. Here's the link: http://docs.resin.io/deployment/dockerfile"]
