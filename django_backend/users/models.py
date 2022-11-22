from django.contrib.auth.models import AbstractUser
from django.db import models
from api.models import Homegroup

class User(AbstractUser):
    homegroup = models.ForeignKey(Homegroup, related_name="users", on_delete=models.SET_NULL, blank=True, null=True)