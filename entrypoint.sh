#!/bin/bash
set -e

echo "=== Starting entrypoint.sh ==="

# Remove a potentially pre-existing server.pid for Rails.
echo "Removing server.pid..."
rm -f /kotonoha/tmp/pids/server.pid

echo "Preparing databases..."
bundle exec rails db:prepare

echo "Loading Solid Queue schema..."
bundle exec rails runner "ActiveRecord::Base.configurations.configs_for(env_name: Rails.env, name: 'queue').first.tap { |db_config| ActiveRecord::Base.establish_connection(db_config.configuration_hash); load Rails.root.join('db/queue_schema.rb') }"

echo "=== entrypoint.sh completed ==="

# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"
