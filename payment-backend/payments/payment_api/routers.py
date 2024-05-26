from rest_framework.routers import DefaultRouter
from .views import PaymentsViewSet,  ClientsViewSet, SendPostRequestViewSet
from . import views

router = DefaultRouter()
router.register('payment', PaymentsViewSet)
router.register('checkout/<uuid:pk>', PaymentsViewSet)
router.register('registration', ClientsViewSet)
router.register('mb-way', SendPostRequestViewSet, basename='mb-way')
router.register(r'send-post-request', views.SendPostRequestViewSet, basename='send_post_request')