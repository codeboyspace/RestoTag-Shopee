from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework import status
from .models import Product, Cart
from .serializers import ProductSerializer, CartSerializer

# Get all products
@api_view(['GET'])
def get_products(request):
    products = Product.objects.all()
    serializer = ProductSerializer(products, many=True)
    return Response(serializer.data)

# Add a new product
@api_view(['POST'])
def add_product(request):
    serializer = ProductSerializer(data=request.data)
    if serializer.is_valid():
        serializer.save()
        return Response({'message': 'Product added', 'product_id': serializer.data['id']}, status=status.HTTP_201_CREATED)
    return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

# Add a product to the cart
@api_view(['POST'])
def add_to_cart(request):
    firebase_user_id = request.data.get('firebase_user_id')
    product_id = request.data.get('product_id')

    try:
        product = Product.objects.get(id=product_id)
        cart_item, created = Cart.objects.get_or_create(firebase_user_id=firebase_user_id, product=product)
        if created:
            return Response({'message': 'Product added to cart'}, status=status.HTTP_201_CREATED)
        return Response({'message': 'Product already in cart'}, status=status.HTTP_200_OK)
    except Product.DoesNotExist:
        return Response({'error': 'Product not found'}, status=status.HTTP_404_NOT_FOUND)

# Remove a product from the cart
@api_view(['DELETE'])
def remove_from_cart(request):
    firebase_user_id = request.data.get('firebase_user_id')
    product_id = request.data.get('product_id')

    try:
        cart_item = Cart.objects.get(firebase_user_id=firebase_user_id, product_id=product_id)
        cart_item.delete()
        return Response({'message': 'Product removed from cart'}, status=status.HTTP_200_OK)
    except Cart.DoesNotExist:
        return Response({'error': 'Product not found in cart'}, status=status.HTTP_404_NOT_FOUND)

@api_view(['GET'])
def get_cart_items(request, firebase_user_id):
    cart_items = Cart.objects.filter(firebase_user_id=firebase_user_id)
    
    # Retrieve product details for each cart item
    cart_data = []
    for item in cart_items:
        product = Product.objects.get(id=item.product.id)
        cart_data.append({
            "id": item.id,
            "firebase_user_id": item.firebase_user_id,
            "added_at": item.added_at,
            "product_id": item.product.id,
            "product_name": product.name,
            "product_price": product.price
        })
    
    return Response(cart_data, status=status.HTTP_200_OK)
