import os

from json import loads
from rest_framework import status
from rest_framework.response import Response
from rest_framework.decorators import api_view

from . import SoftwareBL


@api_view(['POST'])
def scan_code(request):
    if request.method == 'POST':
        # TODO: it m.b. serializer
        if request.data.__contains__('_content'):
            if request.data.get('_content'):
                data = loads(request.data.get('_content'))
            else:
                data = {}
        else:
            data = request.data

        qr = data.get('code')
        token = data.get('token')

        # TODO: it m.b realized in past serializer
        if qr and token:
            if token == os.environ['AUTH_TOKEN']:
                SoftwareBL.scan_code(qr)
                return Response({
                    "status": status.HTTP_200_OK,
                    "data": data,
                    "error": ""
                })
            else:
                return Response({
                    "status": status.HTTP_401_UNAUTHORIZED,
                    "data": data,
                    "error": "Invalid auth token"
                })
        else:
            return Response({
                    "status": status.HTTP_400_BAD_REQUEST,
                    "data": data,
                    # TODO: at serialize need take view like
                    #  {
                    #     "errors": [{
                    #                   "name": error_name,
                    #                  "field": field_data,
                    #                   ...
                    #                   }]
                    #  }
                    "error": "Empty fields"
            })
