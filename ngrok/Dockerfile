FROM alpine:3.7

RUN set -x \
    # Install ngrok (latest official stable from https://ngrok.com/download).
 && apk add --no-cache curl \
 && curl -Lo /ngrok.zip https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip \
 && unzip -o /ngrok.zip -d /bin \
 && rm -f /ngrok.zip \
    # Create non-root user.
 && adduser -h /home/ngrok -D -u 6737 ngrok

# Add config script.
COPY ngrok.yml /home/ngrok/.ngrok2/
COPY entrypoint.sh /
#RUN chmod 777 /entrypoint.sh

USER ngrok
ENV USER=ngrok

#RUN whereis ngrok
#RUN export PATH=$PATH:/bin 

EXPOSE 4040

CMD ["./entrypoint.sh"]
