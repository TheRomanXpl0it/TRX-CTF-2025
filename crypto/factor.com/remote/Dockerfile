FROM python:3.12

RUN apt update && \
	apt install -y socat && \
	python3 -m pip install pycryptodome
RUN rm -rf /var/cache/apt/archives /var/lib/apt/lists/*

RUN useradd -d /home/chall/ -m -p chall -s /bin/bash chall
RUN echo "chall:chall" | chpasswd

WORKDIR /home/chall/
COPY server.py ./
COPY flag.txt ./
RUN chmod +x server.py

EXPOSE 1337

USER chall

CMD [ "socat", "TCP-LISTEN:1337,reuseaddr,fork", "EXEC:\"python3 server.py\"" ]
