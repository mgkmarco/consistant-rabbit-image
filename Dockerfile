# docker-compose build --build-arg definitions=_definitions.json
# docker build --build-arg definitions=_definitions.json -t rabbit_consistent:1.0 .

# Pull alpine image. Internally it will pull the management-alpine plugin and expose port 15672
# Checkout https://github.com/docker-library/rabbitmq/blob/7e63843da6bfb191ddee6dbe3dd7ec0df36ae70b/3.8/alpine/management/Dockerfile
FROM rabbitmq:management-alpine
# Enable consistent hash plugin for the exchange
RUN rabbitmq-plugins enable rabbitmq_consistent_hash_exchange
# Use --build-arg=definitions=<custom-definitions.json> to override at build time
ARG definitions=definitions.json  
# Copy passhash.sh and if it exists the $definitions json file 
COPY passhash.sh $definitions* /usr/local/bin/
# aasdsd

RUN echo -e "#!/bin/bash\n" >> /usr/local/bin/def_script.sh
RUN echo -e "if [ -f /usr/local/bin/$definitions ]; then\n" \
            "mv /usr/local/bin/$definitions /etc/rabbitmq;\n" \ 
            "cd /etc/rabbitmq/;\n" \
            "mv $definitions definitions.json;\n" \ 
            "echo loopback_users.guest = false >> /etc/rabbitmq/rabbitmq.conf;\n" \
            "echo listeners.tcp.default = 5672 >> /etc/rabbitmq/rabbitmq.conf;\n" \
            "echo management.tcp.port = 15672 >> /etc/rabbitmq/rabbitmq.conf;\n" \
            "echo "load_definitions = /etc/rabbitmq/definitions.json" >> /etc/rabbitmq/rabbitmq.conf;\n" \
            "chown rabbitmq:rabbitmq rabbitmq.conf;\n" \
         "fi\n" >> /usr/local/bin/def_script.sh;
         # "fi\n" > /etc/rabbitmq/def_script.sh;
# Swith to directory, set as executable, execute script
RUN cd /usr/local/bin; \
    chmod +x def_script.sh; \
    ./def_script.sh;
# Expose Rabbitmq server port
EXPOSE 5672