#!/bin/bash
set -e

# comparing version: http://stackoverflow.com/questions/16989598/bash-comparing-version-numbers
function version_ge() { test "$(echo "$@" | tr " " "\n" | sort -V | tail -n 1)" == "$1"; }

# extract checksum for node binary
function extract_checksum()
{
	# $1: binary type, 0: in-house, 1: official.
	# $2: node version
	# $3: variable name for result

	local __resultVar=$3

	if [ $1 -eq 0 ]; then
		local __checksum=$(grep " node-v$2-linux-$binaryArch.tar.gz" SHASUMS256.txt)
	else
		curl -SLO "https://nodejs.org/dist/v$2/SHASUMS256.txt.asc" \
		&& gpg --verify SHASUMS256.txt.asc \
		&& local __checksum=$(grep " node-v$2-linux-$binaryArch.tar.gz\$" SHASUMS256.txt.asc) \
		&& rm -f SHASUMS256.txt.asc
	fi
	eval $__resultVar="'$__checksum'"
}

# gpg keys listed at https://github.com/nodejs/node
for key in \
9554F04D7259F04124DE6B476D5A82AC7E37093B \
94AE36675C464D64BAFA68DD7434390BDBE9B9C5 \
0034A06D9D9B0064CE8ADF6BF1747F4AD2306D93 \
FD3A5288F042B6850C66B31F09FE44734EB7990E \
71DCFD284A79C3B38668286BC97EC7A07EDE3FC1 \
DD8F2338BAE7501E3DD5AC78C273792F7D83545D \
B9AE9905FFD7803F25714661B63B535A4C206CA9 \
C4F0DFFF4E8C1A8236409D08E73BC641CC11F4C8 \
7937DFD2AB06298B2293C3187D33FF9D0246406D \
114F43EE0176B71C7BC219DD50A3051F888C628D \
56730D5401028683275BD23C23EFEFE93C4CFFFE \
; do \
	gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "$key"; \
done

devices='raspberry-pi raspberry-pi2 beaglebone-black intel-edison intel-nuc via-vab820-quad zynq-xz702 odroid-c1 odroid-xu4 parallella nitrogen6x hummingboard ts4900 colibri-imx6dl apalis-imx6q ts7700 raspberrypi3 artik5 artik10 beaglebone-green-wifi qemux86 qemux86-64 beaglebone-green cybertan-ze250 artik710 am571x-evm up-board kitra710 imx6ul-var-dart ccon-01 kitra520'
fedora_devices=' raspberry-pi2 beaglebone-black via-vab820-quad zynq-xz702 odroid-c1 odroid-xu4 parallella nitrogen6x hummingboard ts4900 colibri-imx6dl apalis-imx6q raspberrypi3 artik5 artik10 beaglebone-green-wifi beaglebone-green intel-nuc qemux86-64 artik710 am571x-evm kitra710 up-board imx6ul-var-dart ccon-01 kitra520 '
nodeVersions='0.10.22 0.10.48 0.12.18 4.8.3 5.12.0 6.10.3 7.10.0 8.0.0'
defaultVersion='0.10.22'
resinUrl="http://resin-packages.s3.amazonaws.com/node/v\$NODE_VERSION/node-v\$NODE_VERSION-linux-#{TARGET_ARCH}.tar.gz"
nodejsUrl="http://nodejs.org/dist/v\$NODE_VERSION/node-v\$NODE_VERSION-linux-#{TARGET_ARCH}.tar.gz"

for device in $devices; do
	for nodeVersion in $nodeVersions; do
		case "$device" in
		'raspberry-pi')
			binaryUrl=$resinUrl
			binaryArch='armv6hf'
		;;
		'raspberry-pi2')
			binaryUrl=$resinUrl
			binaryArch='armv7hf'
		;;
		'raspberrypi3')
			binaryUrl=$resinUrl
			binaryArch='armv7hf'
		;;
		'beaglebone-black')
			binaryUrl=$resinUrl
			binaryArch='armv7hf'
		;;
		'beaglebone-green-wifi')
			binaryUrl=$resinUrl
			binaryArch='armv7hf'
		;;
		'beaglebone-green')
			binaryUrl=$resinUrl
			binaryArch='armv7hf'
		;;
		'intel-edison')
			binaryUrl=$nodejsUrl
			binaryArch='x86'
		;;
		'qemux86')
			binaryUrl=$nodejsUrl
			binaryArch='x86'
		;;
		'cybertan-ze250')
			binaryUrl=$resinUrl
			binaryArch='i386'
		;;
		'intel-nuc')
			binaryUrl=$nodejsUrl
			binaryArch='x64'
		;;
		'qemux86-64')
			binaryUrl=$nodejsUrl
			binaryArch='x64'
		;;
		'up-board')
			binaryUrl=$nodejsUrl
			binaryArch='x64'
		;;
		'via-vab820-quad')
			binaryUrl=$resinUrl
			binaryArch='armv7hf'
		;;
		'zynq-xz702')
			binaryUrl=$resinUrl
			binaryArch='armv7hf'
		;;
		'odroid-c1')
			binaryUrl=$resinUrl
			binaryArch='armv7hf'
		;;
		'odroid-xu4')
			binaryUrl=$resinUrl
			binaryArch='armv7hf'
		;;
		'parallella')
			binaryUrl=$resinUrl
			binaryArch='armv7hf'
		;;
		'nitrogen6x')
			binaryUrl=$resinUrl
			binaryArch='armv7hf'
		;;
		'hummingboard')
			binaryUrl=$resinUrl
			binaryArch='armv7hf'
		;;
		'ts4900')
			binaryUrl=$resinUrl
			binaryArch='armv7hf'
		;;
		'colibri-imx6dl')
			binaryUrl=$resinUrl
			binaryArch='armv7hf'
		;;
		'apalis-imx6q')
			binaryUrl=$resinUrl
			binaryArch='armv7hf'
		;;
		'am571x-evm')
			binaryUrl=$resinUrl
			binaryArch='armv7hf'
		;;
		'ts7700')
			binaryUrl=$resinUrl
			binaryArch='armel'
		;;
		'artik5')
			binaryUrl=$resinUrl
			binaryArch='armv7hf'
		;;
		'artik10')
			binaryUrl=$resinUrl
			binaryArch='armv7hf'
		;;
		'artik710')
			binaryUrl=$resinUrl
			binaryArch='armv7hf'
		;;
		'kitra710')
			binaryUrl=$resinUrl
			binaryArch='armv7hf'
		;;
		'kitra520')
			binaryUrl=$resinUrl
			binaryArch='armv7hf'
		;;
		'imx6ul-var-dart')
			binaryUrl=$resinUrl
			binaryArch='armv7hf'
		;;
		'ccon-01')
			binaryUrl=$resinUrl
			binaryArch='armv7hf'
		;;
		esac
		if [ $nodeVersion == $defaultVersion ]; then
			baseVersion='default'
		else
			baseVersion=$(expr match "$nodeVersion" '\([0-9]*\.[0-9]*\)')
		fi

		if (version_ge "$nodeVersion" "7") && [ $binaryArch == "armel" ]; then
			continue
		fi

		# we don't have Node v8.0.0 for x87 yet.
		if (version_ge "$nodeVersion" "8") && [ $device == "cybertan-ze250" ]; then
			continue
		fi

		# Debian.
		# For armv6hf, if node version is greater or equal than 4.x.x then that image will use binaries from official distribution, otherwise it will use binaries from resin.
		if [ $binaryArch == "armv6hf" ]; then
			if version_ge "$nodeVersion" "4"; then
				binaryUrl=$nodejsUrl
				binaryArch='armv6l'
			fi
		fi

		# Extract checksum
		if [ $binaryUrl == "$nodejsUrl" ]; then
			extract_checksum 1 $nodeVersion "checksum"
		else
			extract_checksum 0 $nodeVersion "checksum"
		fi

		# Set v6.3.1 as the latest node version for debian wheezy (https://github.com/resin-io-library/base-images/issues/177)
		if version_ge "$nodeVersion" "6"; then
			wheezyNodeVersion='6.3.1'
			extract_checksum 1 $wheezyNodeVersion "wheezyChecksum"
			wheezyBaseVersion='6.3'
		else
			wheezyNodeVersion=$nodeVersion
			wheezyChecksum=$checksum
			wheezyBaseVersion=$(expr match "$wheezyNodeVersion" '\([0-9]*\.[0-9]*\)')
		fi


		debian_dockerfilePath=$device/debian/$baseVersion
		mkdir -p $debian_dockerfilePath
		sed -e s~#{FROM}~resin/$device-buildpack-deps:jessie~g \
			-e s~#{BINARY_URL}~$binaryUrl~g \
			-e s~#{NODE_VERSION}~$nodeVersion~g \
			-e s~#{CHECKSUM}~"$checksum"~g \
			-e s~#{TARGET_ARCH}~$binaryArch~g Dockerfile.tpl > $debian_dockerfilePath/Dockerfile

		mkdir -p $device/debian/$wheezyBaseVersion/wheezy
		sed -e s~#{FROM}~resin/$device-buildpack-deps:wheezy~g \
			-e s~#{BINARY_URL}~$binaryUrl~g \
			-e s~#{NODE_VERSION}~$wheezyNodeVersion~g \
			-e s~#{CHECKSUM}~"$wheezyChecksum"~g \
			-e s~#{TARGET_ARCH}~$binaryArch~g Dockerfile.tpl > $device/debian/$wheezyBaseVersion/wheezy/Dockerfile

		mkdir -p $debian_dockerfilePath/onbuild
		sed -e s~#{FROM}~resin/$device-node:$nodeVersion~g Dockerfile.onbuild.tpl > $debian_dockerfilePath/onbuild/Dockerfile
		mkdir -p $debian_dockerfilePath/slim

		# Only for RPI1 device
		if [ $device == "raspberry-pi" ]; then
			sed -e s~#{FROM}~resin/rpi-raspbian:jessie~g \
				-e s~#{BINARY_URL}~$binaryUrl~g \
				-e s~#{NODE_VERSION}~$nodeVersion~g \
				-e s~#{CHECKSUM}~"$checksum"~g \
				-e s~#{TARGET_ARCH}~$binaryArch~g Dockerfile.slim.tpl > $debian_dockerfilePath/slim/Dockerfile
		else
			sed -e s~#{FROM}~resin/$device-debian:jessie~g \
				-e s~#{BINARY_URL}~$binaryUrl~g \
				-e s~#{NODE_VERSION}~$nodeVersion~g \
				-e s~#{CHECKSUM}~"$checksum"~g \
				-e s~#{TARGET_ARCH}~$binaryArch~g Dockerfile.slim.tpl > $debian_dockerfilePath/slim/Dockerfile
		fi

		# Only for intel intel-edison
		if [ $device == "intel-edison" ]; then
			if ! version_ge "$nodeVersion" "7"; then
				# mraa doesn't support Node.js 7.0.0+ so we will use generic template for them.
				sed -e s~#{FROM}~resin/$device-buildpack-deps:jessie~g \
					-e s~#{BINARY_URL}~$binaryUrl~g \
					-e s~#{NODE_VERSION}~$nodeVersion~g \
					-e s~#{CHECKSUM}~"$checksum"~g \
					-e s~#{TARGET_ARCH}~$binaryArch~g Dockerfile.i386.edison.tpl > $debian_dockerfilePath/Dockerfile

				sed -e s~#{FROM}~resin/$device-buildpack-deps:wheezy~g \
					-e s~#{BINARY_URL}~$binaryUrl~g \
					-e s~#{NODE_VERSION}~$wheezyNodeVersion~g \
					-e s~#{CHECKSUM}~"$wheezyChecksum"~g \
					-e s~#{TARGET_ARCH}~$binaryArch~g Dockerfile.i386.edison.tpl > $device/debian/$wheezyBaseVersion/wheezy/Dockerfile

				sed -e s~#{FROM}~resin/$device-debian:jessie~g \
					-e s~#{BINARY_URL}~$binaryUrl~g \
					-e s~#{NODE_VERSION}~$nodeVersion~g \
					-e s~#{CHECKSUM}~"$checksum"~g \
					-e s~#{TARGET_ARCH}~$binaryArch~g Dockerfile.i386.edison.slim.tpl > $debian_dockerfilePath/slim/Dockerfile
			fi
		fi

		# Fedora
		if [[ $fedora_devices == *" $device "* ]]; then
			fedora_dockerfilePath=$device/fedora/$baseVersion

			mkdir -p $fedora_dockerfilePath
			sed -e s~#{FROM}~resin/$device-fedora-buildpack-deps:latest~g \
				-e s~#{BINARY_URL}~$binaryUrl~g \
				-e s~#{NODE_VERSION}~$nodeVersion~g \
				-e s~#{CHECKSUM}~"$checksum"~g \
				-e s~#{TARGET_ARCH}~$binaryArch~g Dockerfile.tpl > $fedora_dockerfilePath/Dockerfile

			mkdir -p $fedora_dockerfilePath/24
			sed -e s~#{FROM}~resin/$device-fedora-buildpack-deps:24~g \
				-e s~#{BINARY_URL}~$binaryUrl~g \
				-e s~#{NODE_VERSION}~$nodeVersion~g \
				-e s~#{CHECKSUM}~"$checksum"~g \
				-e s~#{TARGET_ARCH}~$binaryArch~g Dockerfile.tpl > $fedora_dockerfilePath/24/Dockerfile

			mkdir -p $fedora_dockerfilePath/onbuild
			sed -e s~#{FROM}~resin/$device-fedora-node:$nodeVersion~g Dockerfile.onbuild.tpl > $fedora_dockerfilePath/onbuild/Dockerfile

			mkdir -p $fedora_dockerfilePath/slim
			sed -e s~#{FROM}~resin/$device-fedora:latest~g \
				-e s~#{BINARY_URL}~$binaryUrl~g \
				-e s~#{NODE_VERSION}~$nodeVersion~g \
				-e s~#{CHECKSUM}~"$checksum"~g \
				-e s~#{TARGET_ARCH}~$binaryArch~g Dockerfile.tpl > $fedora_dockerfilePath/slim/Dockerfile
		fi

		# Alpine
		case "$binaryArch" in
		'x64')
			binaryArch='alpine-amd64'
			binaryUrl=$resinUrl
		;;
		'i386'|'x86')
			binaryArch='alpine-i386'
			binaryUrl=$resinUrl
		;;
		'armel')
			# armel not supported yet.
			continue
		;;
		*)
			binaryArch='alpine-armhf'
			binaryUrl=$resinUrl
		;;
		esac

		# Node 0.12.x are not supported atm.
		if [ $baseVersion == '0.12' ]; then
			continue
		fi
		extract_checksum 0 $nodeVersion "checksum"

		alpine_dockerfilePath=$device/alpine/$baseVersion

		mkdir -p $alpine_dockerfilePath
		sed -e s~#{FROM}~resin/$device-alpine-buildpack-deps:latest~g \
			-e s~#{BINARY_URL}~$binaryUrl~g \
			-e s~#{NODE_VERSION}~$nodeVersion~g \
			-e s~#{CHECKSUM}~"$checksum"~g \
			-e s~#{TARGET_ARCH}~$binaryArch~g Dockerfile.alpine.tpl > $alpine_dockerfilePath/Dockerfile

		mkdir -p $alpine_dockerfilePath/slim
		sed -e s~#{FROM}~resin/$device-alpine:latest~g \
			-e s~#{BINARY_URL}~$binaryUrl~g \
			-e s~#{NODE_VERSION}~$nodeVersion~g \
			-e s~#{CHECKSUM}~"$checksum"~g \
			-e s~#{TARGET_ARCH}~$binaryArch~g Dockerfile.alpine.slim.tpl > $alpine_dockerfilePath/slim/Dockerfile

		mkdir -p $alpine_dockerfilePath/onbuild
		sed -e s~#{FROM}~resin/$device-alpine-node:$nodeVersion~g Dockerfile.onbuild.tpl > $alpine_dockerfilePath/onbuild/Dockerfile

		mkdir -p $alpine_dockerfilePath/edge
		sed -e s~#{FROM}~resin/$device-alpine-buildpack-deps:edge~g \
			-e s~#{BINARY_URL}~$binaryUrl~g \
			-e s~#{NODE_VERSION}~$nodeVersion~g \
			-e s~#{CHECKSUM}~"$checksum"~g \
			-e s~#{TARGET_ARCH}~$binaryArch~g Dockerfile.alpine.tpl > $alpine_dockerfilePath/edge/Dockerfile
	done
done
