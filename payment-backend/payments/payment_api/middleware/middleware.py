from payment_api.models import Clients

class PaymentsMiddleware:
    def __init__(self, get_response):
        self.get_response = get_response

    def __call__(self, request):
        # Code to be executed for each request before the view (or next middleware) is called
        
        # Perform the database query
        
        header_value = request.headers.get('Client-unique-key')
        value_exists = Clients.objects.filter(unique_key=header_value).exists()

        if value_exists:            
            print("Value exists in the table.")
        
        #if header_value:
            #print("Header value:", header_value)
        else:
            print("Value does not exist in the table.")


        response = self.get_response(request)
        # Code to be executed for each request/response after the view is called
        return response