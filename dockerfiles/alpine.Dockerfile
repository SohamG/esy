FROM esydev/esy-dev:alpine as esy-builder
COPY --from=esydev/esy-dev:alpine /app /app
WORKDIR /app

# This section useful for debugging the image/container
# RUN env LD_LIBRARY_PATH=/usr/lib make opam-setup SUDO=''
# RUN env LD_LIBRARY_PATH=/usr/lib make build-with-opam SUDO=''
# RUN env LD_LIBRARY_PATH=/usr/lib make build-with-esy SUDO=''
# RUN env LD_LIBRARY_PATH=/usr/lib make opam-cleanup SUDO=''
# RUN env LD_LIBRARY_PATH=/usr/lib make install-esy-artifacts SUDO=''

# The statements above cannot be used as is because CI disks run out of space
# Which is why we use a single command that builds and cleans up in the same run step.
# This is because docker caches results of multiple steps - having everything in one step
# (that also cleans up build cache) takes lesser space.
COPY ./bin /app/
COPY ./esy-shell-expansion /app/esy-shell-expansion
COPY ./esy-solve /app/esy-solve
COPY ./esy-fetch /app/esy-fetch
COPY ./esy-install-npm-release /app/esy-install-npm-release
COPY ./esy-solve-cudf /app/esy-solve-cudf
COPY ./esy-primitives /app/esy-primitives
COPY ./esy-build /app/esy-build
COPY ./esy-lib /app/esy-lib
COPY ./esy-build-package /app/esy-build-package
COPY ./esy-command-expression /app/esy-command-expression
COPY ./esy-package-config /app/esy-package-config
COPY dune* /app/
COPY esy.json esy.lock /app/
COPY static.json static.esy.lock /app/
COPY vendors /app
RUN make docker

# FROM alpine:latest

# COPY --from=builder /usr/local /usr/local
# COPY --from=builder /app/_release /app/_release
# RUN apk add nodejs npm linux-headers curl git perl-utils bash gcc g++ musl-dev make m4 patch
