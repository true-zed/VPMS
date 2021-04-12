from django.urls import path, include

urlpatterns = [
    path('software/', include('SoftwareController.urls'))
]
