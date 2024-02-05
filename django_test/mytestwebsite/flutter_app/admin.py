from django.contrib import admin
from flutter_app.models import CustomUser, Product
# Register your models here.



admin.site.register(Product)
admin.site.register(CustomUser)