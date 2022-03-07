# Stage 1
FROM image-registry.openshift-image-registry.svc:5000/openshift/nodejs:14-ubi8 as build-step
USER root
RUN mkdir -p /app
WORKDIR /app
COPY package.json /app
RUN npm install
COPY . /app
RUN npm run build --prod

# Stage 2
FROM image-registry.openshift-image-registry.svc:5000/openshift/nginx:1.18-ubi7
COPY --from=build-step /app/docs /app/dist

EXPOSE 8080:8080
CMD ["nginx", "-g", "daemon off;"]
