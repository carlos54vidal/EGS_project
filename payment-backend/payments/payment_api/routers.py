from rest_framework.routers import DefaultRouter
from .views import PaymentsViewSet,  ClientsViewSet, SendPostRequestViewSet

router = DefaultRouter()
router.register('v1/payment', PaymentsViewSet)
router.register('v1/checkout/<uuid:pk>', PaymentsViewSet)
router.register('v1/registration', ClientsViewSet)
router.register('v1/mb-way', SendPostRequestViewSet, basename='mb-way')