# Global ARGs
ARG VERSION_DART_SASS=1.97.1
ARG VERSION_GO=1.25.5
ARG VERSION_HUGO=0.153.4
ARG VERSION_NODE=24.12.0
ARG VERSION_PAGEFIND=1.4.0
ARG VERSION_PANDOC=3.1.11

# Stage 1: Builder
FROM debian:bookworm-slim AS builder

ARG VERSION_DART_SASS
ARG VERSION_GO
ARG VERSION_HUGO
ARG VERSION_NODE
ARG VERSION_PAGEFIND
ARG VERSION_PANDOC

RUN apt-get update && apt-get install -y curl xz-utils

WORKDIR /extract

RUN curl -L https://github.com/CloudCannon/pagefind/releases/download/v${VERSION_PAGEFIND}/pagefind_extended-v${VERSION_PAGEFIND}-x86_64-unknown-linux-musl.tar.gz | tar -xz && \
    mkdir node && curl -L https://nodejs.org/dist/v${VERSION_NODE}/node-v${VERSION_NODE}-linux-x64.tar.xz | tar -xJ -C node --strip-components=1 && \
    curl -L https://go.dev/dl/go${VERSION_GO}.linux-amd64.tar.gz | tar -xz && \
    curl -L https://github.com/sass/dart-sass/releases/download/${VERSION_DART_SASS}/dart-sass-${VERSION_DART_SASS}-linux-x64.tar.gz | tar -xz && \
    mkdir hugo_bin && curl -L https://github.com/gohugoio/hugo/releases/download/v${VERSION_HUGO}/hugo_extended_${VERSION_HUGO}_linux-amd64.tar.gz | tar -xz -C hugo_bin && \
    curl -L -O "https://github.com/jgm/pandoc/releases/download/${VERSION_PANDOC}/pandoc-${VERSION_PANDOC}-linux-amd64.tar.gz" && tar -xzf "pandoc-${VERSION_PANDOC}-linux-amd64.tar.gz" --strip-components=1

RUN rm -rf /extract/go/src /extract/go/test /extract/go/doc /extract/go/api /extract/go/pkg/obj && \
    rm -rf /extract/node/share/doc /extract/node/share/man /extract/node/include

# -Stage 2: Final
FROM debian:bookworm-slim

ARG VERSION_HUGO

ENV PATH="/usr/local/lib/nodejs/bin:/usr/local/go/bin:/usr/local/dart-sass:/usr/local/bin:${PATH}"
ENV HUGO_CACHEDIR="/cache"
ENV HUGO_SECURITY_EXEC_ALLOW="^(asciidoctor|babel|git|go|npx|pandoc|postcss|rst2html|sass|tailwindcss)$"

WORKDIR /project

RUN apt-get update && apt-get install -y --no-install-recommends \
    ruby brotli curl git lsb-release python3-docutils shared-mime-info zstd \
    && gem install asciidoctor \
    && find /usr/lib/python3* -name '__pycache__' -exec rm -rf {} + \
    && rm -rf /root/.gem /usr/share/locale/* /usr/share/man/* /usr/share/doc/* \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

COPY --from=builder /extract/pagefind_extended /usr/local/bin/pagefind
COPY --from=builder /extract/hugo_bin/hugo /usr/local/bin/hugo
COPY --from=builder /extract/node/ /usr/local/lib/nodejs/
COPY --from=builder /extract/go/ /usr/local/go/
COPY --from=builder /extract/dart-sass/ /usr/local/dart-sass/
COPY --from=builder /extract/bin/pandoc /usr/local/bin/pandoc

RUN git config --system --add safe.directory '*' && \
    git config --system --add core.quotepath false

COPY --chmod=755 info.sh /usr/local/bin/info

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
