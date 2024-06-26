using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.OpenApi.Models;
using Swashbuckle.AspNetCore.Filters;
using Swashbuckle.AspNetCore.SwaggerUI;
using System.Reflection;

namespace ZR.Admin.WebApi.Extensions
{
    public static class SwaggerExtension
    {
        /// <summary>
        /// 
        /// </summary>
        /// <param name="app"></param>
        public static void UseSwagger(this IApplicationBuilder app)
        {
            app.UseSwagger(c =>
            {
                // Configure the route template for the Swagger JSON endpoint
                c.RouteTemplate = "swagger/{documentName}/swagger.json";

                // Add a pre-serialize filter to modify the Swagger document before it is serialized
                c.PreSerializeFilters.Add((swaggerDoc, httpReq) =>
                {
                    // Get the base URL of the application
                    var url = $"{httpReq.Scheme}://{httpReq.Host.Value}";

                    // Get the Referer header from the HTTP request
                    var referer = httpReq.Headers["Referer"].ToString();

                    // Check if the Referer contains a specific string
                    if (referer.Contains(GlobalConstant.DevApiProxy))
                    {
                        // Extract the URL from the Referer, excluding the specific string
                        url = referer[..(referer.IndexOf(GlobalConstant.DevApiProxy, StringComparison.InvariantCulture) + GlobalConstant.DevApiProxy.Length - 1)];
                    }

                    // Set the server URL in the Swagger document
                    swaggerDoc.Servers = new List<OpenApiServer>
                    {
                        new OpenApiServer
                        {
                            Url = url
                        }
                    };
                });
            });

            app.UseSwaggerUI(c =>
            {
                // Configure the Swagger UI to display multiple API endpoints
                c.SwaggerEndpoint("sys/swagger.json", "System Management");
                c.SwaggerEndpoint("article/swagger.json", "Article Management");
                c.SwaggerEndpoint("v1/swagger.json", "business");
                c.DocExpansion(DocExpansion.None); // Modify the UI to collapse the documentation by default
            });
        }

        public static void AddSwaggerConfig(this IServiceCollection services)
        {
            if (services == null) throw new ArgumentNullException(nameof(services));
            //IWebHostEnvironment hostEnvironment = services.BuildServiceProvider().GetRequiredService<IWebHostEnvironment>();

            services.AddSwaggerGen(c =>
            {
                c.SwaggerDoc("sys", new OpenApiInfo
                {
                    Title = "ZrAdmin.NET Api",
                    Version = "v1",
                    Description = "System Management",
                    Contact = new OpenApiContact { Name = "ZRAdmin doc", Url = new Uri("https://www.izhaorui.cn/doc") }
                });
                c.SwaggerDoc("article", new OpenApiInfo
                {
                    Title = "ZrAdmin.NET Api",
                    Version = "v1",
                    Description = "Article Management",
                    Contact = new OpenApiContact { Name = "ZRAdmin doc", Url = new Uri("https://www.izhaorui.cn/doc") }
                });
                c.SwaggerDoc("v1", new OpenApiInfo
                {
                    Title = "ZrAdmin.NET Api",
                    Version = "v1",
                    Description = "",
                });
                try
                {
                    //var tempPath = hostEnvironment.ContentRootPath;
                    // Add XML comments to the Swagger documentation
                    var baseDir = AppContext.BaseDirectory;
                    c.IncludeXmlComments(Path.Combine(baseDir, "ZR.Model.xml"), true);
                    c.IncludeXmlComments(Path.Combine(baseDir, "ZR.ServiceCore.xml"), true);
                    c.IncludeXmlComments(Path.Combine(baseDir, "ZR.Service.xml"), true);
                    c.IncludeXmlComments(Path.Combine(baseDir, "ZR.Admin.WebApi.xml"), true);

                    var xmlFile = $"{Assembly.GetExecutingAssembly().GetName().Name}.xml";
                    var xmlPath = Path.Combine(baseDir, xmlFile);
                    c.IncludeXmlComments(xmlPath);
                }
                catch (Exception ex)
                {
                    Console.WriteLine("Failed to load Swagger documentation: " + ex.Message);
                }

                // Reference articles: http://www.zyiz.net/tech/detail-134965.html
                // Requires the package Swashbuckle.AspNetCore.Filters
                // Enable the lock icon for authorization, requires [Authorize] attribute on corresponding actions
                c.OperationFilter<AddResponseHeadersFilter>();
                c.OperationFilter<AppendAuthorizeToSummaryOperationFilter>();

                // Add token to the header and pass it to the backend
                c.OperationFilter<SecurityRequirementsOperationFilter>();

                c.AddSecurityDefinition(JwtBearerDefaults.AuthenticationScheme,
                    new OpenApiSecurityScheme
                    {
                        In = ParameterLocation.Header,
                        Description = "Please enter the Token returned by the Login interface, prefixed with Bearer. Example: Bearer {Token}",
                        Name = "Authorization", // Default parameter name for JWT
                        Type = SecuritySchemeType.ApiKey, // Specify ApiKey
                        BearerFormat = "JWT", // Indicates the format of the bearer token, mainly for documentation purposes
                        Scheme = JwtBearerDefaults.AuthenticationScheme // Name of the HTTP authentication scheme to be used in authorization
                    });
                c.AddSecurityRequirement(new OpenApiSecurityRequirement
                {
                    {
                        new OpenApiSecurityScheme
                        {
                            Reference = new OpenApiReference { Type = ReferenceType.SecurityScheme, Id = "Bearer" }
                        },
                        new List<string>()
                    }
                });

                try
                {
                    // Determine which group the API belongs to
                    c.DocInclusionPredicate((docName, apiDescription) =>
                    {
                        if (docName == "v1")
                        {
                            // When the group is NoGroup, any API without attributes belongs to this group
                            return string.IsNullOrEmpty(apiDescription.GroupName);
                        }
                        else
                        {
                            return apiDescription.GroupName == docName;
                        }
                    });
                }
                catch (Exception e)
                {
                    Console.WriteLine(e);
                    throw;
                }

            });
        }
    }
}
