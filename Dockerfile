FROM busybox
ADD hello.sh /
ENTRYPOINT ["/bin/sh","-c","/hello.sh"]