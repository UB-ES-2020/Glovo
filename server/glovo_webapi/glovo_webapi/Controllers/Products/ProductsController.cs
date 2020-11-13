using System;
using System.Collections.Generic;
using AutoMapper;
using glovo_webapi.Entities;
using glovo_webapi.Models.Product;
using glovo_webapi.Services.Products;
using Microsoft.AspNetCore.Mvc;

namespace glovo_webapi.Controllers
{
    [ApiController]
    [Route("api/products")]
    public class ProductsController : ControllerBase
    {
        private readonly IProductsService _service;
        private readonly IMapper _mapper;
        
        public ProductsController(IProductsService service, IMapper mapper)
        {
            _service = service;
            _mapper = mapper;
        }
        
        //GET api/products
        [HttpGet]
        public ActionResult<IEnumerable<ProductReadModel>> GetAllProducts()
        {
            IEnumerable<Product> products = _service.GetAllProducts();
            return Ok(_mapper.Map<IEnumerable<ProductReadModel>>(products));
        }
        
        //GET api/products/<prodId>
        [HttpGet("{prodId}")]
        public ActionResult<ProductReadModel> GetProductById(int prodId)
        {
            Product foundProduct = _service.GetProductById(prodId);
            if (foundProduct == null)
            {
                return NotFound(new {message = "product id not found"});
            }
            return Ok(_mapper.Map<ProductReadModel>(foundProduct));
        }
    }
}