from django.contrib import admin
from django.contrib.contenttypes.admin import GenericTabularInline
from users.models import User
import nested_admin

from api.models import *
# Register your models here.

# class IngredientInline(nested_admin.NestedGenericTabularInline):
#     model = Ingredient
#     extra = 0

class RecipeIngredientInline(nested_admin.NestedTabularInline):
    model = RecipeIngredient
    extra = 0

class ListIngredientInline(nested_admin.NestedTabularInline):
    model = ListIngredient
    extra = 0

class UserInline(nested_admin.NestedTabularInline):
    model = User
    fields = ("username",)
    readonly_fields = ("username",)
    extra = 0

    def has_add_permission(self, request, obj=None):
        return False

    def has_delete_permission(self, request, obj=None):
        return False

class HomegroupInviteInline(nested_admin.NestedTabularInline):
    model = HomegroupInvite
    extra = 0

class RecipeInline(nested_admin.NestedTabularInline):
    model = Recipe
    inlines = (RecipeIngredientInline,)
    extra = 0

@admin.register(Recipe)
class RecipeAdmin(nested_admin.NestedModelAdmin):
    list_display = ("name",)
    inlines = (RecipeIngredientInline,)

@admin.register(Homegroup)
class HomegroupAdmin(nested_admin.NestedModelAdmin):
    list_display = ("id", "name")
    inlines = (UserInline, HomegroupInviteInline, RecipeInline,)

@admin.register(List)
class ListAdmin(nested_admin.NestedModelAdmin):
    list_display = ("homegroup",)
    inlines = (ListIngredientInline,)
