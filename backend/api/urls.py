from django.urls import path
from .views import get_products, add_product, add_to_cart, remove_from_cart, get_cart_items

urlpatterns = [
    path('products/', get_products, name='get_products'),
    path('products/add/', add_product, name='add_product'),
    path('cart/add/', add_to_cart, name='add_to_cart'),
    path('cart/remove/', remove_from_cart, name='remove_from_cart'),
    path('cart/<str:firebase_user_id>/', get_cart_items, name='get_cart_items'),  # New endpoint
]
