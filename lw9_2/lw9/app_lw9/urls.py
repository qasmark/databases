from django.urls import path
from . import views
urlpatterns = [
    path('clients/', views.ClientList.as_view()),
    path('clients/<int:pk>/', views.ClientDetail.as_view()),
    path('inventories/', views.InventoryList.as_view()),
    path('inventories/<int:pk>/', views.InventoryDetail.as_view()),
    path('employees/', views.EmployeeList.as_view()),
    path('employees/<int:pk>/', views.EmployeeDetail.as_view()),
    path('rentals/', views.RentalList.as_view()),
    path('rentals/<int:pk>/', views.RentalDetail.as_view()),
    path('sales/', views.SaleList.as_view()),
    path('sales/<int:pk>/', views.SaleDetail.as_view()),
]