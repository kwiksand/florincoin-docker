FROM quay.io/kwiksand/cryptocoin-base:latest

ENV FLORINCOIN_DATA=/home/florincoin/.florincoin

RUN useradd -m florincoin

USER florincoin
RUN cd /home/florincoin && \
    mkdir /root/.ssh && \
    chmod 700 /root/.ssh && \
    ssh-keyscan -t rsa github.com >> /root/.ssh/known_hosts && \
    git clone https://github.com/florincoin/florincoin.git florincoind && \
    cd /home/florincoin/florincoind && \
    ./autogen.sh && \
    ./configure && \
#    ./configure --with-incompatible-bdb && \
#    ./configure LDFLAGS="-L/home/florincoin/db4/lib/" CPPFLAGS="-I/home/florincoin//db4/include/" && \
    make && \
    make install
    
EXPOSE 7312 7313

#VOLUME ["/home/florincoin/.florincoin"]

USER root

COPY docker-entrypoint.sh /entrypoint.sh

RUN chmod 777 /entrypoint.sh && cp /home/florincoin/florincoind/src/florincoind /usr/bin/florincoind && chmod 755 /usr/bin/florincoind

ENTRYPOINT ["/entrypoint.sh"]

CMD ["florincoind"]
