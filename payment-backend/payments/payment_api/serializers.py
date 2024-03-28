from rest_framework import serializers
from .models import Payments
from .models import Clients

class PaymentsSerializer(serializers.ModelSerializer):
    class Meta:
        model = Payments
        fields = ('id', 'client_unique_key', 'name', 'type', 'amount', 'paid', 'created_at', 'updated_at')

class ClientsSerializer(serializers.ModelSerializer):
    class Meta:
        model = Clients
        fields = ('name', 'email', 'membership_plan', 'unique_key', 'state')