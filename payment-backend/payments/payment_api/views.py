from django.shortcuts import render, redirect
# from django.http import JsonResponse
from rest_framework import viewsets, status
from rest_framework.response import Response
from drf_spectacular.utils import extend_schema
from rest_framework.views import APIView
from rest_framework.exceptions import MethodNotAllowed
from django.http import JsonResponse
from django.views import View
from .serializers import PaymentsSerializer, PaymentRequestSerializer, PaymentsListSerializer, PaymentsCreateUpdateSerializer, PaymentCompleteSerializer, ClientsSerializer
import requests
#from django.views import View

from .models import Payments, Clients
#from .forms import PaymentForm

from .forms import ClientsForm, PaymentForm
import datetime
from django.contrib import messages




class PaymentsViewSet(viewsets.ModelViewSet):
    queryset = Payments.objects.all()

    def get_serializer_class(self):
        if self.action == 'list' or self.action == 'retrieve':
            return PaymentsListSerializer  # Serializer for GET requests
        elif self.action == 'create' or self.action == 'update' or self.action == 'partial_update':
            return PaymentsCreateUpdateSerializer  # Serializer for POST, PUT, PATCH requests
        else:
            return PaymentsSerializer  # Default serializer

def payment(request, cid, pid):
    print(request.headers)

    # Paypal
    clients = Clients.objects.get (unique_key=cid)
    payments = Payments.objects.get(id=pid)
    context = {'payments':payments, 'clients':clients}
    
    return render (request, 'payment.html', context)
    # End Paypal


def payment_pid(request, pk):
    print(request.headers)

    payments = Payments.objects.get(id=pk)
    context = {'payments':payments}
    
    return render (request, 'payment.html', context)

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
            payment = Payments.objects.get(id=payment_id)
            payment.paid = True
            payment.save()

            messages.success(request, 'Payment successful!')
            return redirect('success')

    context = {'client_secret': client_secret}
    return render(request, 'process_payment.html', context)

class SendPostRequestViewSet(viewsets.ViewSet):
    queryset = Payments.objects.all()
    serializer_class = PaymentsSerializer

    def list(self, request):
        #form = PaymentForm()        
        print(request)
        return render(request, 'mb-way.html')
    
    def retrieve(self, request):
        form = PaymentForm()
        print(request)
        return render(request, 'mb-way.html', {'form': form})

    def create(self, request):
        form = PaymentForm(request.POST)
        if form.is_valid():
            payment_data = form.cleaned_data
            serializer = PaymentsSerializer(data=payment_data)
            if serializer.is_valid():
                amount = serializer.validated_data['amount']
                description = serializer.validated_data['description']
                current_datetime = datetime.datetime.now().isoformat()
                payload = {
                    "merchant": {
                        "terminalId": 66779,
                        "channel": "web",
                        "merchantTransactionId": "teste 1"
                    },
                    "transaction": {
                        "transactionTimestamp": current_datetime,
                        "description": description,
                        "moto": False,
                        "paymentType": "PURS",
                        "amount": {
                            "value": amount,
                            "currency": "EUR"
                        },
                        "paymentMethod": [
                            "CARD",
                            "REFERENCE",
                            "QRCODE",
                            "MBWAY"
                        ]                        
                    }                    
                }
                url = "https://api.qly.sibspayments.com/sibs/spg/v2/payments"
                headers = {
                    "X-IBM-Client-Id": "c59a9673-199a-4a6e-9767-4c6aa70fc910",
                    "Content-Type": "application/json",
                    "Authorization": "Bearer 0267adfae94c224be1b374be2ce7b298f0.eyJlIjoiMjAyODgxNjU2NDgxMSIsInJvbGVzIjoiTUFOQUdFUiIsInRva2VuQXBwRGF0YSI6IntcIm1jXCI6XCI1MDU0MjVcIixcInRjXCI6XCI2Njc3OVwifSIsImkiOiIxNzEzMjgzNzY0ODExIiwiaXMiOiJodHRwczovL3FseS5zaXRlMS5zc28uc3lzLnNpYnMucHQvYXV0aC9yZWFsbXMvREVWLlNCTy1JTlQuUE9SVDEiLCJ0eXAiOiJCZWFyZXIiLCJpZCI6Ijh6RWtRQUJaM2NlOTY3MzljMWIxNGU0NTBjYTNhMDVjMzBkNWJmM2QwYSJ9.51730f0d62b69c39b0a2bb5d4547f02e13e5110138946333323295414f94620368d060e4d6e90577d4cc555623bfefb3215655f5d8ad05c5bb0476f451a78cbe"
                }
                response = requests.post(url, headers=headers, json=payload)

                if response.status_code == 200:
                    response_data = response.json()
                    transaction_id = response_data.get("transactionId")
                    status = response_data.get("status")
                    transaction_signature = response_data.get("transactionSignature")

                    phone_value = request.POST.get('phone')

                    if transaction_id and transaction_signature:
                        second_url = f"https://api.qly.sibspayments.com/sibs/spg/v2/payments/{transaction_id}/mbway-id/purchase"
                        second_headers = {
                            "Content-Type": "application/json",
                            "X-IBM-Client-Id": "c59a9673-199a-4a6e-9767-4c6aa70fc910",
                            "Authorization": f"Digest {transaction_signature}"
                        }
                        second_payload = {
                            "customerPhone": phone_value
                        }
                        second_response = requests.post(second_url, headers=second_headers, json=second_payload)

                        if second_response.status_code == 200:
                            second_response_data = second_response.json()
                            purchase_status = second_response_data.get("status")
                            return JsonResponse({
                                'status': 'success',
                                'transactionId': transaction_id,
                                'paymentStatus': status,
                                'purchaseStatus': purchase_status
                            }, status=200)
                        else:
                            return JsonResponse({
                                'status': 'error',
                                'message': 'Second request failed',
                                'details': second_response.text
                            }, status=second_response.status_code)
                    else:
                        return JsonResponse({'status': 'error', 'message': 'Transaction ID or Signature not found'}, status=400)
                else:
                    return JsonResponse({'status': 'error', 'message': response.text}, status=response.status_code)
            else:
                return JsonResponse({'status': 'error', 'errors': serializer.errors}, status=400)
        else:
            return JsonResponse({'status': 'error', 'errors': form.errors}, status=400)