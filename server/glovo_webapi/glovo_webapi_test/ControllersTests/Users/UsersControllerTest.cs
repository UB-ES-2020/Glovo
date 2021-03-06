using System.Collections.Generic;
using System.Linq;
using AutoMapper;
using glovo_webapi.Controllers.Users;
using glovo_webapi.Data;
using glovo_webapi.Entities;
using glovo_webapi.Models.Users;
using glovo_webapi.Profiles;
using glovo_webapi.Services.UserService;
using glovo_webapi.Utils;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Xunit;

namespace glovo_webapi_test.ControllersTests.Users
{
    
    public class UsersControllerTest
    {    
        private DbContextOptions<GlovoDbContext> ContextOptions { get; }

        public UsersControllerTest()
        {
            ContextOptions = new DbContextOptionsBuilder<GlovoDbContext>()
                .UseSqlite("Filename=TestUsers.db")
                .Options;
            
            SeedDatabase();
        }

        private RestApiUsersService _usersService;
        private List<User> _users;
        
        private void SeedDatabase()
        {
            var context = new GlovoDbContext(ContextOptions);
            
            context.Database.EnsureDeleted();
            context.Database.EnsureCreated();

            _users = new List<User>()
            {
                new User("u1", "u1@komet.net", "password-u1", new Location(0, 0), UserRole.Regular) {Id = 1},
                new User("u2", "u2@komet.net", "password-u2", new Location(0, 0), UserRole.Regular) {Id = 2},
                new User("a1", "a1@komet.net", "password-a1", new Location(0, 0), UserRole.Administrator) {Id = 3}
            };
            
            context.AddRange(_users);
            context.SaveChanges();
        }
        
        private UsersController CreateFakeUsersController(User loggedUser = null)
        {
            //Create fake DBContext
            var context = new GlovoDbContext(ContextOptions);
            
            //Create fake HttpContextAccessor
            var httpContext = new DefaultHttpContext();
            var httpContextAccessor = new HttpContextAccessor {
                HttpContext = httpContext
            };

            //Add logged user to HttpContextAccessor in case it is needed
            if (loggedUser != null)
                httpContextAccessor.HttpContext.Items["User"] = loggedUser;

            //Create RestApiUsersService instance with fake DBContext and HttpContextAccessor
            _usersService = new RestApiUsersService(context, httpContextAccessor);
            
            //Create mapper with UsersProfile
            var mapper = new MapperConfiguration(cfg => {
                cfg.AddProfile<LocationsProfile>();
                cfg.AddProfile<OrdersProductsProfile>();
                cfg.AddProfile<OrdersProfile>();
                cfg.AddProfile<ProductsProfile>();
                cfg.AddProfile<RestaurantsProfile>();
                cfg.AddProfile<UsersProfile>();
            }).CreateMapper();
            
            //Create UsersController instance with the RestApiUsersService instance and the mapper
            var usersController = new UsersController(_usersService, mapper) {
                ControllerContext = {HttpContext = httpContext}
            };

            return usersController;
        }

        [Fact]
        public void GetAllUsersTest()
        {
            UsersController usersController = CreateFakeUsersController(_users[2]);
            
            //Retrieving all users
            var response = usersController.GetAll();
            Assert.IsType<OkObjectResult>(response.Result);
            Assert.Equal(_users.Count, ((IEnumerable<UserModel>)((OkObjectResult)response.Result).Value).Count());
        }
        
        [Fact]
        public void GetUserByIdTest()
        {
            UsersController usersController = CreateFakeUsersController(_users[2]);
            
            //Retrieving existing user
            var response = usersController.GetById(_users[0].Id);
            Assert.IsType<OkObjectResult>(response.Result);
            Assert.Equal(_users[0].Id, ((UserModel)((OkObjectResult)response.Result).Value).Id);
            
            //Retrieving non-existing user
            response = usersController.GetById(0);
            Assert.IsType<NotFoundObjectResult>(response.Result);
        }
        
        [Fact]
        public void UpdateUserTest()
        {
            UsersController usersController = CreateFakeUsersController(_users[0]);
            
            //Update with non-already existing email
            var response = usersController.Update(
                new UpdateUserModel("new-u1", "new-u1@komet.net")
            );
            Assert.IsType<OkObjectResult>(response.Result);
            Assert.Equal("new-u1", ((UpdateUserModel)((OkObjectResult)response.Result).Value).Name);
            Assert.Equal("new-u1@komet.net",((UpdateUserModel)((OkObjectResult)response.Result).Value).Email);
            Assert.Equal("new-u1", _users[0].Name);
            Assert.Equal("new-u1@komet.net", _users[0].Email);
            
            //Updating with already existing email
            response = usersController.Update(
                new UpdateUserModel("u2", _users[1].Email)
            );
            Assert.IsType<BadRequestObjectResult>(response.Result);
            Assert.Equal("new-u1", _users[0].Name);
            Assert.Equal("new-u1@komet.net", _users[0].Email);
        }
        
        [Fact]
        public void UpdatePasswordTest()
        {
            UsersController usersController = CreateFakeUsersController(_users[0]);
            
            //Update password with correct newPassword
            usersController.UpdatePassword(
                new PasswordUpdateModel("password-u1", "new-password-u1")
                );
            
            Assert.True(PasswordVerifier.VerifyPasswordHash(
                "new-password-u1", _users[0].PasswordHash, _users[0].PasswordSalt
                ));
            
            //Update password with incorrect newPassword
            var actionResult = usersController.UpdatePassword(
                new PasswordUpdateModel("password-u1", "renew-password-u1")
            );
            
            Assert.IsType<BadRequestObjectResult>(actionResult);
            Assert.True(PasswordVerifier.VerifyPasswordHash(
                "new-password-u1", _users[0].PasswordHash, _users[0].PasswordSalt
            ));
        }
        
        [Fact]
        public void DeleteUserTest()
        {
            UsersController usersController = CreateFakeUsersController(_users[2]);
            
            //Delete existing user, check disappeared
            var response = usersController.Delete(1);
            Assert.IsType<OkResult>(response);
            Assert.Equal(_users.Count - 1, _usersService.GetAll().ToList().Count);
            
            //Delete past existing user
            response = usersController.Delete(1);
            Assert.IsType<NotFoundObjectResult>(response);
        }
    }
}