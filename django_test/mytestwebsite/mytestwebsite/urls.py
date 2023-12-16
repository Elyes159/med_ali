"""mytestwebsite URL Configuration

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/3.2/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""
from django.contrib import admin
from django.urls import path
from flutter_app.views import ProductCreateAPIView, ProductDeleteAPIView, ProductListAPIView, ProductUpdateAPIView

urlpatterns = [
    path('admin/', admin.site.urls),
    path('products/', ProductListAPIView.as_view(), name='product-list'),
    path('update/<int:pk>/', ProductUpdateAPIView.as_view(), name='product-update'),
    path('create/', ProductCreateAPIView.as_view(), name='product-create'),
    path('delete/<int:pk>/', ProductDeleteAPIView.as_view(), name='product-delete'),
]
