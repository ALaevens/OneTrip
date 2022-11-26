# Generated by Django 4.1.3 on 2022-11-25 09:10

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    initial = True

    dependencies = [
        ('contenttypes', '0002_remove_content_type_name'),
    ]

    operations = [
        migrations.CreateModel(
            name='Homegroup',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('name', models.CharField(max_length=50)),
            ],
        ),
        migrations.CreateModel(
            name='List',
            fields=[
                ('homegroup', models.OneToOneField(on_delete=django.db.models.deletion.CASCADE, primary_key=True, serialize=False, to='api.homegroup')),
            ],
        ),
        migrations.CreateModel(
            name='Recipe',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('name', models.CharField(max_length=50)),
                ('homegroup', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='recipes', to='api.homegroup')),
            ],
        ),
        migrations.CreateModel(
            name='Ingredient',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('object_id', models.PositiveBigIntegerField()),
                ('name', models.CharField(max_length=50)),
                ('in_stock', models.BooleanField(default=False)),
                ('content_type', models.ForeignKey(limit_choices_to=models.Q(models.Q(('app_label', 'api'), ('model', 'recipe')), models.Q(('app_label', 'api'), ('model', 'list')), _connector='OR'), on_delete=django.db.models.deletion.CASCADE, to='contenttypes.contenttype')),
            ],
        ),
        migrations.CreateModel(
            name='HomegroupInvite',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('homegroup', models.ForeignKey(blank=True, on_delete=django.db.models.deletion.CASCADE, related_name='invites', to='api.homegroup')),
            ],
        ),
    ]
