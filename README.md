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

Edit `hugo.toml` and update `title` to your name. Then add the line

```
theme = hugo-theme-m10c
```
together with the following contents:

```
[params]
  description = "{Your short description here."
  avatar = "url-to-a-public-avatar"
```

Create an `index.md` inside `content` folder like so:

``` sh
$ cd contents/
$ echo '# About me' > index.md
```

You can check your progress like so:

``` sh
$ cd ../
$ hugo serve
# Then use your browser to open the URL indicated in the logs.
```

Try editing the `index.md` file with your personal information.

Once your page is ready, try deploying it to Cloud Run, like so:

``` sh
# Copy the reference Dockerfile to your site directory:
$ wget \
  https://raw.githubusercontent.com/alphauslabs/20241113-intro-cloud-workshop/refs/heads/main/Dockerfile
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
