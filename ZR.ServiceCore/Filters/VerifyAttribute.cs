// This namespace is temporarily not changed, as the changes would be significant on September 2, 2023.
using Infrastructure.Model;
using Infrastructure;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc.Controllers;
using Microsoft.AspNetCore.Mvc.Filters;
using Microsoft.AspNetCore.Mvc;
using ZR.Common;

namespace ZR.Admin.WebApi.Filters
{
    /// <summary>
    /// Authorization verification
    /// If authorization login is skipped, add the AllowAnonymousAttribute to the Action or controller
    /// </summary>
    [AttributeUsage(AttributeTargets.All)]
    public class VerifyAttribute : Attribute, IAuthorizationFilter
    {
        private NLog.Logger logger = NLog.LogManager.GetCurrentClassLogger();
        /// <summary>
        /// Only check if the token is correct, do not check permissions
        /// If permission checking is required, add the ApiActionPermission attribute to the Action to indicate the permission category, and use the ActionPermissionFilter for permission handling
        /// </summary>
        /// <param name="context"></param>
        public void OnAuthorization(AuthorizationFilterContext context)
        {
            var noNeedCheck = false;
            if (context.ActionDescriptor is ControllerActionDescriptor controllerActionDescriptor)
            {
                noNeedCheck = controllerActionDescriptor.MethodInfo.GetCustomAttributes(inherit: true)
                  .Any(a => a.GetType().Equals(typeof(AllowAnonymousAttribute)));
            }

            if (noNeedCheck) return;

            string ip = HttpContextExtension.GetClientUserIp(context.HttpContext);
            string url = context.HttpContext.Request.Path;
            var isAuthed = context.HttpContext.User.Identity.IsAuthenticated;
            string osType = context.HttpContext.Request.Headers["os"];
            // Use JWT token for verification on November 21, 2020
            TokenModel loginUser = JwtUtil.GetLoginUser(context.HttpContext);
            if (loginUser != null)
            {
                var nowTime = DateTime.UtcNow;
                TimeSpan ts = loginUser.ExpireTime - nowTime;

                //Console.WriteLine($"jwt remaining expiration time: {ts.TotalMinutes} minutes, {ts.TotalSeconds} seconds");

                var CK = "token_" + loginUser.UserId;
                if (!CacheHelper.Exists(CK) && ts.TotalMinutes < 5)
                {
                    var newToken = JwtUtil.GenerateJwtToken(JwtUtil.AddClaims(loginUser));

                    CacheHelper.SetCache(CK, CK, 1);
                    // The following is required to get the custom header on mobile devices
                    if (osType != null)
                    {
                        context.HttpContext.Response.Headers.Add("Access-Control-Expose-Headers", "X-Refresh-Token");
                    }
                    logger.Info($"Refresh token, userName={loginUser.UserName}, token={newToken}");
                    context.HttpContext.Response.Headers.Add("X-Refresh-Token", newToken);
                }
            }
            if (loginUser == null || !isAuthed)
            {
                string msg = $"Failed to access [{url}], unable to access system resources";
                //logger.Info(msg);
                context.Result = new JsonResult(ApiResult.Error(ResultCode.DENY, msg));
            }
        }
    }
}

