FROM alpine:latest

RUN apk --update add nmap \
                     nmap-scripts \
                     git \
                     bash

RUN git clone https://github.com/scipag/vulscan.git /usr/share/nmap/scripts/vulscan

WORKDIR /usr/share/nmap/scripts/vulscan

#Update CVE databases
CMD ["/bin/bash","updateFiles.sh"]

ENTRYPOINT ["nmap"]
CMD ["-h"]

