FROM nvidia/cuda:11.8.0-devel-ubuntu22.04

# Install additional Linux software
RUN apt-get update && apt-get install -y --no-install-recommends \
    rsync \
    g++ \
    git \
    vim \
    ssh \
    wget \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Create and switch to a new user
RUN useradd -ms /bin/bash user
USER user

# Copy the current directory contents into the container at /workspace
COPY ./.bashrc /root/.bashrc

#  Install Miniconda
RUN mkdir -p ~/miniconda3 && \
    wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda3/miniconda.sh && \
    bash ~/miniconda3/miniconda.sh -b -u -p ~/miniconda3 && \
    rm ~/miniconda3/miniconda.sh && \
    source ~/miniconda3/bin/activate && \
    conda init --all

# Install conda environment with python 3.11
RUN conda create -n dev_env python=3.11 -y && conda activate dev_env

# Install PyTorch
RUN pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu118

# Install Python dependencies
RUN pip install --no-cache-dir swig 
RUN pip install --no-cache-dir \
    gymnasium[all] \
    tqdm \
    einops \
    matplotlib \
    tensorboard \
    transformers \
    diffusers \
    ipython-icat \
    numpy


RUN ipython profile create && python -m icat setup

# setup ssh
COPY start.sh /start.sh
RUN chmod +x /start.sh
RUN /start.sh
CMD ["tail", "-f", "/dev/null"]
