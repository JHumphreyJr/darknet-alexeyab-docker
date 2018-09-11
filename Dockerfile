# Build phase
FROM nvidia/cuda:9.0-cudnn7-devel-ubuntu16.04 as builder

ENV darknet_commit=57e878b

WORKDIR /root/build
COPY darknet-alexeyab.patch .
RUN apt-get -y update && \
	apt-get -y install git build-essential && \
	git clone https://github.com/AlexeyAB/darknet.git && \
	cd darknet && \
	git checkout $darknet_commit && \
	git apply ../darknet-alexeyab.patch && \
	make

# Final Image
FROM nvidia/cuda:9.0-cudnn7-runtime-ubuntu16.04

WORKDIR /root
COPY --from=builder /root/build/darknet/darknet ./staging/

RUN mv staging/darknet /usr/local/bin && \
	rm -rf staging
