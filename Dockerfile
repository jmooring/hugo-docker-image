ARG VERSION_DART_SASS=1.85.0
ARG VERSION_GO=1.24.0
ARG VERSION_HUGO=0.144.1
ARG VERSION_NODE=22.x
ARG VERSION_PAGEFIND=1.1.1
ARG VERSION_UBUNTU=24.04

# Base image
FROM ubuntu:${VERSION_UBUNTU}

# Default shell
SHELL ["/bin/bash", "-c"]

# Working directory
WORKDIR /project

# Intall utilities
RUN apt update && \
    apt upgrade -y && \
    apt install -y --no-install-recommends ruby brotli curl git lsb-release pandoc python3-docutils shared-mime-info && \
    apt clean

# Install gems
RUN gem install asciidoctor

# Configure Git
RUN git config --system --add safe.directory '*' && \
    git config --system --add core.quotepath false

# Intall Pagefind (regular and extended)
ARG VERSION_PAGEFIND
RUN curl -LJO https://github.com/CloudCannon/pagefind/releases/download/v${VERSION_PAGEFIND}/pagefind-v${VERSION_PAGEFIND}-x86_64-unknown-linux-musl.tar.gz && \
    tar -C /usr/local/bin -xzf pagefind-v${VERSION_PAGEFIND}-x86_64-unknown-linux-musl.tar.gz && \
    rm pagefind-v${VERSION_PAGEFIND}-x86_64-unknown-linux-musl.tar.gz && \
    curl -LJO https://github.com/CloudCannon/pagefind/releases/download/v${VERSION_PAGEFIND}/pagefind_extended-v${VERSION_PAGEFIND}-x86_64-unknown-linux-musl.tar.gz && \
    tar -C /usr/local/bin -xzf pagefind_extended-v${VERSION_PAGEFIND}-x86_64-unknown-linux-musl.tar.gz && \
    rm pagefind_extended-v${VERSION_PAGEFIND}-x86_64-unknown-linux-musl.tar.gz

# Intall Node.js
ARG VERSION_NODE
RUN apt install -y ca-certificates curl gnupg && \
    mkdir -p /etc/apt/keyrings && \
    curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg && \
    echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_${VERSION_NODE} nodistro main" | tee /etc/apt/sources.list.d/nodesource.list && \
    apt update && \
    apt install nodejs -y && \
    mkdir /.npm && \
    chmod 777 /.npm

# Intall Go
ARG VERSION_GO
RUN curl -LJO https://go.dev/dl/go${VERSION_GO}.linux-amd64.tar.gz && \
    tar -C /usr/local -xzf go${VERSION_GO}.linux-amd64.tar.gz && \
    rm go${VERSION_GO}.linux-amd64.tar.gz
ENV PATH="$PATH:/usr/local/go/bin"

# Intall Dart Sass
ARG VERSION_DART_SASS
RUN curl -LJO https://github.com/sass/dart-sass/releases/download/${VERSION_DART_SASS}/dart-sass-${VERSION_DART_SASS}-linux-x64.tar.gz && \
    tar -xf dart-sass-${VERSION_DART_SASS}-linux-x64.tar.gz && \
    cp -r dart-sass/ /usr/local/bin && \
    rm -rf dart-sass*
ENV PATH="$PATH:/usr/local/bin/dart-sass"

# Install Hugo
ARG VERSION_HUGO
RUN curl -LJO https://github.com/gohugoio/hugo/releases/download/v${VERSION_HUGO}/hugo_extended_${VERSION_HUGO}_linux-amd64.deb && \
    apt install -y ./hugo_extended_${VERSION_HUGO}_linux-amd64.deb && \
    rm hugo_extended_${VERSION_HUGO}_linux-amd64.deb
ENV HUGO_CACHEDIR="/cache"
ENV HUGO_SECURITY_EXEC_ALLOW="^(asciidoctor|babel|git|go|npx|pandoc|postcss|rst2html|sass|tailwindcss)$"

# Copy scripts
COPY --chmod=755 info.sh /usr/local/bin/info

# Labels
LABEL com.veriphor.hugo.documentation="https://gohugo.io/documentation/"
LABEL com.veriphor.hugo.license="Apache-2.0"
LABEL com.veriphor.hugo.source="https://github.com/gohugoio/hugo"
LABEL com.veriphor.hugo.version="${VERSION_HUGO}"
LABEL org.opencontainers.image.authors="Joe Mooring <joe.mooring@veriphor.com>"
LABEL org.opencontainers.image.description="Hugo is a static site generator written in Go, optimized for speed and designed for flexibility."
LABEL org.opencontainers.image.documentation="https://hub.docker.com/r/veriphor/hugo"
LABEL org.opencontainers.image.title="Hugo"
LABEL org.opencontainers.image.url="https://hub.docker.com/r/veriphor/hugo"
LABEL org.opencontainers.image.vendor="Veriphor LLC"
LABEL org.opencontainers.image.version="${VERSION_HUGO}"
