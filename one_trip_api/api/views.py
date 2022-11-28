from rest_framework import viewsets, mixins, views, status, permissions
from rest_framework.response import Response
from api.serializers import *
from api.models import *

class RecipeView(viewsets.ModelViewSet):
    serializer_class = RecipeSerializer
    queryset = Recipe.objects.all()

class HomegroupView(viewsets.ModelViewSet):
    serializer_class = HomegroupSerializer
    queryset = Homegroup.objects.all()

class HomegroupInviteView(viewsets.ModelViewSet):
    serializer_class = InviteSerializer
    queryset = HomegroupInvite.objects.all() 

class RecipeIngredientView(viewsets.ModelViewSet):
    serializer_class = RecipeIngredientSerializer
    queryset = RecipeIngredient.objects.all()

class ListIngredientView(viewsets.ModelViewSet):
    serializer_class = ListIngredientSerializer
    queryset = ListIngredient.objects.all()

class ListView(mixins.RetrieveModelMixin, viewsets.GenericViewSet):
    serializer_class = ListSerializer
    queryset = List.objects.all()