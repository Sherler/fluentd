FROM fluent/fluentd:v1.3.2-debian-onbuild-1.0

LABEL maintainer="George Sherler <wuzeilmt@gmail.com>"
USER root

# skip runtime bundler installation
ENV FLUENTD_DISABLE_BUNDLER_INJECTION 1

RUN buildDeps="sudo make gcc g++ libc-dev ruby-dev" \
   && apt-get update \
   && apt-get install -y --no-install-recommends $buildDeps \
   && sudo gem install fluent-plugin-remote_syslog \
   && sudo gem sources --clear-all \
   && SUDO_FORCE_REMOVE=yes \
      apt-get purge -y --auto-remove \
                  -o APT::AutoRemove::RecommendsImportant=false \
                  $buildDeps \
   && rm -rf /var/lib/apt/lists/* \
           /home/fluent/.gem/ruby/2.3.0/cache/*.gem

COPY ./conf/fluent.conf /fluentd/etc/

ENV FLUENTD_OPT=""
ENV FLUENTD_CONF="fluent.conf"