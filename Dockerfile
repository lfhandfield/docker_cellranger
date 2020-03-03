FROM ubuntu 

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update 
RUN apt-get -y install build-essential git-all wget
RUN apt-get -y install zlib1g zlib1g-dev libbz2-1.0 libbz2-dev liblzma-dev
RUN apt-get -y install python-numpy python-scipy 
WORKDIR /opt/
RUN wget https://github.com/arq5x/bedtools2/releases/download/v2.28.0/bedtools-2.28.0.tar.gz \
&&  tar -zxvf bedtools-2.28.0.tar.gz \
&&  make -C bedtools2 
RUN apt-get -y install cmake curl libcurl4-openssl-dev libjsoncpp-dev
RUN git clone git://github.com/samtools/htslib.git \
&&  git clone git://github.com/samtools/bcftools.git \
&&  make -C bcftools
RUN git clone git://github.com/pezmaster31/bamtools.git \
&&  cd bamtools \
&&  mkdir build \
&&  mkdir bin \
&&  cd build \
&&  cmake -DCMAKE_INSTALL_PREFIX=/opt/bamtools/bin .. \
&&  make \
&&  cd ../..

RUN curl http://cf.10xgenomics.com/supp/cell-exp/refdata-cellranger-GRCh38-3.0.0.tar.gz -o /opt/cellranger-3.0.0.tar.gz

RUN cd /opt && ls \
&& tar -xzvf cellranger-3.0.0.tar.gz --exclude=*.fa --exclude=*.gtf  \
&& export PATH=/opt/bedtools/bin/:/opt/cellranger-3.0.0:$PATH \
&& ln -s /opt/cellranger-3.0.0/cellranger /usr/bin/cellranger \
&& rm -rf /opt/cellranger-3.0.0.tar.gz

CMD ["cellranger"]

