# Generated by Django 5.0.3 on 2024-04-04 09:47

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('payment_api', '0024_remove_clients_paypal_client_id_clients_iban_and_more'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='clients',
            name='iban',
        ),
        migrations.AddField(
            model_name='clients',
            name='paypal_client_id',
            field=models.CharField(default='', max_length=80),
            preserve_default=False,
        ),
    ]
