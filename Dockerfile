# Pull alpine image. Internally it will pull the management-alpine plugin and expose port 15672
# Checkout https://github.com/docker-library/rabbitmq/blob/7e63843da6bfb191ddee6dbe3dd7ec0df36ae70b/3.8/alpine/management/Dockerfile
FROM rabbitmq:management-alpine

# Enable consistent hash plugin for the exchange
RUN rabbitmq-plugins enable rabbitmq_consistent_hash_exchange

# Use --build-arg=definitions=<custom-definitions.json> to override at build time
ARG definitions=definitions.json

RUN if [ -f $definitions ]; then echo "load_definitions = /etc/rabbitmq/definitions.json" >> /etc/rabbitmq/rabbitmq.conf ; fi
        # COPY $definitions  /etc/rabbitmq/definitions.json \
        #echo loopback_users.guest = false >> /etc/rabbitmq/rabbitmq.conf \
        #echo listeners.tcp.default = 5672 >> /etc/rabbitmq/rabbitmq.conf \
        #echo management.tcp.port = 15672 >> /etc/rabbitmq/rabbitmq.conf \
        #echo "load_definitions = /etc/rabbitmq/definitions.json" >> /etc/rabbitmq/rabbitmq.conf; \
    #fi
 
#COPY $definitions /etc/rabbitmq/definitions.json
#RUN echo loopback_users.guest = false >> /etc/rabbitmq/rabbitmq.conf
#RUN echo listeners.tcp.default = 5672 >> /etc/rabbitmq/rabbitmq.conf
#RUN echo management.tcp.port = 15672 >> /etc/rabbitmq/rabbitmq.conf
#RUN echo "load_definitions = /etc/rabbitmq/definitions.json" >> /etc/rabbitmq/rabbitmq.conf

# Expose Rabbitmq server port
EXPOSE 5672 