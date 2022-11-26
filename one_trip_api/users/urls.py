from django.urls import path, include
from rest_framework.authtoken import views as authviews
from rest_framework import routers
from users import views

router = routers.DefaultRouter()
router.register(r'users', views.UsersListView)

urlpatterns = [
    path('', include(router.urls)),
    path('token', authviews.obtain_auth_token, name="api-token-auth"),
    # path('users', views.RegisterUserView),  # Exposes POST to everyone for registering
    path('users/me', views.ModifyUserView.as_view()) # exposes GET / PUT / PATCH / DELETE for registered users for their user object
]
