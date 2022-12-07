from django.db import models
from django.contrib.contenttypes.models import ContentType
from django.contrib.contenttypes.fields import GenericForeignKey, GenericRelation

# Create your models here.

class HomegroupInvite(models.Model):
    homegroup = models.ForeignKey("api.Homegroup", on_delete=models.CASCADE, related_name="invites", blank=True)
    user = models.ForeignKey("users.User", on_delete=models.CASCADE, related_name="invites", blank=True)

    class Meta:
        unique_together = ("homegroup", "user")

class Homegroup(models.Model):
    # Foreign Key Recipe -> Homegroup [as recipes]
    # Foreign Key User -> Homegroup [as users]
    name = models.CharField(max_length=50)
    invited_users = models.ManyToManyField("users.User", related_name="homegroup_invites", through=HomegroupInvite)

    def __repr__(self):
        return f"{self.id}: {self.name}"

    def __str__(self):
        return f"{self.id}: {self.name}"

class List(models.Model):
    # Foreign Key ListIngredient -> List [as ingredients]
    homegroup = models.OneToOneField(Homegroup, on_delete=models.CASCADE, primary_key=True)
    

class Recipe(models.Model):
    # Foreign Key RecipeIngredient -> List [as ingredients]
    name = models.CharField(max_length=50)
    homegroup = models.ForeignKey(Homegroup, related_name="recipes", on_delete=models.CASCADE)


class RecipeIngredient(models.Model):
    name = models.CharField(max_length=50)
    quantity = models.CharField(max_length=50, null=True, blank=True)
    recipe = models.ForeignKey(Recipe, on_delete=models.CASCADE, related_name="ingredients")

class ListIngredient(models.Model):
    name = models.CharField(max_length=50)
    quantity = models.CharField(max_length=50, null=True, blank=True)
    list = models.ForeignKey(List, on_delete=models.CASCADE, related_name="ingredients")
    in_cart = models.BooleanField(default=False)