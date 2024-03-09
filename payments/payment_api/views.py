from django.shortcuts import render
from rest_framework import viewsets

from .models import Payments
from .serializers import PaymentsSerializer

# Create your views here.
class PaymentsViewSet(viewsets.ModelViewSet):
    queryset = Payments.objects.all()
    serializer_class = PaymentsSerializer
