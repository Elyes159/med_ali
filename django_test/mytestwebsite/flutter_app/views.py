from rest_framework.views import APIView
from rest_framework.response import Response
from django.http import JsonResponse  # Importez JsonResponse
from rest_framework.generics import UpdateAPIView
from flutter_app.models import Product
from flutter_app.serializers import ProductSerializer
from rest_framework import status
from rest_framework.renderers import JSONRenderer
from rest_framework.generics import CreateAPIView

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