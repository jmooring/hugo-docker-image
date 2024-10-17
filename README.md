# Hugo Docker Image

This image contains [Hugo](https://gohugo.io/) and its optional runtime dependencies: Asciidoctor, Dart Sass, Git, Go, Node.js, Pandoc, and Rst2html. It also contains the standard and extended editions of [Pagefind](https://pagefind.app/), a static search library by [Cloud Cannon](https://cloudcannon.com/).

## Usage

To run the container in your development environment:

1. Create an alias in `$HOME/.bash_aliases`:

   ```test
   alias dhugo='docker run --rm -v .:/project -v $HOME/.cache/hugo_cache:/cache -u $(id -u):$(id -g) --network host veriphor/hugo hugo'
   ```

   By aliasing the docker command to `dhugo` instead of `hugo` you can use your existing installation and this image side-by-side.

2. Source the changes to your alias file and create the cache directory:

   ```text
   source $HOME/.bash_aliases
   mkdir -p $HOME/.cache/hugo_cache
   ```

3. Navigate to your project directory, then view or build your site:

   ```text
   dhugo server  # view
   dhugo         # build
   ```

To display a list of installed applications:

```text
docker run --rm veriphor/hugo info
```

## Notes

The container can access two directories on the host: the current working directory and `$HOME/.cache/hugo_cache`. This intentional confinement imposes the following restrictions:

1. You must run `hugo` from the root of the project directory; you cannot use the `--source` flag.
2. You cannot run `hugo deploy` due to lack of access to service credentials typically stored in your `$HOME` directory.

The project cache, both local (the `resources` directory) and user (`$HOME/.cache/hugo_cache`) is persistent.

This image also contains Python 3 (a dependency of Rs2html) and Ruby (a dependency of Asciidoctor).
