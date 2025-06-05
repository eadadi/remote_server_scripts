# Use the official PyTorch image with CUDA support
# Check the PyTorch documentation for the latest available tags at https://hub.docker.com/r/pytorch/pytorch/tags
FROM pytorch/pytorch:2.7.1-cuda11.8-cudnn9-runtime

# Install additional Linux software
RUN apt-get update && apt-get install -y --no-install-recommends \
    rsync \
    g++ \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Set the working directory
WORKDIR /workspace

# Copy the current directory contents into the container at /workspace
COPY ./.bashrc /root/.bashrc

# Install Python dependencies
RUN pip install --no-cache-dir swig 
RUN pip install --no-cache-dir gymnasium[all] tqdm matplotlib tensorboard ipython-icat

RUN ipython profile create
RUN python -m icat setup

# Entrypoint
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
