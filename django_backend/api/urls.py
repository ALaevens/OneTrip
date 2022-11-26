from django.urls import include, path
from rest_framework import routers
from api import views

router = routers.DefaultRouter()
router.register(r'recipes', views.RecipeView)
router.register(r'ingredients', views.IngredientView)
router.register(r'homegroups', views.HomegroupView)
router.register(r'groupinvites', views.HomegroupInviteView)

urlpatterns = [
    path('', include(router.urls))
]