#!/usr/bin/env bash
APP_DIR=/var/apps/omotenashi-pf-provision
cd ${APP_DIR}

APP_ENV=development
if [ $# == 1 ]; then
  APP_ENV=$1
fi

# build
docker-compose -f docker-compose.${APP_ENV}.yml build

# bundle install
docker-compose -f docker-compose.${APP_ENV}.yml run --rm api bash -c "bundle install"
docker-compose -f docker-compose.${APP_ENV}.yml run --rm anon bash -c "bundle install"
docker-compose -f docker-compose.${APP_ENV}.yml run --rm auth bash -c "bundle install"
docker-compose -f docker-compose.${APP_ENV}.yml run --rm api-job bash -c "bundle install"
docker-compose -f docker-compose.${APP_ENV}.yml run --rm anon-job bash -c "bundle install"

if [ "${APP_ENV}" == "development" ]; then
  docker-compose -f docker-compose.${APP_ENV}.yml run --rm redis-gem bash -c "bundle install"
  # sql initialize
  docker-compose -f docker-compose.${APP_ENV}.yml run --rm mssql bash -c 'pass="ais5xu4I" /opt/mssql-tools/bin/sqlcmd -S mssql -U SA -P 'P@ssw0rd2017' -i /sqls/init.sql -W'
fi

# rails migration
docker-compose -f docker-compose.${APP_ENV}.yml run --rm api bash -c "bundle exec rake db:schema:load"
docker-compose -f docker-compose.${APP_ENV}.yml run --rm anon bash -c "bundle exec rake db:schema:load"

# seed data
docker-compose -f docker-compose.${APP_ENV}.yml run --rm api bash -c  "bundle exec rake db:seed_fu"
docker-compose -f docker-compose.${APP_ENV}.yml run --rm anon bash -c  "bundle exec rake db:seed_fu"

# auth assets compile
docker-compose -f docker-compose.${APP_ENV}.yml run --rm auth bash -c "bundle exec rake assets:precompile"

# docker up
docker-compose -f docker-compose.${APP_ENV}.yml up -d
