# Jupyter Notebook Docker image
FROM python:3.11-slim

# noninteractive for apt
ENV DEBIAN_FRONTEND=noninteractive

# Install system deps
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       build-essential \
       git \
       curl \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /workspace

# Copy repository into the image
COPY . /workspace

# Upgrade pip and install common data science + jupyter packages
RUN python -m pip install --upgrade pip setuptools wheel \
    && pip install --no-cache-dir \
       jupyterlab notebook ipywidgets nbconvert \
       pandas numpy scipy matplotlib seaborn scikit-learn

# Expose Jupyter port
EXPOSE 8888

# Default command: run JupyterLab and allow root access
# NOTE: --NotebookApp.token='' disables token auth for convenience in trusted environments;
# remove that flag or set a password for production use.
CMD ["jupyter", "lab", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root", "--NotebookApp.token=''"]
