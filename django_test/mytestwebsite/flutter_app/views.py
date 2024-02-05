from rest_framework.views import APIView
from rest_framework.response import Response
from django.http import JsonResponse  # Importez JsonResponse
from rest_framework.generics import UpdateAPIView
from flutter_app.models import Product
from flutter_app.serializers import ProductSerializer
from rest_framework import status
from rest_framework.renderers import JSONRenderer
from rest_framework.generics import CreateAPIView
from django.contrib.auth import authenticate, login, logout
from django.http import JsonResponse
from django.contrib.auth.forms import UserCreationForm
from django.views.decorators.csrf import csrf_exempt
from django.middleware.csrf import get_token
from django.contrib.auth import authenticate, login
from flutter_app.decorators import notLoggedUsers
from rest_framework.decorators import permission_classes
from rest_framework.permissions import AllowAny
from django.views.decorators.csrf import csrf_protect

class ProductListAPIView(APIView):
    def get(self, request):
        # Récupérer la liste des produits depuis la base de données
        products = Product.objects.all()  # Supposons que Product est votre modèle de données

        # Serializer les données des produits
        serializer = ProductSerializer(products, many=True)

        # Renvoyer les données sérialisées au format JSON en utilisant JsonResponse
        return JsonResponse(serializer.data, safe=False)
class ProductUpdateAPIView(UpdateAPIView):
    queryset = Product.objects.all()
    serializer_class = ProductSerializer

    def get_object(self):
        pk = self.kwargs.get('pk')
        return Product.objects.get(pk=pk)

    def put(self, request, *args, **kwargs):
        try:
            product_instance = self.get_object()
            serializer = self.get_serializer(product_instance, data=request.data)
            serializer.is_valid(raise_exception=True)
            serializer.save()

            # Récupération des données sérialisées et retour en tant que JSONResponse
            serialized_data = serializer.data
            return JsonResponse(serialized_data, status=status.HTTP_200_OK)
        except Exception as e:
            return JsonResponse({"error": str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
        

class ProductCreateAPIView(CreateAPIView):
    queryset = Product.objects.all()
    serializer_class = ProductSerializer

    def create(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        serializer.save()

        # Retourner une réponse JSON avec les données créées et le code HTTP 201 Created
        return JsonResponse(serializer.data, status=status.HTTP_201_CREATED)
class ProductDeleteAPIView(APIView):
    def delete(self, request, pk):
        try:
            instance = Product.objects.get(pk=pk)
        except Product.DoesNotExist:
            return JsonResponse({"error": "L'objet spécifié n'existe pas"}, status=status.HTTP_404_NOT_FOUND)

        instance.delete()
        return JsonResponse({"message": "L'objet a été supprimé avec succès"}, status=status.HTTP_204_NO_CONTENT)

@csrf_exempt
@permission_classes([AllowAny])
def login_view(request):
    if request.user.is_authenticated:
        return JsonResponse({'message': 'User is already logged in'},status=209)
    if (('username' not in request.POST or 'password' not in request.POST) and user):
        return JsonResponse({'message': 'Missing username or password'}, status=200)
    if request.method == 'POST':
        username = request.POST.get('username')
        password = request.POST.get('password')
        
        # Authentifier l'utilisateur
        user = authenticate(request, username=username, password=password)
        
        if user:
            login(request, user)
            return JsonResponse({'message': 'Login successful'})
        else:
            return JsonResponse({'message': 'Login failed'}, status=401)

def logout_view(request):
    logout(request)
    return JsonResponse({'message': 'Logout successful'})
@csrf_exempt 
def register_view(request):
    if request.method == 'POST':
        print(f'Received data: {request.POST}')
        form = UserCreationForm(request.POST)
        if form.is_valid():
            user = form.save()
            login(request, user)
            return JsonResponse({'message': 'Registration successful'})
        else:
            print(f'Form errors: {form.errors}')
            return JsonResponse({'errors': form.errors}, status=400)
def get_csrf_token(request):
    token = get_token(request)
    return JsonResponse({'csrf_token': token})
