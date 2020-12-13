using System.Collections.Generic;
using glovo_webapi.Entities;
using glovo_webapi.Utils;

namespace glovo_webapi.Services.Products
{
    public interface IProductsService
    {
        IEnumerable<Product> GetAllProducts();
        Product GetProductById(int id);
        IEnumerable<Product> GetAllProductsOfRestaurant(int idRest);
        List<ProductGroup> GetProductsGroupOfRestaurant(int idRest);
    }
}