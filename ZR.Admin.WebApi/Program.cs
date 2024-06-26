using AspNetCoreRateLimit;
using Infrastructure.Converter;
using Microsoft.AspNetCore.DataProtection;
using NLog.Web;
using SqlSugar;
using System.Text.Json;
using ZR.Admin.WebApi.Extensions;
using ZR.Common.Cache;
using ZR.Common.DynamicApiSimple.Extens;
using ZR.Infrastructure.WebExtensions;
using ZR.ServiceCore.Signalr;
using ZR.ServiceCore.SqlSugar;

var builder = WebApplication.CreateBuilder(args);
// NLog: Setup NLog for Dependency injection
//builder.Logging.ClearProviders();
builder.Host.UseNLog();

builder.Services.AddDynamicApi();
// Add services to the container.
builder.Services.AddControllers();

// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();
// Inject HttpContextAccessor
builder.Services.AddSingleton<IHttpContextAccessor, HttpContextAccessor>();
// Configure CORS
builder.Services.AddCors(builder.Configuration);
// Eliminate "Error unprotecting the session cookie" warning
builder.Services.AddDataProtection()
    .PersistKeysToFileSystem(new DirectoryInfo(Directory.GetCurrentDirectory() + Path.DirectorySeparatorChar + "DataProtection"));
// Add captcha functionality
builder.Services.AddCaptcha(builder.Configuration);
// Add IP rate limiting functionality
builder.Services.AddIPRate(builder.Configuration);
//builder.Services.AddSession();
builder.Services.AddHttpContextAccessor();
// Bind the OptionsSetting object to the configuration settings
builder.Services.Configure<OptionsSetting>(builder.Configuration);
builder.Configuration.AddJsonFile("codeGen.json");
builder.Configuration.AddJsonFile("iprate.json");
// Add JWT authentication services
builder.Services.AddJwt();
// Register the AppSettings object as a singleton service
builder.Services.AddSingleton(new AppSettings(builder.Configuration));
// Register app services
builder.Services.AddAppService();
// Add task scheduling services
builder.Services.AddTaskSchedulers();
// Add request size limiting functionality
builder.Services.AddRequestLimit(builder.Configuration);

// Register REDIS service
var openRedis = builder.Configuration["RedisServer:open"];
if (openRedis == "1")
{
    RedisServer.Initalize();
}

builder.Services.AddMvc(options =>
{
    options.Filters.Add(typeof(GlobalActionMonitor));// Global registration
})
.AddJsonOptions(options =>
{
    //options.JsonSerializerOptions.NumberHandling = JsonNumberHandling.AllowReadingFromString | JsonNumberHandling.WriteAsString;
    options.JsonSerializerOptions.WriteIndented = true;
    options.JsonSerializerOptions.Converters.Add(new JsonConverterUtil.DateTimeConverter());
    options.JsonSerializerOptions.Converters.Add(new JsonConverterUtil.DateTimeNullConverter());
    options.JsonSerializerOptions.Converters.Add(new StringConverter());
    //PropertyNamingPolicy is used for the format strategy of the properties passed from the front-end. Currently, there is only one built-in strategy, CamelCase.
    options.JsonSerializerOptions.PropertyNamingPolicy = JsonNamingPolicy.CamelCase;
    //options.JsonSerializerOptions.PropertyNameCaseInsensitive = true;// Properties can ignore case format, enabling this will reduce performance
});
// Inject SignalR for real-time communication, using JSON as the default transport
builder.Services.AddSignalR()
.AddJsonProtocol(options =>
{
    options.PayloadSerializerOptions.PropertyNamingPolicy = JsonNamingPolicy.CamelCase;
});
builder.Services.AddSwaggerConfig();
// Show logo
builder.Services.AddLogo();

var app = builder.Build();
InternalApp.ServiceProvider = app.Services;
InternalApp.Configuration = builder.Configuration;
InternalApp.WebHostEnvironment = app.Environment;
// Initialize db
builder.Services.AddDb(app.Environment);
var workId = builder.Configuration["workId"].ParseToInt();
if (app.Environment.IsDevelopment())
{
    workId += 1;
}
SnowFlakeSingle.WorkId = workId;
// Use global exception middle ware
app.UseMiddleware<GlobalExceptionMiddleware>();

// Forward headers
// The ForwardedHeaders middle-ware automatically populates HttpContext.Connection.RemoteIPAddress and HttpContext.Request.Scheme with the X-Forwarded-For (client's real IP) and X-Forwarded-Proto (client's requested protocol) forwarded by the reverse proxy server, so that the application code can read the real IP and protocol without special handling.
app.UseForwardedHeaders(new ForwardedHeadersOptions
{
    ForwardedHeaders = Microsoft.AspNetCore.HttpOverrides.ForwardedHeaders.XForwardedFor | Microsoft.AspNetCore.HttpOverrides.ForwardedHeaders.XForwardedProto
});

app.Use((context, next) =>
{
    // Enable multiple reads of the request body content
    context.Request.EnableBuffering();
    if (context.Request.Query.TryGetValue("access_token", out var token))
    {
        context.Request.Headers.Append("Authorization", $"Bearer {token}");
    }
    return next();
});
// Enable access to static files in the /wwwroot directory, should be placed before UseRouting
app.UseStaticFiles();
// Enable routing
app.UseRouting();
app.UseCors("Policy"); // Should be placed before app.UseEndpoints.
//app.UseHttpsRedirection();

app.UseAuthentication();
app.UseAuthorization();

// Enable response caching
app.UseResponseCaching();
if (builder.Environment.IsProduction())
{
    // Restore/start tasks
    app.UseAddTaskSchedulers();
}
// Initialize dictionary data
app.UseInit();

// Use Swagger
app.UseSwagger();
// Enable client IP rate limiting
app.UseIpRateLimiting();
app.UseRateLimiter();
// Set up socket connection
app.MapHub<MessageHub>("/msgHub");

app.MapControllerRoute(
    name: "default",
    pattern: "{controller=Home}/{action=Index}/{id?}");

app.MapControllers();
app.Run();