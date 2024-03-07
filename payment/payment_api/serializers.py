from rest_framework import serializers
from .models import CustomerDetail

class CustomerDetailSerializer(serializers.ModelSerializer):
    class Meta:
        model = CustomerDetail
        fields = ['all']