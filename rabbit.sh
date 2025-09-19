#!/bin/bash

# --- 1. Backup RabbitMQ Data ---
# Backup RabbitMQ configuration and state (including queues, users, etc.)
# You can dump the entire RabbitMQ database to a file using the `rabbitmq-dump` command (optional plugin).
# Backup RabbitMQ State (e.g., queues, bindings, etc.)
rabbitmq-dump --output=/path/to/backup/rabbitmq_dump.json

# --- 2. Restore RabbitMQ Data ---
# Restore the RabbitMQ data from a backup file
rabbitmq-import --file=/path/to/backup/rabbitmq_dump.json

# --- 3. Monitor RabbitMQ Queues ---
# List all queues
rabbitmqctl list_queues

# Show the status of the queues, including message counts, consumers, etc.
rabbitmqctl list_queues name messages consumers

# --- 4. Monitor RabbitMQ Nodes ---
# Get the status of all RabbitMQ nodes
rabbitmqctl cluster_status

# Check the status of a specific RabbitMQ node
rabbitmqctl status

# --- 5. Check RabbitMQ Server Health ---
# Check if RabbitMQ server is running
rabbitmqctl status

# Check disk space usage of the RabbitMQ server
rabbitmqctl status | grep disk

# --- 6. Create a New Queue ---
# Create a new queue named "new_queue"
rabbitmqctl add_queue new_queue

# Create a queue with additional properties (e.g., durable, auto-delete)
rabbitmqctl add_queue --durable --auto-delete new_queue

# --- 7. Create a New Exchange ---
# Create a direct exchange named "new_exchange"
rabbitmqctl add_exchange direct new_exchange

# Create a fanout exchange
rabbitmqctl add_exchange fanout new_exchange

# --- 8. Bind Queue to Exchange ---
# Bind "new_queue" to "new_exchange"
rabbitmqctl bind_queue new_queue new_exchange

# --- 9. Publish a Message to a Queue ---
# Publish a message to a queue using `rabbitmqadmin` (or API)
rabbitmqadmin publish routing_key=new_queue payload="Hello, RabbitMQ!"

# --- 10. Delete a Queue ---
# Delete a queue named "old_queue"
rabbitmqctl delete_queue old_queue

# --- 11. Delete an Exchange ---
# Delete an exchange named "old_exchange"
rabbitmqctl delete_exchange old_exchange

# --- 12. Manage RabbitMQ Users ---

# List all RabbitMQ users
rabbitmqctl list_users

# Create a new user with specific permissions
rabbitmqctl add_user new_user new_password

# Set permissions for the new user on a virtual host (e.g., "/")
rabbitmqctl set_permissions -p / new_user ".*" ".*" ".*"

# Revoke user permissions
rabbitmqctl clear_permissions -p / new_user

# --- 13. Monitor Message Rates ---
# Get the message rate for each queue (messages published and consumed)
rabbitmqctl list_queues name messages_ready messages_unacknowledged

# --- 14. Set Queue TTL (Time-To-Live) ---
# Set a TTL (Time-To-Live) for messages in a specific queue
rabbitmqctl set_queue_ttl new_queue 60000 # TTL in milliseconds (60 seconds)

# --- 15. Set Queue Max Length ---
# Set a max length for a queue, after which the oldest messages will be discarded
rabbitmqctl set_queue_max_length new_queue 1000

# --- 16. Clean Up Old Data ---
# Purge all messages in a specific queue
rabbitmqctl purge_queue new_queue

# --- 17. RabbitMQ Connection Management ---
# List all active connections
rabbitmqctl list_connections

# Close a specific connection (e.g., connection from IP 192.168.1.100)
rabbitmqctl close_connection 192.168.1.100

# --- 18. Enable/Disable RabbitMQ Plugins ---
# List enabled plugins
rabbitmq-plugins list

# Enable a plugin (e.g., the management plugin)
rabbitmq-plugins enable rabbitmq_management

# Disable a plugin
rabbitmq-plugins disable rabbitmq_management

# --- 19. Check RabbitMQ Logs ---
# Check RabbitMQ logs for errors or important events
tail -f /var/log/rabbitmq/rabbitmq.log

# --- 20. Restart RabbitMQ Service ---
# Restart the RabbitMQ service if needed
systemctl restart rabbitmq-server

# --- 21. RabbitMQ Cluster Management ---
# Add a new node to the RabbitMQ cluster
rabbitmqctl join_cluster rabbit@new_node

# Stop a RabbitMQ node from the cluster
rabbitmqctl stop_app
rabbitmqctl reset
