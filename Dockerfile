FROM  continuumio/anaconda3

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

WORKDIR /intSiteCaller
RUN apt-get update -y  && \
    apt-get install -y libcurl4-openssl-dev \
    gcc \
    make  && \
    apt-get clean

RUN conda create --name intSiteCaller --file conda_spec.txt

# Make RUN commands use the new environment:
# https://pythonspeed.com/articles/activate-conda-dockerfile/
SHELL ["conda", "run", "-n", "intSiteCaller", "/bin/bash", "-c"]

# Install non-Conda dependencies:
RUN Rscript installPackages.R
WORKDIR /scratch
ENTRYPOINT ["conda", "run", "-n", "intSiteCaller", "Rscript", "/intSiteCaller/intSiteCaller.R"]
