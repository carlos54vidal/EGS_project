from django.shortcuts import render, redirect
# from django.http import JsonResponse
from rest_framework import viewsets
from rest_framework.response import Response
from rest_framework import status
from drf_spectacular.utils import extend_schema
from rest_framework.views import APIView
from rest_framework.exceptions import MethodNotAllowed
import json
#from django.views import View

from .models import Payments
from .serializers import PaymentsSerializer
#from .forms import PaymentForm
from .serializers import PaymentsListSerializer
from .serializers import PaymentsCreateUpdateSerializer

from .serializers import PaymentCompleteSerializer

from .models import Clients
from .serializers import ClientsSerializer
from .forms import ClientsForm

# Create your views here.
class PaymentsViewSet(viewsets.ModelViewSet):
    queryset = Payments.objects.all()

    def get_serializer_class(self):
        if self.action == 'list' or self.action == 'retrieve':
            return PaymentsListSerializer  # Serializer for GET requests
        elif self.action == 'create' or self.action == 'update' or self.action == 'partial_update':
            return PaymentsCreateUpdateSerializer  # Serializer for POST, PUT, PATCH requests
        else:
            return PaymentsSerializer  # Default serializer

def payment(request, pid):
    print(request.headers)

    # Paypal
    payments = Payments.objects.get(id=pid)
    context = {'payments':payments}
    
    return render (request, 'payment.html', context)
    # End Paypal

class PaymentCompleteAPIView(APIView):
    serializer_class = PaymentCompleteSerializer
    @extend_schema(
        description="Endpoint to complete payment by updating payment status",
        responses={200: None, 400: {"error": "Invalid JSON data"}}
    )
    
    def patch(self, request):
        # Assuming the request body contains JSON data
        try:
            body = self.request.data  # Access request data instead of request.body            

            # Query the database for the corresponding payment record
            payment = Payments.objects.get(id=body['paymentId'])

            # Update the 'paid' field of the payment record
            payment.paid = True
            payment.save()
            return Response({'message': 'Payment updated successfully'})
        except KeyError:
            return Response({'error': 'Invalid request data. Ensure paymentId is provided.'}, status=status.HTTP_400_BAD_REQUEST)
        except Payments.DoesNotExist:
            return Response({'error': 'Payment not found'}, status=status.HTTP_404_NOT_FOUND)

    def handle_exception(self, exc):
        if isinstance(exc, MethodNotAllowed):
            return Response({'error': 'Method not allowed'}, status=status.HTTP_405_METHOD_NOT_ALLOWED)
        return super().handle_exception(exc)
    
    '''
    form = PaymentForm(request.POST or None)

    if request.method == "POST":
        if form.is_valid():
            payment = form.save(commit=False)
            payment.user = request.user
            payment.save()

            # Create a Stripe PaymentIntent
            stripe.api_key = settings.STRIPE_PRIVATE_KEY
            intent = stripe.PaymentIntent.create(
                amount=int(payment.amount * 100),
                currency='usd',
                metadata={'payment_id': payment.id}
            )

            # Redirect to the payment processing view
            return redirect('process_payment', intent.client_secret)

    context = {'form': form}
    return render(request, 'payment.html', context)
    '''

class ClientsViewSet(viewsets.ViewSet):
    queryset = Clients.objects.all()
    serializer_class = ClientsSerializer
    
    def create(self, request):
        form = ClientsForm(request.data)
        if form.is_valid():
            client = form.save()
            unique_key = client.unique_key 
            return render(request, 'success.html', {'unique_key': unique_key})
        else:
            return render(request, 'clients_form_retry.html', {'form': form})
        
    def retrieve(self, request):
        form = ClientsForm()
        return render(request, 'clients_form.html', {'form': form})
    
    def list(self, request):
        form = ClientsForm()
        return render(request, 'clients_form.html', {'form': form}) 
'''
class ClientsViewSet(viewsets.ViewSet):
    
    def create(self, request):
        # Perform any necessary validation on request.data if needed
        
        # Get or create Clients object
        client, created = Clients.objects.get_or_create()
        
        # Serialize the Clients object
        serializer = ClientsSerializer(client)
        
        # Render the clients_form.html template with the serialized data
        return render(request, 'clients_form.html', {'client_data': serializer.data})
    
    def list(self, request):
         # Render the clients_form.html template for GET requests
        return render(request, 'clients_form.html', {})
        '''


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
