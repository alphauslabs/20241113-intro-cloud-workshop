## Setup

Install the `gcloud` CLI and SDK. See [here](https://cloud.google.com/sdk/docs/install) for more info.

You will receive a file for authentication. Save it somewhere in your system and create an environment variable with the value pointing to that file; like so:

``` sh
$ export GOOGLE_APPLICATION_CREDENTIALS=/path/to/your/json/file.json

# Check access:
$ gcloud auth print-access-token
```

## Exercise 1 - a simple "About me" page

Install `brew` to you local environment. More information [here](https://brew.sh/).

Install `hugo` like so:

``` sh
$ brew install hugo
```

Once `hugo` is installed, let's start creating our **About me** page.

``` sh
# Create main folder:
$ hugo new site mysite
$ cd mysite/
# Let's use m10c as our theme:
$ git clone https://github.com/vaga/hugo-theme-m10c.git themes/hugo-theme-m10c
```

## Exercise 2 (optional) - a simple file browser

You can use this VM to access our FileStore instance (e.g. add files, etc.).

``` sh
$ gcloud compute ssh fbw-client --project labs-169405 --zone asia-northeast1-a
```

Deploy a file browser exposing own FileStore folder.

``` sh
$ gcloud run deploy filebrowser \
    --project=labs-169405 \
    --image=asia.gcr.io/labs-169405/filebrowser:fbw1 \
    --region=asia-northeast1 \
    --network dev \
    --max-instances=1 \
    --allow-unauthenticated \
    --add-volume name=for-bisu-workshop,type=nfs,location=10.55.65.2:/fbw \
    --add-volume-mount volume=for-bisu-workshop,mount-path=/mnt/fbw
```
