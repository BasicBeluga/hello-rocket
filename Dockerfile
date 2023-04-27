FROM rust:alpine3.17 as builder
WORKDIR /app

RUN apk add --no-cache musl-dev

RUN rustup default stable

COPY Cargo.toml .
COPY Cargo.lock .

RUN mkdir src && echo "// dummy file" > src/lib.rs && cargo fetch

COPY /src /app/src

RUN cargo build --release

FROM scratch

ENV ROCKET_ADDRESS=0.0.0.0
ENV ROCKET_PORT=8000

WORKDIR /app
COPY --from=builder /app/target/release/hello-rocket .
CMD ["/app/hello-rocket"]

