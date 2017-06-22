FROM quay.io/kwiksand/cryptocoin-base:latest

ENV FLORINCOIN_DATA=/home/florincoin/.florincoin

RUN useradd -m florincoin

USER florincoin
RUN cd /home/florincoin && \
    mkdir ~/.ssh && \
    chmod 700 ~/.ssh && \
    ssh-keyscan -t rsa github.com >> ~/.ssh/known_hosts && \
    ssh-keyscan -t rsa bitbucket.org >> ~/.ssh/known_hosts && \
    git clone https://github.com/florincoin/florincoin.git florincoind && \
    cd /home/florincoin/florincoind && \
    git checkout tags/v0.10.4.4 && \
    ./autogen.sh && \
    ./configure && \
    make && \
    make install
    
EXPOSE 7312 7313

USER root

COPY docker-entrypoint.sh /entrypoint.sh

RUN chmod 777 /entrypoint.sh && cp /home/florincoin/florincoind/src/florincoind /usr/bin/florincoind && chmod 755 /usr/bin/florincoind

ENTRYPOINT ["/entrypoint.sh"]

CMD ["florincoind"]
