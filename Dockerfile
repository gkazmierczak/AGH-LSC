FROM python:3.9-alpine AS awsbuild

ENV AWSCLI_VERSION=2.19.5

RUN apk add --no-cache \
    curl \
    make \
    cmake \
    gcc \
    g++ \
    libc-dev \
    libffi-dev \
    openssl-dev 
RUN curl https://awscli.amazonaws.com/awscli-${AWSCLI_VERSION}.tar.gz | tar -xz 

WORKDIR /awscli-${AWSCLI_VERSION}

RUN ./configure --prefix=/opt/aws-cli/ --with-download-deps 
RUN make
RUN make install

FROM python:3.9-alpine

COPY --from=awsbuild /opt/aws-cli/ /opt/aws-cli/
RUN mkdir /root/.aws
RUN touch /root/.aws/credentials

ENV PATH="$PATH:/opt/aws-cli/bin"


############
# lsc/lab5 → docker run -it -v  $(pwd)/aws_credentials:/root/.aws/credentials aws-cli-image /bin/sh
# / # aws --version
# aws-cli/2.19.5 Python/3.9.20 Linux/6.10.11-linuxkit source-sandbox/aarch64.alpine.3
# / # aws configure list
#       Name                    Value             Type    Location
#       ----                    -----             ----    --------
#    profile                <not set>             None    None
# access_key     ****************FCXG shared-credentials-file    
# secret_key     ****************UaZ+ shared-credentials-file    
#     region                us-east-1      config-file    ~/.aws/config