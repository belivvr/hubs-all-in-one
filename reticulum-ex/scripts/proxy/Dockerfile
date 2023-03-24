# FROM nginx:stable-alpine

# COPY nginx.conf /etc/nginx/nginx.conf
# COPY cranky-ardent.hubs.belivvr.com_2023022375C29.unified.crt.pem /etc/nginx/certs/cert.pem
# COPY cranky-ardent.hubs.belivvr.com_2023022375C29.key.pem /etc/nginx/certs/key.pem

# RUN apk update && apk add --no-cache dnsmasq

FROM nginx:stable-alpine

# Install dnsmasq
RUN apk add --no-cache dnsmasq

# Add custom DNS entry to /etc/hosts
# RUN echo "172.17.0.1    frosty-invoker.hubs.belivvr.com" >> /etc/hosts

# Copy nginx config and SSL certificates
COPY nginx.conf /etc/nginx/nginx.conf
COPY cranky-ardent.hubs.belivvr.com_2023022375C29.unified.crt.pem /etc/nginx/certs/cert.pem
COPY cranky-ardent.hubs.belivvr.com_2023022375C29.key.pem /etc/nginx/certs/key.pem
COPY hosts /etc/hosts

# Start dnsmasq and Nginx in the background
CMD sh -c "dnsmasq & nginx -g 'daemon off;'"
