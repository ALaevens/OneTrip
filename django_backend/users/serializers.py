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

    class Meta:
        model = User
        fields = ("id", "username", "email", "password")
        write_only_fields = ("password",)
        read_only_fields = ("id",)
