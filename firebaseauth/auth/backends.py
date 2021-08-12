from django.contrib.auth.models import User
from rest_framework import authentication
from rest_framework import exceptions

from firebase_admin import auth,initialize_app

initialize_app()

class FirebaseBackend(authentication.BaseAuthentication):
    def authenticate(self, request):
        authorization_header = request.META.get("HTTP_AUTHORIZATION")
        if not authorization_header:
            raise exceptions.AuthenticationFailed('Authorization credentials not provided')
        id_token = authorization_header.split(" ").pop()
        if not id_token:
            raise exceptions.AuthenticationFailed('Authorization credentials not provided')
        decoded_token = None
        try:
            decoded_token = auth.verify_id_token(id_token)
        except Exception:
            raise exceptions.AuthenticationFailed('Invalid ID Token')

        try:
            uid = decoded_token.get("uid")
        except Exception:
            raise exceptions.AuthenticationFailed('No such user exists')
        
        user, created = User.objects.get_or_create(username=uid)
        if((not user.first_name or not hasattr(user,'userprofile')) and not (request.method == 'PUT' and request.path.startswith("/api/users/"))):
            raise exceptions.PermissionDenied('User profile is incomplete. Please update the Profile Details')
        #user.profile.last_activity = timezone.localtime()

        return (user, None)

            