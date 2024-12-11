Reference slides (from part 1): https://github.com/alphauslabs/20241106-intro-cloud/blob/main/2024-11-06_Intro_to_Cloud_Computing.pdf

## Setup

**NOTE: Some members of Alphaus are here to assist you with the commands and explanations provided below. Please don't hesitate to ask for their assistance.**

If you're running Windows, try installing [WSL2](https://learn.microsoft.com/en-us/windows/wsl/install) so you can have access to a Linux-based environment. Then install the `gcloud` CLI and SDK. See [here](https://cloud.google.com/sdk/docs/install) for more info. Also, make sure you have your favorite editor (e.g. VSCode, Vim, Emacs, etc.) ready. Finally, install [`docker`](https://docs.docker.com/engine/install/) as well. You can confirm your setup using the following commands:

``` sh
# Check gcloud:
$ gcloud version

# Check docker:
$ docker version
```

We will be using GCP for the workshop. Open this [link](https://console.cloud.google.com/run?project=labs-169405) to confirm your access. You will also receive a file for authentication. Save it somewhere in your system and create an environment variable with the value pointing to that file's location; like so:

``` sh
$ export GOOGLE_APPLICATION_CREDENTIALS=/path/to/your/json/file.json

# Check access:
$ gcloud auth print-access-token

# If gcloud requires you to login, try the following commands:
$ gcloud auth activate-service-account --key-file /path/to/your/json/file.json
$ gcloud --quiet config set project mobingi-main
$ gcloud auth configure-docker asia-northeast1-docker.pkg.dev

$ base64 /path/to/file.json > /path/to/newfile.json
$ cat /path/to/newfile.json | docker login -u _json_key_base64 \
  --password-stdin https://asia-northeast1-docker.pkg.dev
```

## Exercise 1 - A simple "About me" page

This exercise will guide you in creating a simple "About me" page, and deploy it in Cloud Run.

First, install `brew` to you local environment. More information [here](https://brew.sh/).

We will use [Hugo](https://gohugo.io/) as our main tool. You can install it like so:

``` sh
$ brew install hugo
```

Once Hugo is installed, let's start creating our **About me** page.

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
  description = "{Your short description here.}"
  avatar = "{url-to-a-public-avatar}"
```

Create an `index.md` inside `content` folder like so:

``` sh
$ cd content/
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
# Copy the 'dockerfile-site' file to your site directory and rename it to 'Dockerfile'.

# Create your docker image. Replace 'chew' with your nickname:
$ docker build --rm -t sitechew .

# Tag it so we can upload to Artifact Registry. Replace 'chew' with your nickname:
$ docker tag sitechew asia.gcr.io/mobingi-main/sitechew:v1

# Upload to Artifact Registry. Replace 'chew' with your nickname:
$ docker push asia.gcr.io/mobingi-main/sitechew:v1

# Deploy to Cloud Run. Replace 'chew' with your nickname:
$ gcloud run deploy chew \
    --project=mobingi-main \
    --image=asia.gcr.io/mobingi-main/sitechew:v1 \
    --region=asia-northeast1 \
    --network dev \
    --max-instances=1 \
    --allow-unauthenticated

# You can now access your site through the resulting URL.
```

## Exercise 2 (optional) - A simple file browser

This is a bonus exercise. You can do this if you've finished the 1st one and still have time. This exercise is similar to the 1st one.

First, let's try to prepare the files for your file browser. We will use FileStore as our shared storage.

``` sh
# The location will be in the /mnt/fbw/ folder. You can create a folder there using
# your nickname as the dir name. Then you can copy files from your local to your
# folder using the command below. The following example copies the file 'file1'
# to the home folder, then ssh again to move the file to /mnt/fbw/chew/. Replace
# 'chew' with your nickname.
$ gcloud compute scp file1 fbw-client:~/ \
    --project mobingi-main \
    --zone asia-northeast1-a
$ gcloud compute ssh fbw-client --project mobingi-main --zone asia-northeast1-a
$ sudo mv file1 /mnt/fbw/chew/
```

Once your files are ready, build your image and deploy it to Cloud Run:

``` sh
# Create another working folder for this exercise.
$ mkdir myfb
$ cd myfb/
# Copy the 'dockerfile-fb' file to that folder and rename it to 'Dockerfile'.
# Update the last line with your own folder created in the previous step.

# Create your docker image. Replace 'chew' with your nickname:
$ docker build --rm -t fbchew .

# Tag it so we can upload to Artifact Registry. Replace 'chew' with your nickname:
$ docker tag fbchew asia.gcr.io/mobingi-main/fbchew:v1

# Upload to Artifact Registry. Replace 'chew' with your nickname:
$ docker push asia.gcr.io/mobingi-main/fbchew:v1

# Deploy a file browser exposing own FileStore folder. Replace 'chew' with your nickname:
$ gcloud run deploy fbchew \
    --project=mobingi-main \
    --image=asia.gcr.io/mobingi-main/fbchew:v1 \
    --region=asia-northeast1 \
    --network dev \
    --max-instances=1 \
    --allow-unauthenticated \
    --add-volume name=for-bisu-workshop,type=nfs,location=10.55.65.2:/fbw \
    --add-volume-mount volume=for-bisu-workshop,mount-path=/mnt/fbw

# You can access your file browser through the URL using 'admin'
# as both username and password.
```
