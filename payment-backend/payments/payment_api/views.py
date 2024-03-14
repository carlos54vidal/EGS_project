from django.shortcuts import render, redirect
from rest_framework import viewsets

from .models import Payments
from .serializers import PaymentsSerializer
from .forms import PaymentForm

# Create your views here.
class PaymentsViewSet(viewsets.ModelViewSet):
    queryset = Payments.objects.all()
    serializer_class = PaymentsSerializer

def payment(request):
    form = PaymentForm(request.POST or None)

    if request.method == "POST":
        if form.is_valid():
            payment = form.save(commit=False)
            payment.user = request.user
            payment.save()

            '''# Create a Stripe PaymentIntent
            stripe.api_key = settings.STRIPE_PRIVATE_KEY
            intent = stripe.PaymentIntent.create(
                amount=int(payment.amount * 100),
                currency='usd',
                metadata={'payment_id': payment.id}
            )'''

            # Redirect to the payment processing view
            return redirect('process_payment', intent.client_secret)

    context = {'form': form}
    return render(request, 'payment.html', context)

def process_payment(request, client_secret):
    if request.method == "POST":
        '''stripe.api_key = settings.STRIPE_PRIVATE_KEY
        intent = stripe.PaymentIntent.confirm(client_secret)'''

        if intent.status == 'succeeded':
            # Update the Payment model
            payment_id = intent.metadata['payment_id']
            payment = Payment.objects.get(id=payment_id)
            payment.paid = True
            payment.save()

            messages.success(request, 'Payment successful!')
            return redirect('success')

    context = {'client_secret': client_secret}
    return render(request, 'process_payment.html', context)
