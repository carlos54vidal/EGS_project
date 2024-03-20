from rest_framework import serializers
from .models import Payments

class PaymentsSerializer(serializers.ModelSerializer):
    class Meta:
        model = Payments
        fields = ('id', 'client_unique_key', 'name', 'type', 'amount', 'paid', 'created_at', 'updated_at') 