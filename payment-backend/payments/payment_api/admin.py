from django.contrib import admin

# Register your models here.
from . models import Clients

#admin.site.register(Clients)

admin.site.site_header = 'Payments'

class ClientsAdmin(admin.ModelAdmin):

    fields = (
        'name',
        'membership_plan',
        'unique_key',
    )

    list_display = ['name', 'membership_plan', 'unique_key']

    list_filter = ['membership_plan']

admin.site.register(Clients, ClientsAdmin)