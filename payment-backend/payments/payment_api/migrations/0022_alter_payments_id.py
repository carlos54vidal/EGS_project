# Generated by Django 5.0.3 on 2024-04-03 15:19

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('payment_api', '0021_alter_payments_id'),
    ]

    operations = [
        migrations.AlterField(
            model_name='payments',
            name='id',
            field=models.CharField(max_length=120, primary_key=True, serialize=False),
        ),
    ]