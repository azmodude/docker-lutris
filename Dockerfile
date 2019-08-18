FROM archlinux/base:latest as lutris

RUN set -x && \
  pacman -Syy --noconfirm && \
  pacman -S --noconfirm reflector && \
  reflector --verbose --protocol https --latest 5 --sort rate --save /etc/pacman.d/mirrorlist &&\
  pacman -S --noconfirm lutris
RUN \
  echo [multilib] >> /etc/pacman.conf && \
  echo Include = /etc/pacman.d/mirrorlist >> /etc/pacman.conf
RUN \
  pacman -Syy --noconfirm && \
  pacman -S --noconfirm nvidia nvidia-utils lib32-nvidia-utils nvidia-settings lib32-mesa vulkan-icd-loader lib32-vulkan-icd-loader vulkan-intel lib32-vulkan-intel vulkan-icd-loader lib32-vulkan-icd-loader
RUN pacman -S --noconfirm iputils p7zip winetricks wine steam pciutils firefox sdl procps-ng

# wow
RUN pacman -S --noconfirm lib32-gnutls lib32-libldap lib32-libgpg-error lib32-sqlite lib32-libpulse

RUN curl -L -o /tmp/s6-overlay-amd64.tar.gz https://github.com/just-containers/s6-overlay/releases/download/v1.21.8.0/s6-overlay-amd64.tar.gz
RUN tar xzf /tmp/s6-overlay-amd64.tar.gz -C / --exclude="./bin" && \
    tar xzf /tmp/s6-overlay-amd64.tar.gz -C /usr ./bin
RUN curl -L -o /usr/bin/gosu https://github.com/tianon/gosu/releases/download/1.11/gosu-amd64 && \
    chmod +x /usr/bin/gosu

COPY rootfs /
ENTRYPOINT ["/init"]
CMD ["/usr/local/bin/lutris"]
