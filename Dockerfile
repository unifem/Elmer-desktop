# Builds a Docker image for Elmer in a Desktop environment
# with Ubuntu and LXDE.
#
# The built image can be found at:
#   https://hub.docker.com/r/unifem/elmer-desktop
#
# Authors:
# Xiangmin Jiao <xmjiao@gmail.com>

FROM unifem/desktop-base:latest
LABEL maintainer "Xiangmin Jiao <xmjiao@gmail.com>"

USER root
WORKDIR /tmp

# Install Elmer and some additional tools (Gmsh, gfortran, etc.)
RUN apt-add-repository ppa:elmer-csc-ubuntu/elmer-csc-ppa && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        gfortran \
        gmsh \
        elmerfem-csc && \
    curl -s https://cmake.org/files/v3.7/cmake-3.7.2-Linux-x86_64.tar.gz | \
          bsdtar zxf - -C /usr/local --strip-components 1 && \
    echo "@ElmerGUI" >> $DOCKER_HOME/.config/lxsession/LXDE/autostar && \         
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

########################################################
# Customization for user and location
########################################################

WORKDIR $DOCKER_HOME

USER root
