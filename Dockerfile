FROM nvidia/cuda:11.8.0-devel-ubuntu22.04

RUN apt-get update && apt-get install -y \
    python3 python3-pip wget curl \
    && pip install torch==2.7.1 torchvision torchaudio --index-url https://download.pytorch.org/whl/cu118


# Install additional Linux software
RUN apt-get update && apt-get install -y --no-install-recommends \
    rsync \
    g++ \
    git \
    vim \
    ssh \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Set the working directory
WORKDIR /workspace

# Copy the current directory contents into the container at /workspace
COPY ./.bashrc /root/.bashrc

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
