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
COPY ./.bashrc ~/.bashrc

# Use bash shell for future RUN commands
SHELL ["/bin/bash", "-c"]

#  Install Miniconda
# Install dependencies and Miniconda
ENV CONDA_DIR=/opt/conda
ENV PATH=$CONDA_DIR/bin:$PATH

RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O miniconda.sh && \
    bash miniconda.sh -b -p $CONDA_DIR && \
    rm miniconda.sh && \
    ln -s $CONDA_DIR/bin/conda /usr/local/bin/conda

# Install python on conda
RUN conda create -n devel python=3.11

# Install PyTorch on conda
RUN source $CONDA_DIR/etc/profile.d/conda.sh && \
    conda activate devel && \
    pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu118

# Install Python dependencies
RUN source $CONDA_DIR/etc/profile.d/conda.sh && \
    conda activate devel && \
    pip install --no-cache-dir swig 
RUN source $CONDA_DIR/etc/profile.d/conda.sh && \
    conda activate devel && \
    pip install --no-cache-dir \
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
