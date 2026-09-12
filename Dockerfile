FROM docker.io/xiuxiu10201/webvnc:latest
ENV \
    XDG_CONFIG_HOME=/etc/115/config \
    XDG_DATA_HOME=/etc/115/data \
    XDG_CACHE_HOME=/tmp \
    HOME=/opt \
    DISPLAY=:115 \
    WEB_PORT=1150 \
    WEBKIT_DISABLE_COMPOSITING_MODE=1 \
    WEBKIT_DISABLE_DMABUF_RENDERER=1

ARG VERSION=""
RUN apt-get update \
    && if [ -z "$VERSION" ]; then VERSION=$(curl -k -s https://appversion.115.com/1/web/1.0/api/getMultiVer | jq -r '.data["115Life_Linux"].version_code'); fi \
    && wget -q --no-check-certificate "https://down.115.com/client/115pc/lin/115Life_${VERSION}.deb" -O /tmp/tmp.deb \
    && apt-get install -y --no-install-recommends /tmp/tmp.deb dbus dbus-x11 gnome-keyring libgl1 libegl1 \
    && rm /tmp/tmp.deb \
    && mkdir -p /opt/Desktop /etc/115 /opt/Downloads \
    && cp /usr/share/applications/life115.desktop /usr/share/applications/pcmanfm.desktop /opt/Desktop \
    && sed -i 's|^Exec=.*|Exec=/opt/115life/115.sh|' /opt/Desktop/life115.desktop \
    && chmod 777 -R /opt /etc/115 \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY --chmod=755 115.sh /opt/115life/115.sh
COPY run.sh /opt/run.sh
EXPOSE 1150
CMD ["bash","/opt/run.sh"]
