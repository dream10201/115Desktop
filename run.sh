#!/bin/bash
set +e

export DISPLAY_WIDTH=${DISPLAY_WIDTH:-1366}
export DISPLAY_HEIGHT=${DISPLAY_HEIGHT:-768}

VNC_PORT=$((5900 + ${DISPLAY#:}))
UI_JS_PATH="${NO_VNC_HOME}/app/ui.js"

rm -rf /tmp/.X11-unix/X${DISPLAY#:} "/tmp/.X${DISPLAY#:}-lock" "${HOME}/.vnc/*.pid" "${HOME}/.vnc/*.log"
mkdir -p "${XDG_CONFIG_HOME}" "${XDG_DATA_HOME}"

export XDG_RUNTIME_DIR=/tmp/runtime
mkdir -p "${XDG_RUNTIME_DIR}" && chmod 700 "${XDG_RUNTIME_DIR}"
eval "$(dbus-launch --sh-syntax)"
echo -n "" | gnome-keyring-daemon --unlock --components=secrets >/dev/null 2>&1

echo "geometry=${DISPLAY_WIDTH}x${DISPLAY_HEIGHT}" > "${HOME}/.vnc/config"

if [ -n "${PASSWORD}" ]; then
    export PASSWD_PATH="${HOME}/.vnc/passwd"
    echo "${PASSWORD}" | vncpasswd -f >"${PASSWD_PATH}"
    chmod 0600 "${PASSWD_PATH}"
    echo "securitytypes=VncAuth" >> "${HOME}/.vnc/config"
    [ -f "${UI_JS_PATH}" ] && sed -i "s/UI.initSetting('autoconnect', true);/UI.initSetting('autoconnect', false);/g" "${UI_JS_PATH}"
else
    echo "securitytypes=None" >> "${HOME}/.vnc/config"
    if [ -f "${UI_JS_PATH}" ]; then
        sed -i "s/UI.initSetting('autoconnect', false);/UI.initSetting('autoconnect', true);/g" "${UI_JS_PATH}"
        sed -i "s/getConfigVar('autoconnect', false)/getConfigVar('autoconnect', true)/g" "${UI_JS_PATH}"
    fi
fi

echo "Starting noVNC on port ${WEB_PORT}..."
"${NO_VNC_HOME}"/utils/novnc_proxy --vnc localhost:${VNC_PORT} --listen ${WEB_PORT} &

echo "Starting VNC Server on ${DISPLAY}..."
/usr/libexec/vncserver ${DISPLAY} &

echo "Waiting for X Server..."
for i in {1..20}; do
    if [ -S "/tmp/.X11-unix/X${DISPLAY#:}" ]; then
        echo "X Server is ready."
        break
    fi
    sleep 0.2
done

pcmanfm --desktop --profile default &

echo "Starting tint2..."
tint2 -c "$TINT2_CONF" &

if [ "${AUTO_START}" != "false" ]; then
    echo "Starting 115 Life..."
    /opt/115life/115.sh
fi
wait
