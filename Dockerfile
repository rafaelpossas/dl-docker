FROM tensorflow/tensorflow:latest-gpu-py3

MAINTAINER Craig Citro <craigcitro@google.com>

RUN pip --no-cache-dir install \
        ipykernel \
        jupyter \
        matplotlib \
        numpy \
        scipy \
        sklearn \
	keras \
        pandas \
        Pillow 


# SSH
RUN apt-get update && apt-get install -y openssh-server
RUN mkdir /var/run/sshd
RUN echo 'root:gpu' | chpasswd
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

RUN echo "export PATH=$PATH" >> /etc/profile && \
    echo "ldconfig" >> /etc/profile

# Expose Ports for TensorBoard (6006), Ipython (8888)

WORKDIR "/root"

# TensorBoard
EXPOSE 6006
# IPython
EXPOSE 8888
# SSH
EXPOSE 22

WORKDIR "/notebooks"

CMD ["/usr/sbin/sshd", "-D"]
