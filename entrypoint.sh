#!/bin/bash
set -e

echo "=== Starting entrypoint.sh ==="

# Remove a potentially pre-existing server.pid for Rails.
echo "Removing server.pid..."
rm -f /kotonoha/tmp/pids/server.pid

# マイグレーションを実行
echo "Running database migrations..."
bundle exec rails db:migrate

echo "=== entrypoint.sh completed ==="

# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"
