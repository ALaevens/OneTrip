from django.db import models
from django.contrib.contenttypes.models import ContentType
from django.contrib.contenttypes.fields import GenericForeignKey, GenericRelation

# Create your models here.
class Ingredient(models.Model):
    limit = models.Q(app_label="api", model="recipe") | models.Q(app_label="api", model="list")
    content_type = models.ForeignKey(ContentType, limit_choices_to=limit, on_delete=models.CASCADE)
    object_id = models.PositiveBigIntegerField()
    content_object = GenericForeignKey()


    name = models.CharField(max_length=50)
    in_stock = models.BooleanField(default=False)

class List(models.Model):
    # Foreign Key Recipe -> List [as recipes]
    extra_ingredients = GenericRelation(Ingredient, related_query_name="extra_ingredients")


class Homegroup(models.Model):
    # Foreign Key Recipe -> Homegroup [as recipes]
    # Foreign Key User -> Homegroup [as users]
    name = models.CharField(max_length=50)
    

class Recipe(models.Model):
    name = models.CharField(max_length=50)
    homegroup = models.ForeignKey(Homegroup, related_name="recipes", on_delete=models.CASCADE)
    list = models.ForeignKey(List, related_name="recipes", on_delete=models.SET_NULL, blank=True, null=True)
    ingredients = GenericRelation(Ingredient, related_query_name="ingredients")


