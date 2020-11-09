using System.Collections.Generic;
using System.Linq;
using glovo_webapi.Data;
using glovo_webapi.Entities;

namespace  glovo_webapi.Services.Products
{
    public class NpgsqlProductsService : IProductsService
    {
        private readonly GlovoDbContext _context;

        public NpgsqlProductsService(GlovoDbContext context)
        {
            _context = context;
        }
        
        public IEnumerable<Product> GetAllProducts()
        {
            return _context.Products.ToList();
        }

        public Product GetProductById(int id)
        {
            return _context.Products.FirstOrDefault(p => p.Id == id);
        }

        public IEnumerable<Product> GetAllProductsOfRestaurant(int idRest)
        {
            return _context.Products.Where(p => p.RestaurantId == idRest).ToList();
        }

        public Product GetProductOfRestaurantById(int idRest, int idProd)
        {
            return _context.Products.Where(p => p.RestaurantId == idRest).FirstOrDefault(p => p.Id == idProd);
        }
    }
}