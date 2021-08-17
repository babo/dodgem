FROM ubuntu:20.04 as builder

WORKDIR /src

RUN ln -sf /usr/share/zoneinfo/Etc/GMT /etc/localtime && \
    export DEBIAN_FRONTEND=noninteractive && \
    apt update && \
    apt install -y \
            automake \
            autotools-dev \
            build-essential \
            git \
            libcurl4-openssl-dev \
            libjansson-dev \
            libssl-dev \
            nvidia-cuda-dev \
            nvidia-cuda-toolkit \
    && \
    git clone https://github.com/tpruvot/ccminer.git && \
    cd ccminer && \
    ./build.sh

FROM ubuntu:20.04

RUN apt update && \
    apt install -y libcurl4 libjansson4 libcudart10.1 libgomp1

COPY --from=builder /src/ccminer/ccminer /usr/local/bin/

ENTRYPOINT /usr/local/bin/ccminer
