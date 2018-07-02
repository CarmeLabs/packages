#The Carme Project Jupyter notebook is derived from the
# The docker Stacks Project.
cp ../../../../../docker-stacks/base-notebook/Dockerfile ../.
cp ../../../../../docker-stacks/base-notebook/start-notebook.sh ../.
cp ../../../../../docker-stacks/base-notebook/start-singleuser.sh ../.
cp ../../../../../docker-stacks/base-notebook/start.sh ../.
cp ../../../../../docker-stacks/base-notebook/jupyter_notebook_config.py ../.
cp ../../../../../docker-stacks/base-notebook/fix-permissions ../.
cp ../../../../../docker-stacks/LICENSE.md ../.
cat ../../../../../docker-stacks/minimal-notebook/Dockerfile >> ../Dockerfile
chmod +x ../*
#Delete this line. FROM jupyter/base-notebook
#LABEL maintainer="CarmeLabs <info@carme.ai>"
# Configure container startup
#Delete this line. ENTRYPOINT ["tini", "-g", "--"]
#Delete this line. CMD ["start-notebook.sh"]
