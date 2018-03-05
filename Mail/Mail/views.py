from django.shortcuts import render_to_response
from django.views.generic.base import View
import json

class ContentView(View):
    def post(self, request, *args, **kwargs):


        data=json.loads(request.body)
        print data

        return render_to_response('mail.html',data)

