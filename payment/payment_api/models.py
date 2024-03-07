from django.db import models

# Create your models here.


class CustomerDetail(models.Model):
    cusotomer_name = models.CharField(max_length=100,null=True)
    customer_email = models.EmailField()
    customer_city = models.CharField(max_length=10, null=True)
    customer_state = models.CharField(max_length=10, null=True)
    customer_country = models.CharField(max_length=10, null=True)

    def __str__(self):
        return self.cusotomer_name