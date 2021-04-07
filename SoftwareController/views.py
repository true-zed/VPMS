from rest_framework.decorators import api_view
from rest_framework.response import Response
from json import loads
from . import SoftwareBL

# TODO: Need rewrite this part to REST and add auth token (save it in env)
@api_view(['POST'])
def scan_code(request):
    if request.method == 'POST':
        qr = request.data.get('code')
        SoftwareBL.scan_code(qr)
        return Response({"status": 1, "message": "ok", "code": qr})
