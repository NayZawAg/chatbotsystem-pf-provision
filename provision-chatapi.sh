#!/usr/bin/env bash
APP_DIR=/var/apps/omotenashi-pf-provision
cd ${APP_DIR}

APP_ENV=development
if [ $# == 1 ]; then
  APP_ENV=$1
fi

# build
docker-compose -f docker-compose.chatapi-${APP_ENV}.yml build

# bundle install
docker-compose -f docker-compose.chatapi-${APP_ENV}.yml run --rm chatapi bash -c "bundle install"
# docker-compose -f docker-compose.chatapi-${APP_ENV}.yml run --rm chatapi-cronjob bash -c "bundle install"

if [ "${APP_ENV}" == "development" ]; then
  # sql initialize
  docker-compose -f docker-compose.chatapi-${APP_ENV}.yml run --rm mssql bash -c 'pass="ais5xu4I" /opt/mssql-tools/bin/sqlcmd -S mssql -U SA -P 'P@ssw0rd2017' -i /sqls/init-chatapi.sql -W'
fi

# rails migration
docker-compose -f docker-compose.chatapi-${APP_ENV}.yml run --rm chatapi bash -c "bundle exec rake db:schema:load"

# docker up
docker-compose -f docker-compose.chatapi-${APP_ENV}.yml up -d
