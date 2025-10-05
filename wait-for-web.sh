#!/bin/bash
check_health_with_retry() {
    local max_time=10
    local interval=1
    local elapsed_time=0
    local container_name="ramen-shop-web-1"

    echo "Checking health for $container_name for a maximum of $max_time seconds..."

    while [ "$elapsed_time" -lt "$max_time" ]; do
        # 1. Check the health status using podman inspect and grep
	echo podman inspect --format='{{.State.Health.Status}}' "$container_name"
        if podman inspect --format='{{.State.Health.Status}}' "$container_name" 2>/dev/null | grep -q "healthy"; then
            echo "✅ Service is HEALTHY."
            return 0  # Exit the function successfully
        fi

        # 2. Wait and increment the elapsed time
        sleep "$interval"
        elapsed_time=$((elapsed_time + interval))
        echo "🚧 Status: Not healthy. Retrying in $interval second(s)... (Elapsed: $elapsed_time/$max_time s)"
    done

    echo "❌ Service did not become healthy within $max_time seconds. Last status check failed."
    return 1 # Exit the function with a failure code
}

# Run the function
check_health_with_retry

