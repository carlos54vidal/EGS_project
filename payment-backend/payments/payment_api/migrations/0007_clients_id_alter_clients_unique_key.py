# Generated by Django 5.0.3 on 2024-03-25 14:31

import uuid
from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('payment_api', '0006_remove_clients_id_alter_clients_unique_key'),
    ]

    operations = [
        migrations.AddField(
            model_name='clients',
            name='id',
            field=models.BigAutoField(auto_created=True, default=1, primary_key=True, serialize=False, verbose_name='ID'),
            preserve_default=False,
        ),
        migrations.AlterField(
            model_name='clients',
            name='unique_key',
            field=models.UUIDField(default=uuid.uuid4, unique=True),
        ),
    ]
