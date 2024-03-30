from rest_framework import serializers
from .models import Payments
from .models import Clients

class PaymentsSerializer(serializers.ModelSerializer):
    class Meta:
        model = Payments
        fields = ('id', 'client_unique_key', 'name', 'payment_unique_key', 'amount', 'paid', 'created_at', 'updated_at')

class PaymentCompleteSerializer(serializers.ModelSerializer):
    class Meta:
        model = Payments
        fields = ('id', 'paid')

class ClientsSerializer(serializers.ModelSerializer):
    class Meta:
        model = Clients
        fields = ('name', 'email', 'paypal_client_id', 'membership_plan', 'unique_key', 'state')