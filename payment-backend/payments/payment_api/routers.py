from rest_framework.routers import DefaultRouter
from .views import PaymentsViewSet
from .views import ClientsViewSet

router = DefaultRouter()
router.register('v1/payment', PaymentsViewSet)
router.register('vi/checkout/<uuid:pk>', PaymentsViewSet)
router.register('v1/registration', ClientsViewSet)