FROM python:3.10-alpine as builder
WORKDIR /app
COPY . .
# Install dependencies
RUN pip install -r requirements.txt
# Build the app
RUN mkdocs build

FROM nginx:1.23.1 as prod
WORKDIR /web
RUN mkdir -p www \
    && rm -rf /etc/nginx/conf.d/default.conf
COPY --from=builder /app/site www
COPY nginx.conf /etc/nginx/conf.d/
EXPOSE 80
