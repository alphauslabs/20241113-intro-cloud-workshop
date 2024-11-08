Reference for 2024-11-13 workshop on Intro to Cloud (part 2).

You will receive a file for authentication. Save it somewhere in your system and create an environment variable with the value pointing to that file; like so:

``` sh
$ export GOOGLE_APPLICATION_CREDENTIALS=/path/to/your/json/file.json
```

You can use this VM to access our FileStore instance (e.g. add files, etc.).

``` sh
$ gcloud compute ssh fbw-client --project labs-169405 --zone asia-northeast1-a
```
