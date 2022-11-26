from django.contrib.auth.models import AbstractUser
from django.db import models
from api.models import Homegroup
from pathlib import Path

def image_path(instance, fname):
    extension = Path(fname).suffix
    return f"profile-images/{instance.id}{extension}"

class User(AbstractUser):
    homegroup = models.ForeignKey(Homegroup, related_name="users", on_delete=models.SET_NULL, blank=True, null=True)
    image = models.ImageField(upload_to=image_path, null=True, blank=True)

