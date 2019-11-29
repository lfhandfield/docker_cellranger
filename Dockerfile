FROM ubuntu 

RUN apt-get update 
RUN apt-get -y install build-essential git-all
WORKDIR /opt/
RUN wget https://github.com/arq5x/bedtools2/releases/download/v2.28.0/bedtools-2.28.0.tar.gz
RUN tar -zxvf bedtools-2.28.0.tar.gz
RUN make -C bedtools2
RUN git clone git://github.com/pezmaster31/bamtools.git
RUN mkdir build
RUN cd build
RUN cmake -DCMAKE_INSTALL_PREFIX=/my/install/dir ..
  
ENV PATH="/opt/bedtools/bin/:${PATH}"
CMD ["bedtools"]
