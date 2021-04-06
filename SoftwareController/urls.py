from . import views
from django.urls import path

urlpatterns = [
    path('scan_code/', views.scan_code)
]
