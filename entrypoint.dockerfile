ARG BASE_IMAGE
FROM ${BASE_IMAGE}

RUN apt-get update
RUN apt-get install -y gettext \
                       awscli
RUN apt-get clean packages

COPY ./pre-run.sh /usr/local/bin
RUN chmod +x /usr/local/bin/pre-run.sh

COPY ./post-run.sh /usr/local/bin
RUN chmod +x /usr/local/bin/post-run.sh

COPY ./entrypoint.sh /usr/local/bin
RUN chmod +x /usr/local/bin/entrypoint.sh

COPY ./run.sh /usr/local/bin
RUN chmod +x /usr/local/bin/run.sh

WORKDIR /scratch

# Make RUN commands use the new environment:
SHELL ["conda", "run", "-n", "intSiteCaller", "/bin/bash", "-c"]

ENTRYPOINT [ "entrypoint.sh" ]
