#!/bin/bash


conda create -n jupyter
conda activate jupyter

CONDA_DIR=$HOME/anaconda3
ENV_DIR=/home/codeninja/anaconda3/envs/jupyter
NB_USER=#USER

conda config --system --prepend channels conda-forge
conda config --system --set show_channel_urls true
conda install --yes conda
conda update --all --quiet --yes
conda clean -tipsy
rm -rf /home/$NB_USER/.cache/yarn

sudo apt update && \
sudo apt install -y --no-install-recommends ffmpeg fonts-dejavu tzdata \
gfortran gcc && \
sudo apt clean

conda install --yes notebook jupyterhub jupyterlab -c conda-forge && \
conda clean -tipsy
jupyter labextension install @jupyterlab/hub-extension
npm cache clean --force
jupyter notebook --generate-config

conda clean -tipsy
rm -rf $ENV_DIR/share/jupyter/lab/staging

sudo apt-get update && sudo apt-get install -yq --no-install-recommends \
build-essential emacs git inkscape jed libsm6 libxext-dev libxrender1 lmodern \
netcat pandoc python-dev texlive-fonts-extra texlive-fonts-recommended \
texlive-generic-recommended texlive-latex-base texlive-latex-extra \
texlive-xetex unzip nano \
&& sudo apt clean

conda install --yes blas=*=openblas ipywidgets pandas \
numexpr matplotlib scipy seaborn scikit-learn \
scikit-image sympy cython patsy statsmodels \
cloudpickle dill numba bokeh sqlalchemy hdf5 \
h5py vincent beautifulsoup4 protobuf xlrd nodejs -c conda-forge && \
conda remove --quiet --yes --force qt pyqt && \
conda clean -tipsy

jupyter nbextension enable --py widgetsnbextension --sys-prefix && \
jupyter labextension install @jupyter-widgets/jupyterlab-manager && \
jupyter labextension install jupyterlab_bokeh && \

npm cache clean --force && \
rm -rf /home/$NB_USER/.cache/yarn && \
rm -rf $ENV_DIR/share/jupyter/lab/staging && \
rm -rf /home/$NB_USER/.node-gyp

cd /tmp && \
git clone https://github.com/PAIR-code/facets.git && \
cd facets && \
jupyter nbextension install facets-dist/ --sys-prefix && \
cd && \
# rm -rf /tmp/facets && \

conda install --yes numpy matplotlib -c conda-forge && \
conda remove --quiet --yes --force qt pyqt && \
python -c "import matplotlib.pyplot"

# conda install --yes conda-forge::tensorflow conda-forge::keras rpy2=2.8* \
# r-base=3.4.1 r-irkernel=0.8* r-plyr=1.8* r-devtools=1.13* r-tidyverse=1.1* \
# r-shiny=1.0* r-rmarkdown=1.8* r-forecast=8.2* r-rsqlite=2.0* r-reshape2=1.4* \
# r-nycflights13=0.2* r-caret=6.0* r-rcurl=1.95* r-crayon=1.3* \
# r-randomforest=4.6* r-htmltools=0.3* r-sparklyr=0.7* r-htmlwidgets=1.0* \
# r-hexbin=1.27* && \
# conda clean -tipsy

conda install --yes anaconda::tensorflow anaconda::tensorflow-gpu conda-forge::keras

conda install rpy2 r-base r-irkernel r-plyr r-devtools r-tidyverse \
r-shiny r-rmarkdown r-forecast r-rsqlite r-reshape2 \
r-nycflights13 r-caret r-rcurl r-crayon \
r-randomforest r-htmltools r-sparklyr r-htmlwidgets \
r-hexbin && \
conda clean -tipsy

# pip install jupyterthemes && \
conda install --yes jupyterthemes && \
conda remove --quiet --yes --force qt pyqt && \
conda clean -tipsy

jt -t onedork -kl -T -N -altp -lineh 150 -cellw 88% -nfs 115 -dfs 115 \
-fs 105 -ofs 105 -tfs 105 -cursc r -nf roboto -tf roboto -f firacode

conda update --all --yes && \
conda clean -tipsy
