#!/usr/bin/env puma

directory "/usr/local//{{ HOST_ID }}/current"
rackup "/usr/local//{{ HOST_ID }}/current/config.ru"

worker_timeout 60
pidfile File.expand_path('tmp/pids/puma.pid')
state_path File.expand_path('tmp/pids/puma.state')
stdout_redirect File.expand_path('log/puma_access.log'), File.expand_path('log/puma_error.log'), true

threads_count = 5
threads threads_count, threads_count

workers 2

environment '{{ STAGE }}'

bind "unix:///usr/local//{{ HOST_ID }}/shared/tmp/sockets/puma.sock"

prune_bundler

on_restart do
  ENV['BUNDLE_GEMFILE'] = "/usr/local//{{ HOST_ID }}/current/Gemfile"
end
