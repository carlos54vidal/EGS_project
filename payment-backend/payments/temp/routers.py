from rest_framework.routers import DefaultRouter
from .views import PaymentsViewSet
from .views import ClientsViewSet

router = DefaultRouter()
router.register('payment', PaymentsViewSet)
router.register('payment/<uuid:pid>', PaymentsViewSet)
router.register('registration', ClientsViewSet)