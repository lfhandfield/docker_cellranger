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

RUN curl http://cf.10xgenomics.com/supp/cell-exp/cellranger-3.1.0.tar.gz?Expires=1583363040&Policy=eyJTdGF0ZW1lbnQiOlt7IlJlc291cmNlIjoiaHR0cDovL2NmLjEweGdlbm9taWNzLmNvbS9yZWxlYXNlcy9jZWxsLWV4cC9jZWxscmFuZ2VyLTMuMS4wLnRhci5neiIsIkNvbmRpdGlvbiI6eyJEYXRlTGVzc1RoYW4iOnsiQVdTOkVwb2NoVGltZSI6MTU4MzM2MzA0MH19fV19&Signature=GEpFxhoL1vTyEmv7X8xD7LQzdIaqvkujCrdDpPG2Y1gkCHt93Nlux9YT1Q-hi17w1vDS45GnX~SHDVFGsjeMezY7aWRU95WiwpeOA-kh-niwTN7-LVrXr~wOrGLKDG-KjURkCCQiZPUQLx~QKSnixKku7Ya-7YH1LjJId3aYwYvHtSwIWw-h~yjOdE9JA0T3csdaXqtEtlWGhgwmjMZlJeZa3keO07LLtVFfy6Y9m1T15OPR08UPqO83DD-uvB4-eKGx3WZAjONw4YC8SEb7epU0RDjOdqa1GjY4pxJfddjvEnC6JdmAvqeNmtRhez0DtD-e1nt0w2ZS20yY0ZTfWA__&Key-Pair-Id=APKAI7S6A5RYOXBWRPDA -o /opt/cellranger-3.1.0.tar.gz

RUN cd /opt && ls \
&& tar -xzvf cellranger-3.1.0.tar.gz \
&& export PATH=/opt/bedtools/bin/:/opt/cellranger-3.1.0:$PATH \
&& ln -s /opt/cellranger-3.1.0/cellranger /usr/bin/cellranger \
&& rm -rf /opt/cellranger-3.1.0.tar.gz

CMD ["cellranger"]

