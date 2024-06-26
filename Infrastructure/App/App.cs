using Infrastructure.Model;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Options;
using System;
using System.Security.Claims;

namespace Infrastructure
{
    public static class App
    {
        /// <summary>
        /// Global configuration file
        /// </summary>
        public static OptionsSetting OptionsSetting => CatchOrDefault(() => ServiceProvider?.GetService<IOptions<OptionsSetting>>()?.Value);

        /// <summary>
        /// Service provider
        /// </summary>
        public static IServiceProvider ServiceProvider => InternalApp.ServiceProvider;
        /// <summary>
        /// Get the request context
        /// </summary>
        public static HttpContext HttpContext => CatchOrDefault(() => ServiceProvider?.GetService<IHttpContextAccessor>()?.HttpContext);
        /// <summary>
        /// Get the user from the request context
        /// </summary>
        public static ClaimsPrincipal User => HttpContext?.User;
        /// <summary>
        /// Get the username
        /// </summary>
        public static string UserName => User?.Identity?.Name;
        /// <summary>
        /// Get the web host environment
        /// </summary>
        public static IWebHostEnvironment WebHostEnvironment => InternalApp.WebHostEnvironment;
        /// <summary>
        /// Get the global configuration
        /// </summary>
        public static IConfiguration Configuration => CatchOrDefault(() => InternalApp.Configuration, new ConfigurationBuilder().Build());
        /// <summary>
        /// Get a service from the request scope
        /// </summary>
        /// <typeparam name="TService"></typeparam>
        /// <returns></returns>
        public static TService GetService<TService>()
            where TService : class
        {
            return GetService(typeof(TService)) as TService;
        }

        /// <summary>
        /// Get a service from the request scope
        /// </summary>
        /// <param name="type"></param>
        /// <returns></returns>
        public static object GetService(Type type)
        {
            return ServiceProvider.GetService(type);
        }

        /// <summary>
        /// Get a required service from the request scope
        /// </summary>
        /// <typeparam name="TService"></typeparam>
        /// <returns></returns>
        public static TService GetRequiredService<TService>()
            where TService : class
        {
            return GetRequiredService(typeof(TService)) as TService;
        }

        /// <summary>
        /// Get a required service from the request scope
        /// </summary>
        /// <param name="type"></param>
        /// <returns></returns>
        public static object GetRequiredService(Type type)
        {
            return ServiceProvider.GetRequiredService(type);
        }

        /// <summary>
        /// Handle exceptions when getting objects
        /// </summary>
        /// <typeparam name="T">Type</typeparam>
        /// <param name="action">Delegate to get the object</param>
        /// <param name="defaultValue">Default value</param>
        /// <returns>T</returns>
        private static T CatchOrDefault<T>(Func<T> action, T defaultValue = null)
            where T : class
        {
            try
            {
                return action();
            }
            catch
            {
                return defaultValue ?? null;
            }
        }
    }
}
