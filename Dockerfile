FROM rust:alpine AS builder

WORKDIR /app

RUN apk add --no-cache --update \
  musl-dev \
  openssl-dev \
  perl \
  pkgconfig \
  make \
  ca-certificates \
  gcc

COPY Cargo.toml .
COPY src ./src

RUN cargo build --release

FROM alpine:latest

RUN apk add --no-cache --update ca-certificates
COPY --from=builder /app/target/release/docker-autoheal /usr/local/bin/docker-autoheal

HEALTHCHECK --interval=5s \
  CMD ["/usr/local/bin/docker-autoheal", "-h"]

ENTRYPOINT ["/usr/local/bin/docker-autoheal"]
