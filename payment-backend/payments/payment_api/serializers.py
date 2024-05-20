from rest_framework import serializers
from .models import Payments
from .models import Clients

class PaymentsListSerializer(serializers.ModelSerializer):
    class Meta:
        model = Payments
        fields = ('id', 'client_unique_key', 'name', 'amount', 'paid', 'created_at', 'updated_at')

class PaymentsSerializer(serializers.ModelSerializer):    
    amount = serializers.DecimalField(max_digits=10, decimal_places=2)
    description = serializers.CharField(max_length=255)

    class Meta:
        model = Payments
        fields = ('id', 'client_unique_key', 'name', 'amount', 'paid', 'created_at', 'updated_at')


class PaymentsCreateUpdateSerializer(serializers.ModelSerializer):
    class Meta:
        model = Payments
        fields = ('id', 'client_unique_key', 'name', 'amount', 'created_at', 'updated_at')


class PaymentCompleteSerializer(serializers.ModelSerializer):
    class Meta: 
        model = Payments
        fields = ('id', 'paid')

class PaymentRequestSerializer(serializers.Serializer):
    transactionId = serializers.CharField(max_length=100)
    transactionSignature = serializers.CharField(max_length=100)

class PaymentResponseSerializer(serializers.Serializer):
    # Define fields to capture the response from the external API
    # Adjust these fields according to the response structure
    status = serializers.CharField()
    # Add other fields as needed based on the response

class ClientsSerializer(serializers.ModelSerializer):
    class Meta:
        model = Clients
        fields = ('name', 'email', 'iban', 'membership_plan', 'unique_key', 'state')