FROM sagemath/sagemath:10.5

USER root

RUN apt update && \
	apt install -y socat
RUN rm -rf /var/cache/apt/archives /var/lib/apt/lists/*

RUN sage -pip install pycryptodome

WORKDIR /home/sage/
COPY babydlp.sage ./
COPY flag.txt ./
RUN sage --preparse babydlp.sage
RUN chmod +x babydlp.sage.py

EXPOSE 1337

USER sage

CMD [ "socat", "TCP-LISTEN:1337,reuseaddr,fork", "EXEC:\"sage -python babydlp.sage.py\"" ]
