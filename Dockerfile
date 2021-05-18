FROM alpine:3.12.7 as build-swftools
LABEL maintainer "calpismate"

ENV SWFTOOLS_VERSION "0.9.2"
RUN apk add --no-cache --repository http://dl-3.alpinelinux.org/alpine/edge/testing \
        autoconf \
        automake \
        fftw-dev \
        g++ \
        gcc \
        libc6-compat \
        libtool \
        make \
        nasm \
        vips-dev \
    && wget http://swftools.org/swftools-${SWFTOOLS_VERSION}.tar.gz \
    && tar xf swftools-${SWFTOOLS_VERSION}.tar.gz \
    && cd swftools-${SWFTOOLS_VERSION} \
    && LIBRARY_PATH=/lib:/usr/lib ./configure \
    && make \
    && sed -e 's/-o -L/#-o -L/' -i swfs/Makefile \
    && make install \
    && cd ../ \
    && rm -rf swftools-${SWFTOOLS_VERSION}


FROM golang:1.16.4-alpine3.13
LABEL maintainer "calpismate"

ENV GO11MODULE "on"
RUN mkdir -p /app

RUN apk add --no-cache tzdata \
    && cp /usr/share/zoneinfo/Asia/Tokyo /etc/localtime \
    && apk del tzdata 

RUN apk add --no-cache --repository http://dl-3.alpinelinux.org/alpine/edge/testing \
        curl \
        ffmpeg \
        git \
        libxml2-utils \
        perl \
        rtmpdump 

WORKDIR /app

COPY --from=build-swftools /usr/local/bin/swfextract /usr/local/bin/
COPY config.go /app/config.go
COPY converter.go /app/converter.go
COPY copy.go /app/copy.go
COPY copy_test.go /app/copy_test.go
COPY main.go /app/main.go
COPY podcast.go /app/podcast.go
COPY radicast.go /app/radicast.go
COPY radiko.go /app/radiko.go
COPY server.go /app/server.go
COPY go.mod /app/go.mod
COPY go.sum /app/go.sum

RUN go mod download \
    && go build

ENTRYPOINT ["./radicast"]
CMD ["--help"]
