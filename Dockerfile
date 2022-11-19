FROM --platform=$BUILDPLATFORM registry.ci.openshift.org/openshift/release:golang-1.18 as builder

WORKDIR /workspace
COPY go.mod go.mod
COPY go.sum go.sum
RUN go mod download

COPY main.go main.go

ARG TARGETOS
ARG TARGETARCH
RUN CGO_ENABLED=0 GOOS=$TARGETOS GOARCH=$TARGETARCH go build -a -o htpasswd main.go

FROM alpine as runner
COPY --from=builder  /go/htpasswd/bin/ /
CMD ["./htpasswd"]