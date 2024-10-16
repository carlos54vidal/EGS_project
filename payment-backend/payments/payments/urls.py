"""
URL configuration for payments project.

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/5.0/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""
from django.contrib import admin
from django.urls import path, include

from drf_spectacular.views import SpectacularAPIView
from drf_spectacular.views import SpectacularRedocView, SpectacularSwaggerView

from payment_api.routers import router

from payment_api import views

from payment_api.views import ClientsViewSet, PaymentCompleteAPIView, SendPostRequestViewSet

from rest_framework.routers import DefaultRouter


urlpatterns = [
    path('admin/', admin.site.urls),
    path('', include(router.urls)),
    path('schema/', SpectacularAPIView.as_view(), name='schema'),
    # Swagger UI:
    path('docs/', SpectacularSwaggerView.as_view(url_name='schema'), name='swagger-ui'),
    # Redoc UI:
    path('redoc/', SpectacularRedocView.as_view(url_name='schema'), name='redoc'),
    path('checkout/<uuid:pk>/', views.payment_pid, name='payment_pid'),
    path('payment/<uuid:cid>/<uuid:pid>/', views.payment, name='payment'),
    # path('process_payment/<str:client_secret>/', views.process_payment, name='process_payment'),

    # URL pattern for the form
    path('registration/', ClientsViewSet.as_view({'post': 'create', 'get': 'list'}), name='registration'),
    path('send_post_request/', SendPostRequestViewSet.as_view({'post': 'create', 'get': 'list'}), name='send_post_request'),
    # path('send-post-request/', views.SendPostRequestView.as_view(), name='send_post_request'),

    path('payment_complete/', PaymentCompleteAPIView.as_view(), name='payment_complete'),
]
