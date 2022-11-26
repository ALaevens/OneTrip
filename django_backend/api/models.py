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
    # Foreign Key Recipe -> List [as recipes]
    extra_ingredients = GenericRelation(Ingredient, related_query_name="extra_ingredients")
    homegroup = models.OneToOneField(Homegroup, on_delete=models.CASCADE, primary_key=True)
    

class Recipe(models.Model):
    name = models.CharField(max_length=50)
    homegroup = models.ForeignKey(Homegroup, related_name="recipes", on_delete=models.CASCADE)
    list = models.ForeignKey(List, related_name="recipes", on_delete=models.SET_NULL, blank=True, null=True)
    ingredients = GenericRelation(Ingredient, related_query_name="ingredients")


