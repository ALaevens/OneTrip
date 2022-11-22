from rest_framework import serializers
from api.models import *

class RecipeSerializer(serializers.ModelSerializer):
    ingredients = serializers.PrimaryKeyRelatedField(many=True, read_only=True)

    class Meta:
        model = Recipe
        fields = ["id", "name", "ingredients"]
        read_only_fields = ["id"]

class IngredientSerializer(serializers.ModelSerializer):
    class Meta:
        model = Ingredient
        fields = ["id", "name", "in_stock"]
        read_only_fields = ["id"]

class HomegroupSerializer(serializers.ModelSerializer):
    users = serializers.PrimaryKeyRelatedField(many=True, read_only=True)
    recipes = serializers.PrimaryKeyRelatedField(many=True, read_only=True)

    class Meta:
        model = Homegroup
        fields = ["id", "recipes", "users"]