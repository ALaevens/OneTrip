# https://stackoverflow.com/a/41728627/13538080

from django.http import request

class ExemptCSRFMiddleware:
    def __init__(self, get_response):
        self.get_response = get_response

    def __call__(self, request):
        
        if request.path_info == "/auth/token":
            setattr(request, '_dont_enforce_csrf_checks', True)

        response = self.get_response(request)
        return response
