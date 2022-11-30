from channels.db import database_sync_to_async
from channels.generic.websocket import AsyncJsonWebsocketConsumer
from rest_framework.authtoken.models import Token
from api.models import Homegroup
from users.models import User

class ChatConsumer(AsyncJsonWebsocketConsumer):
    async def connect(self):
        token_homegroup = await self.get_homegroup_by_token(self.scope["headers"])
        if token_homegroup is None:
            await self.disconnect(1)
        else:
            self.room_name = token_homegroup.id
            self.room_group_name = f"group_{self.room_name}"
            await self.channel_layer.group_add(self.room_group_name, self.channel_name)
            await self.accept()


    async def receive_json(self, content, **kwargs):
        await self.channel_layer.group_send(
            self.room_group_name,
            content
        )

    async def disconnect(self, close_code):
        await self.channel_layer.group_discard(self.room_group_name, self.channel_name)

    async def broadcast_update(self, event):
        print(event)
        await self.send_json(content={"type": "recommend_update", "hash": event["hash"]})

    @database_sync_to_async
    def get_homegroup_by_token(self, headers):
        headers = self.scope["headers"]
        for pair in headers:
            if pair[0].decode("UTF-8") == "authorization":
                tokenType, tokenString = pair[1].decode("UTF-8").split()

                queryset = Token.objects.filter(key=tokenString)
                if queryset.exists():
                    return Token.objects.get(key=tokenString).user.homegroup
                else:
                    return None

    @database_sync_to_async
    def get_homegroup_by_id(self, group_id):
        queryset = Homegroup.objects.filter(id=group_id)
        if queryset.exists():
            return queryset.get()
        else:
            return None
