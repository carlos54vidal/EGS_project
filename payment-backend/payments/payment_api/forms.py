# forms.py
from django import forms
from .models import Payments, Clients

class PaymentForm(forms.ModelForm):
    class Meta:
        model = Payments
        fields = ('amount', 'description',)
        widgets = {
            'amount': forms.NumberInput(attrs={'class': 'form-control'}),
            'description': forms.TextInput(attrs={'class': 'form-control'}),
        }

'''
class ClientsForm(forms.ModelForm):
    name = forms.CharField(max_length=255)
    email = forms.EmailField()

    class Meta:
        model = Clients
        fields = '__all__'


def form_validation_error(form):
    msg = ""
    for field in form:
        for error in field.errors:
            msg += "%s: %s \\n" % (field.label if hasattr(field, 'label') else 'Error', error)
    return msg
'''