FROM --platform=$BUILDPLATFORM golang:1.18-alpine3.16 as builder

WORKDIR /workspace

COPY go.mod .
COPY main.go main.go

RUN go mod download
RUN go mod tidy

ARG TARGETOS
ARG TARGETARCH
RUN CGO_ENABLED=0 GOOS=$TARGETOS GOARCH=$TARGETARCH go build -a -o htpasswd main.go

FROM alpine as runner
COPY --from=builder  /workspace/htpasswd /htpasswd
CMD ["./htpasswd"]
