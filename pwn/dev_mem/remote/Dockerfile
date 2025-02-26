FROM fedora:40

RUN dnf update -y && \
    dnf install -y --setopt=install_weak_deps=False \
    qemu-system-x86 \
    socat \
    python3 \
    ca-certificates && \
    dnf clean all

COPY entrypoint.sh /opt/
COPY bzImage /opt/
COPY initramfs.cpio.gz /opt/
COPY run.sh /opt/
COPY run.py /opt/
COPY hashcash.py /opt/

RUN chmod +x /opt/entrypoint.sh

WORKDIR /opt/

EXPOSE 1337

CMD ["./entrypoint.sh"]
