from rest_framework import generics, permissions, viewsets, mixins, filters, pagination
from rest_framework.response import Response
from users.models import *
from users.serializers import *

class Pagination(pagination.PageNumberPagination):
    page_size = 4

class IsOwner(permissions.BasePermission):
    def has_object_permission(self, request, view, obj):
        if obj == request.user:
            return True
        else:
            return False


# Anyone can register
class UsersListView(mixins.CreateModelMixin, mixins.ListModelMixin, mixins.RetrieveModelMixin, viewsets.GenericViewSet):
    model = User
    serializer_class = UserSerializer
    permission_classes = [permissions.AllowAny]
    queryset = User.objects.all().order_by("first_name", "last_name", "username")
    filter_backends = [filters.SearchFilter]
    search_fields = ["username", "first_name", "last_name"]
    pagination_class = Pagination

    def get_serializer(self, *args, **kwargs):
        return super().get_serializer(*args, **kwargs)


# Allows user to modify their own data only
class ModifyUserView(generics.RetrieveUpdateDestroyAPIView):
    permission_classes = [
        permissions.IsAuthenticated,
        IsOwner
    ]
    model = User
    serializer_class = UserSerializer

    def get_object(self):
        return User.objects.get(pk=self.request.user.id)

    def retrieve(self, request, *args, **kwargs):
        user = User.objects.get(pk=request.user.id)
        serializer = UserSerializer(user, context={"request":request})
        return Response(serializer.data)
