FROM golang:1.21-alpine AS builder
WORKDIR /app

# Install build dependencies only if needed
RUN apk add --no-cache git gcc musl-dev

# Copy go mod files first for better caching
COPY go.mod go.sum ./
RUN go mod download

# Copy source code
COPY . .

# Build with optimizations for faster compilation and smaller binary
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -ldflags '-s -w' -o main .

# Final stage
FROM alpine:latest
RUN apk --no-cache add ca-certificates
WORKDIR /root/
COPY --from=builder /app/main .
COPY --from=builder /app/app/templates ./app/templates
EXPOSE 8080
CMD ["./main"]