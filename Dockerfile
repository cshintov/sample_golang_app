FROM golang:1.17-buster AS base

LABEL maintainer="Shinto C V <cshintov@gmail.com>"

RUN apt-get update && apt-get install -y openssh-server

WORKDIR /app

RUN groupadd -g 1001 shinto
RUN useradd --create-home --shell /bin/bash -u 1001 -g 1001 shinto
RUN usermod -aG sudo shinto
# RUN mkdir -p /go/pkg/mod

RUN mkdir -p -m 0700 ~/.ssh && ssh-keyscan github.com >> ~/.ssh/known_hosts
RUN git config --global --add url."git@github.com:".insteadOf "https://github.com/"

ENV GO_ENABLED=0
COPY go.* .

RUN --mount=type=ssh \
    --mount=type=cache,target=/go/pkg/mod \
    go mod download

RUN --mount=target=. \
    --mount=type=ssh \
    --mount=type=cache,target=/root/.cache/go-build \  
    --mount=type=cache,target=/go/pkg/mod \
    go build .

RUN chown -R shinto:shinto /go
USER shinto
EXPOSE 3000


FROM golang:1.17-buster AS app
WORKDIR /app
COPY --from=base /app/main ./
