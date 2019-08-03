FROM golang:1.12.7-alpine3.10 AS builder
WORKDIR /app
COPY . .

# Install go dependencies
# RUN go get github.com/gorilla/mux && \
# go get github.com/gorilla/handlers && \

#build the go app
RUN go build -v -o ./app ./main.go

# Package into runtime image
FROM scratch
WORKDIR /app
# copy the executable from the builder image
COPY --from=builder /app/app .

EXPOSE 8080
ENTRYPOINT ["./app"]