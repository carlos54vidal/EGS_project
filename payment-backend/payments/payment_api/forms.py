# forms.py
from django import forms
from .models import Payments, Clients
from django.core.exceptions import ValidationError

class PaymentForm(forms.ModelForm):
    class Meta:
        model = Payments
        fields = ('amount', 'description',)
        widgets = {
            'amount': forms.NumberInput(attrs={'class': 'form-control'}),
            'description': forms.TextInput(attrs={'class': 'form-control'}),
        }

class ClientsForm(forms.ModelForm):
    #email = forms.EmailField(required=True, error_messages={'invalid': 'Your email address is incorrect'})
    #state = forms.CharField(widget=forms.HiddenInput(), initial='w')
    #name = forms.CharField(required=True, max_length=300)
    #membership_plan = forms.CharField()
    class Meta:
        model = Clients
        fields = ['name', 'email', 'paypal_client_id', 'membership_plan']  # Specify fields to include in the form

    def clean_email(self):
        email = self.cleaned_data['email']
        if Clients.objects.filter(email=email).exists():
            # Email is valid, perform your desired actions
            raise ValidationError("e-mail already exists")            
        return email
        
def form_validation_error(form):
    msg = ""
    for field in form:
        for error in field.errors:
            msg += "%s: %s \\n" % (field.label if hasattr(field, 'label') else 'Error', error)
    return msg
