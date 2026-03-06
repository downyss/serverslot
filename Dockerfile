# Tahap Build
FROM golang:1.25-bookworm AS build
WORKDIR /go/src/github.com/slotopol/server
COPY go.mod go.sum ./
RUN go mod download
COPY . .
# Build dengan tags dan output langsung ke folder /go/bin/app
RUN go build -tags "full keno agt aristocrat betsoft ct igt megajack netent novomatic" -o /go/bin/app main.go

# Tahap Deploy
FROM debian:bookworm-slim
# Install library SSL agar tidak error saat konek database cloud
RUN apt-get update && apt-get install -y ca-certificates && rm -rf /var/lib/apt/lists/*
COPY --from=build /go/bin/app /go/bin/app
# Copy folder config dan appdata jika diperlukan aplikasi
COPY --from=build /go/src/github.com/slotopol/server/config /config
COPY --from=build /go/src/github.com/slotopol/server/appdata /appdata

EXPOSE 8080
ENTRYPOINT ["/go/bin/app"]
CMD ["-v", "web"]
