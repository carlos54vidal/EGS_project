# Generated by Django 5.0.3 on 2024-03-28 15:54

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('payment_api', '0018_alter_payments_client_unique_key'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='payments',
            name='type',
        ),
        migrations.AddField(
            model_name='payments',
            name='payment_unique_key',
            field=models.CharField(default='', max_length=36),
            preserve_default=False,
        ),
    ]