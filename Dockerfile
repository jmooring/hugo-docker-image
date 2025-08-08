ARG VERSION_DART_SASS=1.90.0
ARG VERSION_GO=1.24.5
ARG VERSION_HUGO=0.148.2
ARG VERSION_NODE=22.18.0
ARG VERSION_PAGEFIND=1.1.1
ARG VERSION_UBUNTU=24.04

# Base image
FROM ubuntu:${VERSION_UBUNTU}

# Default shell
SHELL ["/bin/bash", "-c"]

# Working directory
WORKDIR /project

# Install utilities
RUN apt update && \
    apt upgrade -y && \
    apt install -y --no-install-recommends ruby brotli curl git lsb-release pandoc python3-docutils shared-mime-info xz-utils zstd && \
    apt clean

# Install gems
RUN gem install asciidoctor

# Configure Git
RUN git config --system --add safe.directory '*' && \
    git config --system --add core.quotepath false

# Install Pagefind (regular and extended)
ARG VERSION_PAGEFIND
RUN curl -LJO "https://github.com/CloudCannon/pagefind/releases/download/v${VERSION_PAGEFIND}/pagefind-v${VERSION_PAGEFIND}-x86_64-unknown-linux-musl.tar.gz" && \
    tar -C /usr/local/bin -xf "pagefind-v${VERSION_PAGEFIND}-x86_64-unknown-linux-musl.tar.gz" && \
    rm "pagefind-v${VERSION_PAGEFIND}-x86_64-unknown-linux-musl.tar.gz" && \
    curl -LJO "https://github.com/CloudCannon/pagefind/releases/download/v${VERSION_PAGEFIND}/pagefind_extended-v${VERSION_PAGEFIND}-x86_64-unknown-linux-musl.tar.gz" && \
    tar -C /usr/local/bin -xf "pagefind_extended-v${VERSION_PAGEFIND}-x86_64-unknown-linux-musl.tar.gz" && \
    rm "pagefind_extended-v${VERSION_PAGEFIND}-x86_64-unknown-linux-musl.tar.gz"

# Install Node.js
ARG VERSION_NODE
RUN curl -LJO "https://nodejs.org/dist/v${VERSION_NODE}/node-v${VERSION_NODE}-linux-x64.tar.xz" && \
    tar -C /usr/local -xf "node-v${VERSION_NODE}-linux-x64.tar.xz" && \
    rm "node-v${VERSION_NODE}-linux-x64.tar.xz"
ENV PATH="${PATH}:/usr/local/node-v${VERSION_NODE}-linux-x64/bin"

# Install Go
ARG VERSION_GO
RUN curl -LJO "https://go.dev/dl/go${VERSION_GO}.linux-amd64.tar.gz" && \
    tar -C /usr/local -xf "go${VERSION_GO}.linux-amd64.tar.gz" && \
    rm "go${VERSION_GO}.linux-amd64.tar.gz"
ENV PATH="${PATH}:/usr/local/go/bin"

# Install Dart Sass
ARG VERSION_DART_SASS
RUN curl -LJO "https://github.com/sass/dart-sass/releases/download/${VERSION_DART_SASS}/dart-sass-${VERSION_DART_SASS}-linux-x64.tar.gz" && \
    tar -C /usr/local -xf "dart-sass-${VERSION_DART_SASS}-linux-x64.tar.gz" && \
    rm "dart-sass-${VERSION_DART_SASS}-linux-x64.tar.gz"
ENV PATH="${PATH}:/usr/local/dart-sass"

# Install Hugo
ARG VERSION_HUGO
RUN curl -LJO "https://github.com/gohugoio/hugo/releases/download/v${VERSION_HUGO}/hugo_extended_${VERSION_HUGO}_linux-amd64.tar.gz" && \
    mkdir /usr/local/hugo && \
    tar -C /usr/local/hugo -xf "hugo_extended_${VERSION_HUGO}_linux-amd64.tar.gz" && \
    rm "hugo_extended_${VERSION_HUGO}_linux-amd64.tar.gz"
ENV PATH="${PATH}:/usr/local/hugo"
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
