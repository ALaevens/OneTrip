from rest_framework import viewsets, mixins, permissions, request, pagination, filters
from rest_framework.response import Response
from rest_framework.request import Request
from api.serializers import *
from api.models import *

class HasHomegroup(permissions.BasePermission):
    def has_permission(self, request: Request, view):
        if not request.user.homegroup:
            return False

        return super().has_permission(request, view)

class Pagination(pagination.PageNumberPagination):
    page_size = 10

class NoListModelViewset(mixins.CreateModelMixin, mixins.DestroyModelMixin, mixins.UpdateModelMixin, mixins.RetrieveModelMixin, viewsets.GenericViewSet):
    pass

class RecipeSearchView(viewsets.ModelViewSet):
    serializer_class = RecipeSerializer
    permission_classes = [permissions.IsAuthenticated, HasHomegroup]
    queryset = Recipe.objects.all()
    filter_backends = [filters.SearchFilter]
    search_fields = ["name"]
    pagination_class = Pagination

    def list(self, request: Request, *args, **kwargs):
        queryset = self.filter_queryset(Recipe.objects.filter(homegroup=request.user.homegroup).order_by("name"));

        page = self.paginate_queryset(queryset)
        if page is not None:
            serializer = self.get_serializer(page, many=True)
            return self.get_paginated_response(serializer.data)

        serializer = self.serializer_class(queryset, many=True)
        return Response(serializer.data)

class RecipeAllView(viewsets.ModelViewSet):
    serializer_class = RecipeSerializer
    permission_classes = [permissions.IsAuthenticated, HasHomegroup]
    queryset = Recipe.objects.all()
    filter_backends = [filters.SearchFilter]
    search_fields = ["name"]

    def list(self, request: Request, *args, **kwargs):
        queryset = self.filter_queryset(Recipe.objects.filter(homegroup=request.user.homegroup).order_by("name"));
        serializer = self.serializer_class(queryset, many=True)
        return Response(serializer.data)

class HomegroupView(viewsets.ModelViewSet):
    serializer_class = HomegroupSerializer
    queryset = Homegroup.objects.all()

class HomegroupInviteView(NoListModelViewset):
    serializer_class = InviteSerializer
    queryset = HomegroupInvite.objects.all() 

class RecipeIngredientView(NoListModelViewset):
    serializer_class = RecipeIngredientSerializer
    queryset = RecipeIngredient.objects.all()

class ListIngredientView(NoListModelViewset):
    serializer_class = ListIngredientSerializer
    queryset = ListIngredient.objects.all()

class ListView(mixins.RetrieveModelMixin, mixins.UpdateModelMixin, viewsets.GenericViewSet):
    serializer_class = ListSerializer
    queryset = List.objects.all()