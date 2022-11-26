from django.contrib import admin
from django.contrib.auth.admin import UserAdmin
from .models import User

class CustomUserAdmin(UserAdmin):
    fieldsets = (
        (None, {"fields": ("username", "password", "image", "homegroup")}),
        ("Personal info", {"fields": ("first_name", "last_name")}),
        # (
        #     "Permissions",
        #     {
        #         "fields": (
        #             "is_active",
        #             "is_staff",
        #             "is_superuser",
        #         ),
        #     },
        # ),
        ("Important dates", {"fields": ("last_login", "date_joined")}),
    )
    add_fieldsets = (
        (
            None,
            {
                "classes": ("wide",),
                "fields": ("username", "password1", "password2", "homegroup"),
            },
        ),
    )

admin.site.register(User, CustomUserAdmin)