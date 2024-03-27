from django.db import models
import uuid

# Create your models here.

class Payments(models.Model):
    class Status(models.IntegerChoices):
        ACTIVE = 1, 'Active'
        INACTIVE = 2, 'Inactive'

    class Type(models.TextChoices):
        CREDITCARD = 'CC', 'Credit Card'
        PAYPAL = 'P', 'Paypal'
        OTHER = 'O', 'Others'

    amount = models.DecimalField(max_digits=10, decimal_places=2)
    description = models.CharField(max_length=100)
    paid = models.BooleanField(default=False)
    name = models.CharField(max_length=120)
    type = models.CharField(max_length=5, choices=Type.choices, blank=True)    
    client_unique_key = models.UUIDField(
        primary_key = False, 
        default = uuid.uuid4,
        editable = True,
        unique=True
        )
    is_active = models.BooleanField(default=True)
    status = models.IntegerField(choices=Status.choices, default=Status.ACTIVE)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

class Clients(models.Model):
    name = models.CharField(max_length=300)
    email = models.EmailField(max_length=254, unique=True)
    PLAN_CHOICES = (
        ('a', 'Standard'),
        ('b', 'Premium'),
        ('c', 'Premium Plus')
    )
    membership_plan = models.CharField(max_length=1, choices=PLAN_CHOICES)
    unique_key = models.UUIDField(
        primary_key = False,
        default = uuid.uuid4,
        editable = True,
        unique=True
        )
    STATE_CHOICES = (
        ('a', 'Active'),
        ('i', 'Inactive'),
        ('s', 'Suspended'),
        ('w', 'Awaiting Approval')
    )
    state = models.CharField(max_length=1, choices=STATE_CHOICES, default='w')
    
    def __str__(self) -> str:
        return self.name

    class Meta:
        verbose_name_plural = "API Clients"

