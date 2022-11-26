from rest_framework import serializers
from api.models import *
from users.serializers import UserSerializer

class IngredientSerializer(serializers.ModelSerializer):
    class Meta:
        model = Ingredient
        fields = ["id", "name", "in_stock", "content_type", "object_id"]
        read_only_fields = ["id"]

class RecipeSerializer(serializers.ModelSerializer):
    # ingredients = serializers.PrimaryKeyRelatedField(many=True, read_only=True)
    # ingredients = IngredientSerializer(many=True, read_only=True)
    ingredients = serializers.SerializerMethodField()

    class Meta:
        model = Recipe
        fields = ["id", "name", "ingredients"]
        read_only_fields = ["id"]

    def get_ingredients(self, instance):
        ingredients = instance.ingredients.all().order_by("name")
        return IngredientSerializer(ingredients, many=True).data

class HomegroupSerializer(serializers.ModelSerializer):
    users = serializers.PrimaryKeyRelatedField(many=True, read_only=True)
    recipes = serializers.PrimaryKeyRelatedField(many=True, read_only=True)

    def create(self, validated_data):
        homegroup = super().create(validated_data)
        List.objects.get_or_create(homegroup=homegroup)
        return homegroup

    class Meta:
        model = Homegroup
        fields = ["id", "name", "recipes", "users", "invites"]
        read_only_fields = ["recipes", "users", "invites"]

class InviteSerializer(serializers.ModelSerializer):
    class Meta:
        model = HomegroupInvite
        fields = ["id", "homegroup", "user"]