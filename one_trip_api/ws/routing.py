from django.urls import re_path, path

from ws import consumers

websocket_urlpatterns = [
    path('ws/', consumers.ChatConsumer.as_asgi(), name='room')
]