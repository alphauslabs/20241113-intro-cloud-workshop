FROM homebrew/ubuntu22.04:latest
RUN brew tap filebrowser/tap && brew install filebrowser
WORKDIR /app/
ENTRYPOINT ["filebrowser"]
CMD ["-d", "/tmp/fb.db", "-a", "0.0.0.0", "-p", "8080", "-r", "/mnt/fbw/free-docu"]
