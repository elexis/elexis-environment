#!/usr/bin/env bash
# Helper functions used by backup / restore

function sepline() {
    echo "#####################################################################################"
}

function assert_docker_stopped() {
    echo "## Checking EE docker runstates ..."
    IFS=$'\n'
    CONTAINER_STATUS=$(docker ps -a --filter label=com.docker.compose.project=elexis-environment --format "{{.ID}} \"{{.Status}}\" {{.Names}}")
    for container in $CONTAINER_STATUS; do
        if [[ $container == *"\"Up "* ]]; then
            echo "!!!! RUNNING CONTAINER: $container"
            echo "!!!! A container is still running, you have to stop all containers before executing this script."
            echo "!!!! Exiting."
            exit 0
        fi
    done
}

function fetch_current_backup_tool() {
    echo "## Fetching updated docker backup tool ..."
    docker pull -q loomchild/volume-backup
}
