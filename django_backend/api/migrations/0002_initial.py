# Generated by Django 4.1.3 on 2022-11-25 09:10

from django.conf import settings
from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    initial = True

    dependencies = [
        ('api', '0001_initial'),
        migrations.swappable_dependency(settings.AUTH_USER_MODEL),
    ]

    operations = [
        migrations.AddField(
            model_name='homegroupinvite',
            name='user',
            field=models.ForeignKey(blank=True, on_delete=django.db.models.deletion.CASCADE, related_name='invites', to=settings.AUTH_USER_MODEL),
        ),
        migrations.AddField(
            model_name='homegroup',
            name='invited_users',
            field=models.ManyToManyField(related_name='homegroup_invites', through='api.HomegroupInvite', to=settings.AUTH_USER_MODEL),
        ),
        migrations.AddField(
            model_name='recipe',
            name='list',
            field=models.ForeignKey(blank=True, null=True, on_delete=django.db.models.deletion.SET_NULL, related_name='recipes', to='api.list'),
        ),
        migrations.AlterUniqueTogether(
            name='homegroupinvite',
            unique_together={('homegroup', 'user')},
        ),
    ]
