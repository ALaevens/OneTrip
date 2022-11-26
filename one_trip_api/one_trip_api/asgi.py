"""
ASGI config for one_trip_api project.

It exposes the ASGI callable as a module-level variable named ``application``.

For more information on this file, see
https://docs.djangoproject.com/en/4.1/howto/deployment/asgi/
"""

import os

from django.core.asgi import get_asgi_application

settings = 'one_trip_api.settings.dev'
if os.getenv("DJANGO_RELEASE", False):
    settings = 'one_trip_api.settings.release'

os.environ.setdefault('DJANGO_SETTINGS_MODULE', settings)


application = get_asgi_application()
