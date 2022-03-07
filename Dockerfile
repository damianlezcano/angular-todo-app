# Stage 1
FROM node:10-alpine as build-step
RUN mkdir -p /app
WORKDIR /app
COPY package.json /app
RUN npm install
COPY . /app
RUN npm run build --prod

# Stage 2
FROM nginx:1.17.1-alpine
COPY --from=build-step /app/docs /usr/share/nginx/html

# Configure NGINX
#COPY ./openshift/nginx/nginx.conf /etc/nginx/nginx.conf
#COPY ./openshift/nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf

#RUN chgrp -R root /var/cache/nginx /var/run /var/log/nginx && chmod -R 777 /var
#RUN sed -i.bak 's/^user/#user/' /etc/nginx/nginx.conf

EXPOSE 4200

USER 1001
