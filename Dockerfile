FROM debian

# Download sources and some patching

ADD https://download.oracle.com/berkeley-db/db-4.8.30.NC.tar.gz /db.tar.gz

RUN mkdir /db && \
    cd /db && \
    tar xzf /db.tar.gz

ADD http://git.savannah.gnu.org/gitweb/?p=config.git;a=blob_plain;f=config.guess;hb=HEAD /db/db-4.8.30.NC/dist/config.guess

# Update the system and install build tools

RUN apt update && \
    apt install -y build-essential libc6-dev

# fix

RUN cd /db && sed s/__atomic_compare_exchange/__atomic_compare_exchange_db/g -i /db/db-4.8.30.NC/dbinc/atomic.h

WORKDIR /db/db-4.8.30.NC/build_unix

RUN ../dist/configure --enable-cxx --disable-shared --with-pic --prefix=/opt/db

RUN make -j$(nproc --all) && \
    make install
