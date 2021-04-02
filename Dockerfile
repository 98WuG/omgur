# Builder
FROM docker.io/golang:1.16-alpine AS builder

RUN mkdir /build
COPY . /build/
WORKDIR /build
ENV CGO_ENABLED=0 \
    GOOS=linux
RUN go mod init git.geraldwu.com/gerald/omgur &&\
    go mod tidy &&\
    go build -v -a ./cmd/omgur

# Clean image
FROM docker.io/alpine:latest
RUN apk --no-cache add ca-certificates
COPY --from=builder /build .

USER nobody:nobody

CMD ["./omgur"]
EXPOSE 8080
