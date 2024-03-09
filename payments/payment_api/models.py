from django.db import models

# Create your models here.

class Payments(models.Model):
    class Status(models.IntegerChoices):
        ACTIVE = 1, 'Active'
        INACTIVE = 2, 'Inactive'

    class Gender(models.TextChoices):
        MALE = 'M', 'Male'
        FEMALE = 'F', 'Female'
        OTHER = 'O', 'Others'

    name = models.CharField(max_length=120)
    gender = models.CharField(max_length=1, choices=Gender.choices, blank=True)
    is_active = models.BooleanField(default=True)
    status = models.IntegerField(choices=Status.choices, default=Status.ACTIVE)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)