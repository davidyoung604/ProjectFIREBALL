FROM ruby:2.3-slim

# set up env vars
ENV BUILD_DEPS ruby-dev make gcc
ENV RUNTIME_DEPS git libsqlite3-dev nodejs
ENV SECRET_KEY_BASE $(RAILS_ENV=production rails secret)
ENV RAILS_ENV production
ENV RAILS_SERVE_STATIC_FILES true

# copy the app over
COPY . /fireball
# equivalent of "cd"
WORKDIR /fireball

# chaining these together to minimize image size
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y $RUNTIME_DEPS $BUILD_DEPS && \
    bundle install --without development test && \
    apt-get autoremove -y $BUILD_DEPS && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    rails db:setup && \
    rails assets:precompile

# start the server
CMD unicorn -l 0.0.0.0:8080
EXPOSE 8080
