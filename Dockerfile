FROM golang:1.5.3
MAINTAINER Facundo Bianco <vando [at] van [dot] do>

ENV SASS_LIBSASS_PATH /usr/local/src/libsass
ENV GOPATH /go
ENV GO15VENDOREXPERIMENT 1
ENV DATABASE_DRIVER sqlite3
ENV DATABASE_CONFIG /var/lib/drone/drone.sqlite

WORKDIR /usr/local/src

ADD https://www.sqlite.org/2015/sqlite-autoconf-3081101.tar.gz /usr/local/src/
RUN tar zxvf sqlite-autoconf-3081101.tar.gz
RUN cd sqlite-autoconf-3081101 && \
    ./configure --prefix=/scratch/usr/local && \
    make && make install

RUN git clone --depth=1 git://github.com/sass/libsass.git
RUN git clone --depth=1 git://github.com/sass/sassc.git
RUN cd sassc && make && install -t /usr/local/bin bin/sassc

RUN git clone --depth=1 git://github.com/mattn/go-sqlite3.git /go/src/github.com/mattn/go-sqlite3
RUN git clone --depth=1 git://github.com/drone/drone.git /go/src/github.com/drone/drone
RUN go install github.com/mattn/go-sqlite3

WORKDIR /go/src/github.com/drone/drone
RUN make deps && make gen && make build
RUN cp drone /usr/local/bin/

EXPOSE 8000
ENTRYPOINT ["/usr/local/bin/drone"]
