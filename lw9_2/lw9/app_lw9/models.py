from django.db import models

# Create your models here.

class Client(models.Model):
    FirstName = models.CharField(max_length=50)
    SecondName = models.CharField(max_length=50)
    CleintId = models.IntegerField(primary_key=True)
    phoneNumber = models.CharField(max_length=15)
    Email = models.EmailField()
    class Meta:
        app_label = 'app_lw9'    

class Inventory(models.Model):
    InventoryId = models.IntegerField(primary_key=True)
    name = models.CharField(max_length=50)
    quantityAvaliable = models.IntegerField()
    class Meta:
        app_label = 'app_lw9'  

class Employee(models.Model):
    Salary = models.IntegerField()
    JobPosition = models.CharField(max_length=50)
    SecondName = models.CharField(max_length=50)
    FirstName = models.CharField(max_length=50)
    EmployeeId = models.IntegerField(primary_key=True)
    class Meta:
        app_label = 'app_lw9'  

class Rental(models.Model):
    RentalId = models.IntegerField(primary_key=True)
    RentalDate = models.DateField()
    RentalDaysTime = models.DurationField()
    IsReturned = models.BooleanField()
    Client = models.ForeignKey(Client, on_delete=models.CASCADE)
    Inventory = models.ForeignKey(Inventory, on_delete=models.CASCADE)
    class Meta:
        app_label = 'app_lw9'  
    
class Sale(models.Model):
    SaleId = models.IntegerField(primary_key=True)
    SaleDate = models.DateField()
    SaleAmount = models.FloatField()
    IsPaid = models.BooleanField()
    Employee = models.ForeignKey(Employee, on_delete=models.CASCADE)
    Rental = models.ForeignKey(Rental, on_delete=models.CASCADE)
    class Meta:
        app_label = 'app_lw9'  