from one_trip_api.settings.base import *

DEBUG = True

SECRET_KEY = 'django-insecure-tz%&(g*jikac%ogq%vaf&%i!6m99q_lshu9g-&sz&bw8x!&zk3'

MEDIA_ROOT = BASE_DIR.joinpath("media")
ALLOWED_HOSTS = ["*"]
CORS_ALLOW_ALL_ORIGINS = True