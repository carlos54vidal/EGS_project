from rest_framework import serializers
from .models import Payments

class PaymentsSerializer(serializers.ModelSerializer):
    class Meta:
        model = Payments
        fields = ('id', 'name', 'type', 'is_active', 'created_at', 'updated_at')