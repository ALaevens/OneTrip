from rest_framework import serializers
from users.models import User

class UserSerializer(serializers.ModelSerializer):  # https://stackoverflow.com/a/29867704/17834235
    def create(self, validated_data):
        user = User.objects.create()

        user.set_password(validated_data["password"])
        validated_data.pop("password")

        for field in validated_data:
            setattr(user, field, validated_data[field])

        user.save()
        return user

    def update(self, instance, validated_data):
        if "password" in validated_data:
            password = validated_data.pop("password")
            instance.set_password(password)

        return super().update(instance, validated_data)

    image = serializers.ImageField(required=False, max_length=None, use_url=False)

    class Meta:
        model = User
        fields = ("id", "username", "first_name", "last_name", "password", "image", "homegroup", "homegroup_invites")
        write_only_fields = ("password",)
        read_only_fields = ("id", "homegroup_invites")
