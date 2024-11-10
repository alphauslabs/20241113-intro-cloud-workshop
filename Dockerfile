FROM homebrew/ubuntu22.04:latest
COPY . /app/
WORKDIR /app/
USER root
RUN brew install hugo
ENTRYPOINT ["hugo"]
CMD ["serve", "--bind", "0.0.0.0", "--port", "8080"]
