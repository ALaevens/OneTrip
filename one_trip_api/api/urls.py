from django.urls import include, path
from rest_framework import routers
from api import views

router = routers.DefaultRouter()
router.register(r'recipes', views.RecipeView)
router.register(r'lists', views.ListView)
router.register(r'recipeingredients', views.RecipeIngredientView)
router.register(r'listingredients', views.ListIngredientView)
router.register(r'homegroups', views.HomegroupView)
router.register(r'groupinvites', views.HomegroupInviteView)

urlpatterns = [
    path('', include(router.urls)),
    # path('ingredienttypes/', views.IngredientContentTypesView.as_view())
]