#!/bin/bash

# --- 1. Database Backup (RDB Snapshot) ---
# Create a snapshot of the Redis database using the "SAVE" or "BGSAVE" command.
# "SAVE" blocks Redis until the snapshot is complete, while "BGSAVE" runs the snapshot in the background.

# Force a snapshot (RDB backup)
redis-cli SAVE

# Alternatively, run a background save (RDB backup)
redis-cli BGSAVE

# The snapshot will be saved to the configured `dir` and `dbfilename` in redis.conf, typically `/var/lib/redis/dump.rdb`.

# --- 2. Database Restore ---
# To restore a Redis backup, just stop Redis, replace the `dump.rdb` file with your backup, and then restart Redis.
# For example:
# cp /path/to/backup/dump.rdb /var/lib/redis/dump.rdb
# systemctl restart redis

# --- 3. Monitor Long-Running Commands ---

# To monitor Redis operations in real-time:
redis-cli MONITOR

# Monitor commands that are taking too long:
# You can use `redis-cli` to manually observe slow operations (long-running commands).
# Example: Enable slowlog to track long-running commands (longer than 100ms).
redis-cli slowlog sub 100

# --- 4. Check Database Size ---
# Get information on the current database.
redis-cli INFO memory

# Get the total number of keys in the current Redis database.
redis-cli DBSIZE

# --- 5. Check for Expired Keys ---
# List all keys that have expired (if TTL is set)
redis-cli --scan | while read key; do
  ttl=$(redis-cli TTL "$key")
  if [ "$ttl" -le 0 ]; then
    echo "Expired key: $key"
  fi
done

# --- 6. Verify Data Integrity ---
# Check if specific keys exist in the database
redis-cli EXISTS "your_key"

# --- 7. Schema Update (Modify Data Structures) ---

# Example: Add a field to a hash (Modify schema)
redis-cli HSET your_hash field_name "new_value"

# Example: Add a value to a list
redis-cli RPUSH your_list "new_item"

# Example: Add an element to a set
redis-cli SADD your_set "new_element"

# Example: Set a new key with a value (or update an existing key)
redis-cli SET "new_key" "new_value"

# --- 8. Insert Test Data ---
# Insert test data into a Redis data structure
redis-cli SET "test_key" "test_value"
redis-cli HSET "test_hash" "field1" "value1"
redis-cli RPUSH "test_list" "item1" "item2"

# --- 9. Rollback Changes ---
# Example: Delete the test data (rollback)
redis-cli DEL "test_key"
redis-cli HDEL "test_hash" "field1"
redis-cli LPOP "test_list"

# --- 10. User Management ---
# Redis doesn't have built-in user management for simple setups, but in Redis 6+ you can manage users and access control using ACLs.

# Example: Create a new user with specific permissions
redis-cli ACL SETUSER new_user on >password ~* +@all

# Example: View all users
redis-cli ACL LIST

# Example: Revoke user access
redis-cli ACL DELUSER old_user

# --- 11. Clean Up Old Data ---
# Delete keys older than a certain timestamp (if TTL is used)
redis-cli --scan | while read key; do
  ttl=$(redis-cli TTL "$key")
  if [ "$ttl" -lt 0 ]; then
    redis-cli DEL "$key"
    echo "Deleted key: $key"
  fi
done

# --- 12. Drop Unused Keys ---
# Drop a key (or multiple keys)
redis-cli DEL "old_key"

# Drop all keys (clear the database)
redis-cli FLUSHDB

# --- 13. Monitoring & Alerts ---
# Enable slowlog to log commands that take more than 100ms to execute.
redis-cli slowlog reset
redis-cli slowlog get 10

# Example: Check Redis server stats
redis-cli INFO server

# --- 14. Set Expiration Times (TTL) ---
# Set a key to expire in 60 seconds
redis-cli SET "temp_key" "value" EX 60

# --- 15. Rollback Schema/Data Changes ---
# In case of an erroneous update, rollback by deleting or modifying the keys
redis-cli DEL "new_key"
redis-cli HDEL "your_hash" "field_name"
