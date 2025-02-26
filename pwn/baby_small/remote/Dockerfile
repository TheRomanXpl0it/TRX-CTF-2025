FROM ubuntu:22.04

# Update and install packages
RUN apt-get update
RUN apt-get install -y --no-install-recommends \
    qemu-system-x86 \
    socat \
    python3 \
    ca-certificates

# Copy challenge entrypoint
COPY entrypoint.sh /opt/
COPY bzImage /opt/
COPY initramfs.cpio.gz /opt/
COPY run.sh /opt/
COPY run.py /opt/
COPY hashcash.py /opt/
RUN chmod +x /opt/entrypoint.sh
RUN chmod +x /opt/run.sh

WORKDIR /opt/

# Socat listening port
EXPOSE 1337

# Change entrypoint to launch challenge
CMD ["./entrypoint.sh"]
