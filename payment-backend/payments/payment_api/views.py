from django.shortcuts import render, redirect
from rest_framework import viewsets
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
#from django.views import View

from .models import Payments
from .serializers import PaymentsSerializer
#from .forms import PaymentForm

from .models import Clients
from .serializers import ClientsSerializer
from .forms import ClientsForm

# Create your views here.
class PaymentsViewSet(viewsets.ModelViewSet):
    queryset = Payments.objects.all()
    serializer_class = PaymentsSerializer

def payment(request,pk):
    print(request.headers)

    # Paypal
    payments = Payments.objects.get(client_unique_key=pk)
    context = {'payments':payments}
    return render (request, 'payment.html', context)
    # End Paypal
    
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

class ClientsCreateAPIView(APIView):
    serializer_class = ClientsSerializer
    
    #@api_view(['GET'])
    def get(self, request):
        form = ClientsForm()
        return render(request, 'clients_form.html', {'form': form})
    
    #@api_view(['POST'])
    def post(self, request):
        form = ClientsForm(request.data)
        if form.is_valid():
            #client = form.save()
            #email = client.email  # Access the email field value from the saved client object            
            #unique_key = Clients.objects.get(unique_key=email)            
            client = form.save(commit=False)  # Save the form data without committing to the database yet
            # Perform any additional processing if needed before saving

            # Save the object to generate the unique_key
            client.save()
            unique_key = client.unique_key  # Access the unique_key field value from the saved client object    
            return render(request, 'success.html', {'unique_key': unique_key})  # Pass the unique_key value to the success template
            #return Response({'message': 'Client created successfully'}, status=status.HTTP_201_CREATED)
        else:
            #form = ClientsForm()
            return render(request, 'clients_form_retry.html', {'form': form})
            #return Response(form.errors, status=status.HTTP_400_BAD_REQUEST)
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
