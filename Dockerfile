# Use the official PyTorch image with CUDA support
# Check the PyTorch documentation for the latest available tags at https://hub.docker.com/r/pytorch/pytorch/tags
FROM pytorch/pytorch:2.7.1-cuda12.6-cudnn9-runtime

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
    ipython-icat


RUN ipython profile create && python -m icat setup

# Entrypoint
CMD ["tail", "-f", "/dev/null"]
