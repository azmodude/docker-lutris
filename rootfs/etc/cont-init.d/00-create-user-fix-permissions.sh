#!/usr/bin/with-contenv /bin/bash

me=$(basename "$0")

>&2 echo "[${me}] Adding runuser with UID ${USER_UID}."
useradd -c 'Run User' -s /bin/bash -m -u "${USER_UID}" \
    runuser > /dev/null
>&2 echo "[${me}] Changing group users to GID ${USER_GID} and adding runuser to it."
(groupmod -g "${USER_GID}" users && usermod -g users runuser) > /dev/null
>&2 echo "[${me}] Adding runuser to video group ${VIDEO_GID}."
(groupmod -g "${VIDEO_GID}" video && gpasswd -a runsuer video) > /dev/null
>&2 echo -n "[${me}] Fixing permissions to possibly changed UID/GID "
>&2 echo "combination of ${USER_UID}/${USER_GID}."
chown -R "${USER_UID}":"${USER_GID}" /home/runuser

