from rest_framework.routers import DefaultRouter
from.views import PaymentsViewSet

router = DefaultRouter()
router.register('payments', PaymentsViewSet)