FROM nvidia/cuda:12.8.0-cudnn-devel-ubuntu22.04

# Install apt dependencies
RUN apt-get update && \
    apt-get install -y curl vim git libglib2.0-0 libgl1 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install conda
ENV CONDA_PLUGINS_AUTO_ACCEPT_TOS true
RUN curl -o ~/miniconda.sh -O  https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh  && \
      chmod +x ~/miniconda.sh && \
      ~/miniconda.sh -b -p /opt/conda && \
      rm ~/miniconda.sh

# Add conda to path
ENV PATH /opt/conda/bin:$PATH

# Install conda python environment
RUN conda config --set always_yes yes --set changeps1 no && conda update -q conda
RUN conda install python=3.10

# Copy project files
COPY . /opt/DeepFaceLab
WORKDIR /opt/DeepFaceLab

# Install python dependencies
RUN python3 -m pip install -r requirements-cuda.txt

# Set default entry point
CMD ["python3", "main.py"]
EXPOSE 6006
