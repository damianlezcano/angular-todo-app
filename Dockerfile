# Stage 1
FROM image-registry.openshift-image-registry.svc:5000/openshift/nodejs:14-ubi8 as build-step
RUN mkdir -p /app
WORKDIR /app
COPY package.json /app
RUN npm install
COPY . /app
RUN npm run build --prod

# Stage 2
FROM image-registry.openshift-image-registry.svc:5000/openshift/nginx:1.18-ubi7
COPY --from=build-step /app/docs /usr/share/nginx/html

# Configure NGINX
#COPY ./openshift/nginx/nginx.conf /etc/nginx/nginx.conf
#COPY ./openshift/nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf

#RUN chgrp -R root /var/cache/nginx /var/run /var/log/nginx && chmod -R 777 /var
#RUN sed -i.bak 's/^user/#user/' /etc/nginx/nginx.conf

EXPOSE 4200

USER 1001
