FROM public.ecr.aws/amazonlinux/amazonlinux:2.0.20210126.0

# Copy project files into container
# (not globbing all files to prevent IntelliJ IDE files from breaking Docker caching):
COPY ./deprecated /intSiteCaller/deprecated
COPY ./errorCorrectIndices /intSiteCaller/errorCorrectIndices
COPY ./testCases /intSiteCaller/testCases
COPY ./tests /intSiteCaller/tests
COPY ./check_log_error.sh /intSiteCaller/check_log_error.sh
COPY ./*.R /intSiteCaller/
COPY ./intSiteCallerConfig.yaml /intSiteCaller/intSiteCallerConfig.yaml
COPY ./*.Rmd /intSiteCaller/
COPY ./*.dat /intSiteCaller/
COPY ./default_processingParams.tsv /intSiteCaller/
COPY conda_spec.txt /intSiteCaller/conda_spec.txt
COPY ./startupScript.sh /intSiteCaller/startupScript.sh
COPY ./installPackages.R /intSiteCaller/installPackages.R
COPY ./submit_job.py /intSiteCaller/submit_job.py

WORKDIR /intSiteCaller
RUN yum update -y  && \
    yum install -y libcurl4-openssl-dev \
    gcc \
    unzip \
    awscli \
    wget \
    which \
    make  && yum -y clean all

RUN amazon-linux-extras install -y lustre2.10

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8
ENV PATH /opt/conda/bin:$PATH

# install miniconda3, see https://github.com/ContinuumIO/docker-images/blob/master/miniconda3/debian/Dockerfile

# Leave these args here to better use the Docker build cache
ARG CONDA_VERSION=py38_4.9.2
ARG CONDA_MD5=122c8c9beb51e124ab32a0fa6426c656

RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-${CONDA_VERSION}-Linux-x86_64.sh -O miniconda.sh && \
    echo "${CONDA_MD5}  miniconda.sh" > miniconda.md5 && \
    if ! md5sum --status -c miniconda.md5; then exit 1; fi && \
    mkdir -p /opt && \
    sh miniconda.sh -b -p /opt/conda && \
    rm miniconda.sh miniconda.md5 && \
    ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && \
    echo "conda activate base" >> ~/.bashrc && \
    find /opt/conda/ -follow -type f -name '*.a' -delete && \
    find /opt/conda/ -follow -type f -name '*.js.map' -delete && \
    /opt/conda/bin/conda clean -afy

RUN /opt/conda/bin/conda create --name intSiteCaller --file conda_spec.txt

# Make RUN commands use the new environment:
# https://pythonspeed.com/articles/activate-conda-dockerfile/
SHELL ["/opt/conda/bin/conda", "run", "-n", "intSiteCaller", "/bin/bash", "-c"]

# Install non-Conda dependencies:
RUN Rscript installPackages.R
WORKDIR /scratch
ENTRYPOINT ["/opt/conda/bin/conda", "run", "-n", "intSiteCaller", "Rscript", "/intSiteCaller/intSiteCaller.R"]
