from rest_framework import serializers
from .models import Payments
from .models import Clients

class PaymentsListSerializer(serializers.ModelSerializer):
    class Meta:
        model = Payments
        fields = ('id', 'client_unique_key', 'name', 'amount', 'paid', 'created_at', 'updated_at')

class PaymentsSerializer(serializers.ModelSerializer):
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

class ClientsSerializer(serializers.ModelSerializer):
    class Meta:
        model = Clients
        fields = ('name', 'email', 'iban', 'membership_plan', 'unique_key', 'state')