from rest_framework import generics, permissions, views, status
from rest_framework.response import Response
from users import serializers, models


class IsOwner(permissions.BasePermission):
    def has_object_permission(self, request, view, obj):
        if obj == request.user:
            return True
        else:
            return False


# Anyone can register
class RegisterUserView(generics.CreateAPIView):
    model = models.User
    serializer_class = serializers.UserSerializer
    permission_classes = [permissions.AllowAny]


# Allows user to modify their own data only
class ModifyUserView(generics.RetrieveUpdateDestroyAPIView):
    permission_classes = [
        permissions.IsAuthenticated,
        IsOwner
    ]
    model = models.User
    serializer_class = serializers.UserSerializer

    def get_object(self):
        return models.User.objects.get(pk=self.request.user.id)

    def retrieve(self, request, *args, **kwargs):
        user = models.User.objects.get(pk=request.user.id)
        serializer = serializers.UserSerializer(user)
        return Response(serializer.data)
