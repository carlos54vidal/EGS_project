# Generated by Django 5.0.4 on 2024-04-16 23:01

import uuid
from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('payment_api', '0004_alter_clients_options_remove_payments_type_and_more'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='payments',
            name='id',
        ),
        migrations.AlterField(
            model_name='payments',
            name='temp_id',
            field=models.UUIDField(default=uuid.uuid4, primary_key=True, serialize=False),
        ),
    ]
