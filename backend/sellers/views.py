from django.core.mail import send_mail
from django.conf import settings
from django.shortcuts import get_object_or_404
from rest_framework import status
from rest_framework.response import Response
from rest_framework.decorators import api_view
from .models import SellerInvite
from .serializers import SellerInviteSerializer

@api_view(['POST'])
def send_invite(request):
    serializer = SellerInviteSerializer(data=request.data)
    if serializer.is_valid():
        email = serializer.validated_data['email']
        
        # Check if invite already exists
        invite, created = SellerInvite.objects.get_or_create(email=email)

        # Generate invite link
        invite_link = f"{settings.FRONTEND_URL}/register-seller/{invite.token}"

        # Send email
        send_mail(
            "Seller Registration Invitation",
            f"You're invited to register as a seller. Click the link: {invite_link}",
            settings.DEFAULT_FROM_EMAIL,
            [email],
            fail_silently=False,
        )

        return Response({"message": "Invitation sent successfully!"}, status=status.HTTP_201_CREATED)
    
    return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
