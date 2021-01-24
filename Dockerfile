FROM arm64v8/golang
MAINTAINER hmxrobert 

#ENV GOROOT /usr/lib/go
#ENV GOPATH /go
#ENV PATH $GOROOT/bin:$GOPATH/bin:$PATH
ENV TZ='Asia/Tokyo'

RUN apt-get update && apt-get upgrade -y && apt-get -y install git \
    && apt-get -y install bash ca-certificates tzdata rtmpdump ffmpeg zlib1g-dev
RUN curl http://www.swftools.org/swftools-0.9.2.tar.gz | tar xz -C /tmp \
    && curl -o /tmp/swftools-0.9.2/config.guess "http://git.savannah.gnu.org/gitweb/?p=config.git;a=blob_plain;f=config.guess;hb=HEAD" \
    && curl -o /tmp/swftools-0.9.2/config.sub "http://git.savannah.gnu.org/gitweb/?p=config.git;a=blob_plain;f=config.sub;hb=HEAD" \
    && chmod 755 /tmp/swftools-0.9.2/config.guess \
    && chmod 755 /tmp/swftools-0.9.2/config.sub \
    && cd /tmp/swftools-0.9.2 && ./configure && make \
    && mv /tmp/swftools-0.9.2/src/swfextract /usr/local/bin/ \
    && rm -r /tmp/swftools-0.9.2
RUN go get -v github.com/hmxrobert/radicast

# COPY ./radicast /go/bin/

ENTRYPOINT [ "radicast" ]
CMD [ "--help" ]
