ARG BASE_IMAGE
FROM ${BASE_IMAGE}

RUN yum update -y
RUN yum install -y gettext \
                       awscli
RUN yum clean -y all

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
SHELL ["/opt/conda/bin/conda", "run", "-n", "intSiteCaller", "/bin/bash", "-c"]

ENTRYPOINT [ "entrypoint.sh" ]
