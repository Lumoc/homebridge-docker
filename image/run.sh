#!/bin/bash

cd /root/.homebridge

env_file="/root/.homebridge/.env"
install_file="/root/.homebridge/install.sh"
package_file="/root/.homebridge/package.json"
plugin_folder="/root/.homebridge/plugins"

# Include environment variables
# -------------------------------------------------------------------------
# See https://github.com/marcoraddatz/homebridge-docker#env-options
if [ -f "$env_file" ]
then
    echo "Including environment variables from $env_file."

    source $env_file

    echo "Environment is set to '$HOMEBRIDGE_ENV'."
else
    echo "$env_file not found."
    echo "Default env variables will be used."
fi

# (Re-) Install specific Homebridge version to avoid incompatible updates
# with either Homebridge or iOS.
# -------------------------------------------------------------------------
# See https://github.com/marcoraddatz/homebridge-docker#homebridge_version
if [ "$HOMEBRIDGE_VERSION" ]
then
    echo "Force the installation of Homebridge version '$HOMEBRIDGE_VERSION'."

    npm install -g "homebridge@${HOMEBRIDGE_VERSION}" --unsafe-perm
fi

# Install plugins via package.json
if [ -f "$package_file" ]
then
    echo "Installing plugins from $package_file."

    npm install
else
    echo "$package_file not found."
fi

# Install plugins via install.sh
if [ -f "$install_file" ]
then
    echo "Installing plugins from $install_file."

    /bin/bash $install_file
else
    echo "$install_file not found."
fi

rm -f /var/run/dbus/pid /var/run/avahi-daemon/pid

dbus-daemon --system
avahi-daemon -D

# Start Homebridge
if [ "$HOMEBRIDGE_ENV" ]
then
    case "$HOMEBRIDGE_ENV" in
        "debug-insecure" )
            DEBUG=* homebridge -I -D -P $plugin_folder ;;
        "development-insecure" )
            homebridge -I -P $plugin_folder ;;
        "production-insecure" )
            homebridge -I ;;
        "debug" )
            DEBUG=* homebridge -D -P $plugin_folder ;;
        "development" )
            homebridge -P $plugin_folder ;;
        "production" )
            homebridge ;;
    esac
else
    parallel ::: "homebridge" "homebridge -U ~/.homebridge-hue"
fi
