from rest_framework import viewsets

from api.serializers import *
from api.models import *

class RecipeView(viewsets.ModelViewSet):
    serializer_class = RecipeSerializer
    queryset = Recipe.objects.all()

class IngredientView(viewsets.ModelViewSet):
    serializer_class = IngredientSerializer
    queryset = Ingredient.objects.all()

class HomegroupView(viewsets.ModelViewSet):
    serializer_class = HomegroupSerializer
    queryset = Homegroup.objects.all()
