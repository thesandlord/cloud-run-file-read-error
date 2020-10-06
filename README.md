# Minimal Reproduction of Cloud Run Issue

This container runs fine locally with:

```
docker run -it -p 8080:8080
```

But fails when using Cloud Run.

The root cause of the issue is probably [TigerVNC](https://github.com/TigerVNC/tigervnc)

It reads from a password file, but is not able to because of `getpassword error: Inappropriate ioctl for device`

(this is technically using a fork of TigerVNC called KasmVNC, but I don't think there is any difference in this portion)

The password needs to be set even though it is not used anywhere. This is done here:

```
RUN \
     /bin/bash -c "echo -e 'password\npassword\nn' | vncpasswd"; echo; \
     echo '' | vncpasswd -f > ~/.vnc/passwd ; \
     touch /root/.vnc/config ; \
     touch /root/.vnc/xstartup ; \
     touch ~/.Xauthority ;
```

## Prebuilt container: [gcr.io/horatio-project/test:1.0](gcr.io/horatio-project/test:1.0)
