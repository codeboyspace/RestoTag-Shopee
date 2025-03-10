from rest_framework import serializers
from .models import SellerInvite

class SellerInviteSerializer(serializers.ModelSerializer):
    class Meta:
        model = SellerInvite
        fields = ['email']
