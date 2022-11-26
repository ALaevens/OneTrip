from one_trip_api.settings.base import *
import os

print("USING RELEASE SETTINGS")

SECRET_KEY = 'django-insecure-tz%&(g*jikac%ogq%vaf&%i!6m99q_lshu9g-&sz&bw8x!&zk3'

DATA_ROOT = Path("/opt/django/data").resolve()
MEDIA_ROOT = DATA_ROOT.joinpath("media/")
STATIC_ROOT = DATA_ROOT.joinpath("static/")

ALLOWED_HOSTS = ["groceries.alaevens.ca"]

if not MEDIA_ROOT.is_dir():
    os.makedirs(MEDIA_ROOT.as_posix())

if not STATIC_ROOT.is_dir():
    os.makedirs(STATIC_ROOT.as_posix())

USE_HTTPS = True

urlPrefixes = ["http://"]
CSRF_TRUSTED_ORIGINS = []
CORS_ALLOWED_ORIGINS = []
if USE_HTTPS: 
    urlPrefixes.append("https://")
for host in ALLOWED_HOSTS:
    for prefix in urlPrefixes:
        CSRF_TRUSTED_ORIGINS.append(f"{prefix}{host}")
        CORS_ALLOWED_ORIGINS.append(f"{prefix}{host}")
