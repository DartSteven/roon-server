#!/bin/bash

echo "Starting container."

# normalize and remove CR/LF
ROON_VERSION_RAW="${ROON_VERSION:-}"
ROON_VERSION_CLEAN="${ROON_VERSION_RAW,,}"            # lowercase
ROON_VERSION_CLEAN="${ROON_VERSION_CLEAN//$'\r'/}"    # remove CR
ROON_VERSION_CLEAN="${ROON_VERSION_CLEAN//$'\n'/}"    # remove LF

# allow explicit override of package URI
if [ -n "${ROON_PACKAGE_URI}" ]; then
  echo "Using explicit ROON_PACKAGE_URI=${ROON_PACKAGE_URI}"
else
  if [ "${ROON_VERSION_CLEAN}" = "earlyaccess" ]; then
    ROON_PACKAGE_URI="https://download.roonlabs.net/builds/earlyaccess/RoonServer_linuxx64.tar.bz2"
    echo "Selected EarlyAccess branch"
  else
    ROON_PACKAGE_URI="http://download.roonlabs.com/builds/RoonServer_linuxx64.tar.bz2"
    echo "Selected Stable branch"
  fi
fi

echo "Starting RoonServer with user $(whoami)"
echo "ROON_VERSION='${ROON_VERSION}'"
echo "Final ROON_PACKAGE_URI='${ROON_PACKAGE_URI}'"

# Install Roon if not present
if [ ! -f /opt/RoonServer/start.sh ]; then
  echo "Downloading Roon Server from ${ROON_PACKAGE_URI}"
  wget --tries=2 -O - "${ROON_PACKAGE_URI}" | tar -xvj --overwrite -C /opt
  if [ $? -ne 0 ]; then
    echo "Error: Unable to install Roon Server."
    exit 1
  fi
fi

echo "Verifying Roon installation"
/opt/RoonServer/check.sh
retval=$?
if [ ${retval} -ne 0 ]; then
  echo "Verification of Roon installation failed."
  exit ${retval}
fi

# Start Roon and forward signals
/opt/RoonServer/start.sh &
roon_start_pid=$!
trap 'kill -INT ${roon_start_pid}' SIGINT SIGQUIT SIGTERM
wait "${roon_start_pid}"
retval=$?
exit ${retval}
