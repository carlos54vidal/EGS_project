# Generated by Django 5.0.3 on 2024-03-28 15:23

import uuid
from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('payment_api', '0017_clients_paypal_client_id_alter_clients_email'),
    ]

    operations = [
        migrations.AlterField(
            model_name='payments',
            name='client_unique_key',
            field=models.UUIDField(default=uuid.uuid4),
        ),
    ]
