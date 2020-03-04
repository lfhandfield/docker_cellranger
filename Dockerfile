FROM ubuntu 

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update 
RUN apt-get -y install build-essential git-all wget
RUN apt-get -y install zlib1g zlib1g-dev libbz2-1.0 libbz2-dev liblzma-dev
RUN apt-get -y install python-numpy python-scipy golang-1.11-go
RUN pip install docopt==0.6.1
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

RUN curl "http://cf.10xgenomics.com/supp/cell-exp/cellranger-3.1.0.tar.gz?Expires=1583369609&Policy=eyJTdGF0ZW1lbnQiOlt7IlJlc291cmNlIjoiaHR0cDovL2NmLjEweGdlbm9taWNzLmNvbS9yZWxlYXNlcy9jZWxsLWV4cC9jZWxscmFuZ2VyLTMuMS4wLnRhci5neiIsIkNvbmRpdGlvbiI6eyJEYXRlTGVzc1RoYW4iOnsiQVdTOkVwb2NoVGltZSI6MTU4MzM2OTYwOX19fV19&Signature=CeWyo2CaUZlHx9NNEzT9ArBDPTUhtmI2NdPomjTpRBdqqYq-ZBr~yJXE565-60SCrzaSLME~EJBsCZNnltH~wBHgnRYBGDnbSjBXxjQ~aALQYkUiYqJYKcNWcH9ed66Af5sBnOP8e-AcQ7VRuypU51gHF4ie31Yb1oQrKYssh1lpkNYGuQ5foCsXxdLOXuhD5I7kPXD~OCpMEyn1CPlCmFg5SP8KdK916W1Woby1Gds1~uwRckXpxGMjpxhpC5dcD85c~Qdnd3HbVKzKwnIik~6JiOf0J6Yh~p~UdwG2D3ODCZ6EpKZN8bSen9NRjD~GixekKeEIPxT2Ukojsdwssw__&Key-Pair-Id=APKAI7S6A5RYOXBWRPDA"

RUN cd /opt && ls -l -s \
&& tar -xzvf cellranger-3.1.0.tar.gz \
&& export PATH=/opt/bedtools/bin/:/opt/cellranger-3.1.0:$PATH \
&& ln -s /opt/cellranger-3.1.0/cellranger /usr/bin/cellranger \
&& rm -rf /opt/cellranger-3.1.0.tar.gz

CMD ["cellranger"]

