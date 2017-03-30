# Builds a Docker image for Elmer in a Desktop environment
# with Ubuntu and LXDE.
#
# The built image can be found at:
#   https://hub.docker.com/r/multiphysics/elmer-desktop
#
# Authors:
# Xiangmin Jiao <xmjiao@gmail.com>

FROM x11vnc/ubuntu:latest
LABEL maintainer "Xiangmin Jiao <xmjiao@gmail.com>"

USER root
WORKDIR /tmp

# Install Elmer and some additional tools (Gmsh, gfortran, etc.)
RUN apt-add-repository ppa:elmer-csc-ubuntu/elmer-csc-ppa && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        build-essential \
        gfortran \
        gmsh \
        elmerfem-csc && \
    curl -s https://cmake.org/files/v3.7/cmake-3.7.2-Linux-x86_64.tar.gz | \
          tar zx -C /usr/local --strip-components 1 && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

########################################################
# Customization for user and location
########################################################

ENV MP_USER=multiphysics

# Set up user so that we do not run as root
RUN mv /home/$DOCKER_USER /home/$MP_USER && \
    useradd -m -s /bin/bash -G sudo,docker_env $MP_USER && \
    echo "$MP_USER:docker" | chpasswd && \
    echo "$MP_USER ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
    sed -i "s/$DOCKER_USER/$MP_USER/" /home/$MP_USER/.config/pcmanfm/LXDE/desktop-items-0.conf && \
    chown -R $MP_USER:$MP_USER /home/$MP_USER

ENV DOCKER_USER=$MP_USER \
    DOCKER_GROUP=$MP_USER \
    DOCKER_HOME=/home/$MP_USER \
    HOME=/home/$MP_USER

WORKDIR $DOCKER_HOME

USER root
ENTRYPOINT ["/sbin/my_init","--quiet","--","/sbin/setuser","multiphysics","/bin/bash","-l","-c"]
CMD ["/bin/bash","-l","-i"]
