# Stage 1: Build
FROM golang:1.25-bookworm AS build
WORKDIR /go/src/github.com/slotopol/server
COPY go.mod go.sum ./
RUN go mod download
COPY . .
# Kita build main.go menjadi file bernama 'app'
RUN go build -tags "full keno agt aristocrat betsoft ct igt megajack netent novomatic" -o /go/bin/app main.go

# Stage 2: Run
FROM debian:bookworm-slim
# Tambahkan library dasar agar binary Go bisa jalan
RUN apt-get update && apt-get install -y ca-certificates && rm -rf /var/lib/apt/lists/*
WORKDIR /root/
# Ambil file binary dari stage build
COPY --from=build /go/bin/app /usr/local/bin/app
# Copy folder penting agar tidak 404
COPY --from=build /go/src/github.com/slotopol/server/config ./config
COPY --from=build /go/src/github.com/slotopol/server/appdata ./appdata

EXPOSE 8080
# Jalankan aplikasi langsung dari folder bin
ENTRYPOINT ["/usr/local/bin/app"]
CMD ["-v", "web"]
