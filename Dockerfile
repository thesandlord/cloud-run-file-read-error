FROM ubuntu:18.04

ENV DEBIAN_FRONTEND=noninteractive 
ENV DISPLAY=:99 

RUN  apt-get update
RUN apt-get install -y xvfb x11vnc x11-xkb-utils xfonts-100dpi xfonts-75dpi xfonts-scalable xfonts-cyrillic sudo wget
RUN mkdir app
RUN mkdir app/public
WORKDIR /app/
RUN wget -qO- https://github.com/kasmtech/KasmVNC/archive/v0.9.0-beta.tar.gz | tar xz --strip 1 -C /app/public
RUN chmod +x /app/public/builder/install/install.sh
RUN bash /app/public/builder/install/install.sh
RUN \
     /bin/bash -c "echo -e 'password\npassword\nn' | vncpasswd"; echo; \
     echo '' | vncpasswd -f > ~/.vnc/passwd ; \
     touch /root/.vnc/config ; \
     touch /root/.vnc/xstartup ; \
     touch ~/.Xauthority ;

ADD run.sh /app/
RUN chmod +x /app/run.sh

ENTRYPOINT [ "bash", "/app/run.sh" ]