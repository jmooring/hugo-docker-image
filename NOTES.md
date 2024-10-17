# Development notes

You may need to restart Docker Engine before building the image. It looks like the daemon periodically loses its network connection or DNS, producing messages such as "could not resolve github.com."

```test
sudo service docker restart
```

## Commands

To build and push images to Docker Hub, use the `build.sh` script in this repository.

To build an image for testing:

```text
docker image build --tag veriphor/hugo .
```

To capture the build log:

```text
docker image build --tag veriphor/hugo . &> build.log
```

To run the container interactively to inspect:

```text
docker run --rm -v .:/project -v $HOME/.cache/hugo_cache:/cache -u $(id -u):$(id -g) --network host -it veriphor/hugo
```

To run the container interactively as root to inspect:

```text
docker run --rm -v .:/project -v $HOME/.cache/hugo_cache:/cache --network host -it veriphor/hugo
```

To build a Hugo site, then run Pagefind:

```text
docker run --rm -v .:/project -v $HOME/.cache/hugo_cache:/cache -u $(id -u):$(id -g) --network host veriphor/hugo bash -c "hugo && pagefind --source public"
```

## Miscellaneous notes

See [README](README.md) for usage instructions and known limitations.

The commands above mount the host's `$HOME/.cache/hugo_cache` directory to the container's `/cache` directory. The project cache, both local (the `resources` directory) and user (`$HOME/.cache/hugo_cache`) is persistent.

The container does not know the name of the host's current working directory, so the user cache is always created in `$HOME/.cache/hugo_cache/project`.

If two or more projects create the same cache file, Hugo may invalidate the cache more frequently than expected if two projects set different `maxAge` values for the same cache.

## References

Dockerfile: <https://docs.docker.com/engine/reference/builder/>

Image labels: <https://github.com/opencontainers/image-spec/blob/main/annotations.md>
