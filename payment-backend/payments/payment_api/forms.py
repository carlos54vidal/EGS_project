# forms.py
from django import forms
from .models import Payments

class PaymentForm(forms.ModelForm):
    class Meta:
        model = Payments
        fields = ('amount', 'description',)
        widgets = {
            'amount': forms.NumberInput(attrs={'class': 'form-control'}),
            'description': forms.TextInput(attrs={'class': 'form-control'}),
        }
