FROM resin/ccon-01-alpine-buildpack-deps:3.3-scm

RUN apk add --update \
		autoconf \
		build-base \
		imagemagick \
		libbz2 \
		#libcurl \
		libevent-dev \
		libffi-dev \
		glib-dev \
		jpeg-dev \
		imagemagick-dev \
		ncurses5-libs \
		libpq \
		readline-dev \
		sqlite-dev \
		openssl-dev \
		libxml2-dev \
		libxslt-dev \
		yaml-dev \
		zlib-dev \
		xz \
	&& rm -rf /var/cache/apk/*
