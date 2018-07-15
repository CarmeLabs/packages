FROM carmelabs/jupyter-cpu:latest
LABEL maintainer="CarmeLabs <info@carme.ai>"

USER root
COPY config/* /tmp/config/

#Install Linux packages
RUN apt-get update && cat /tmp/config/packages.txt | xargs apt-get install -y --allow-downgrades --no-install-recommends

# Switch back to jovyan to avoid accidental container runs as root
USER $NB_UID
#Install conda and pip requirements
RUN conda install --yes --file /tmp/config/conda-requirements.txt
RUN pip install -r /tmp/config/pip-requirements.txt



