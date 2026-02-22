FROM temporalio/auto-setup:latest

USER root

# Install the Temporal UI server
ENV TEMPORAL_UI_VERSION=2.31.2
RUN apt-get update && apt-get install -y curl supervisor && \
    rm -rf /var/lib/apt/lists/* && \
    curl -L -o /tmp/ui-server.tar.gz \
    "https://github.com/temporalio/ui-server/releases/download/v${TEMPORAL_UI_VERSION}/ui-server_${TEMPORAL_UI_VERSION}_linux_amd64.tar.gz" && \
    mkdir -p /opt/temporal-ui && \
    tar -xzf /tmp/ui-server.tar.gz -C /opt/temporal-ui && \
    rm /tmp/ui-server.tar.gz

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY ui-config.yaml /opt/temporal-ui/config.yaml

EXPOSE 7233 8233

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]