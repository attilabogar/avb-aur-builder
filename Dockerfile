FROM archlinux/base
LABEL authors="Attila Bogár <attila.bogar@gmail.com>"

RUN pacman -Syy
RUN pacman --noconfirm --needed -S base base-devel git linux-headers

RUN echo -e 'Cmnd_Alias BUILD = /usr/bin/pacman\n%wheel ALL=(ALL) NOPASSWD: BUILD' > /etc/sudoers.d/user
RUN chmod 0400 /etc/sudoers.d/user

RUN echo -e '\n[repo]\nServer = file:///data/repo\nSigLevel = Optional TrustAll' >> /etc/pacman.conf

# entry point
COPY entrypoint.sh /
CMD ["/entrypoint.sh"]
