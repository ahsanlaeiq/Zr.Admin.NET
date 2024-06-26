using Lazy.Captcha.Core;
using Microsoft.AspNetCore.Mvc;
using ZR.Admin.WebApi.Filters;
using ZR.Model.Models;
using ZR.Model.System;
using ZR.Model.System.Dto;
using ZR.ServiceCore.Model.Dto;

namespace ZR.Admin.WebApi.Controllers.System
{
    /// <summary>
    /// Login
    /// </summary>
    [ApiExplorerSettings(GroupName = "sys")]
    public class SysLoginController : BaseController
    {
        private readonly ISysUserService sysUserService;
        private readonly ISysMenuService sysMenuService;
        private readonly ISysLoginService sysLoginService;
        private readonly ISysPermissionService permissionService;
        private readonly ICaptcha SecurityCodeHelper;
        private readonly ISysConfigService sysConfigService;
        private readonly ISysRoleService roleService;
        private readonly ISmsCodeLogService smsCodeLogService;

        public SysLoginController(
            ISysMenuService sysMenuService,
            ISysUserService sysUserService,
            ISysLoginService sysLoginService,
            ISysPermissionService permissionService,
            ISysConfigService configService,
            ISysRoleService sysRoleService,
            ISmsCodeLogService smsCodeLogService,
            ICaptcha captcha)
        {
            SecurityCodeHelper = captcha;
            this.sysMenuService = sysMenuService;
            this.sysUserService = sysUserService;
            this.sysLoginService = sysLoginService;
            this.permissionService = permissionService;
            this.sysConfigService = configService;
            this.smsCodeLogService = smsCodeLogService;
            roleService = sysRoleService;
        }

        /// <summary>
        /// Login
        /// </summary>
        /// <param name="loginBody">Login object</param>
        /// <returns></returns>
        [Route("login")]
        [HttpPost]
        [Log(Title = "Login")]
        public IActionResult Login([FromBody] LoginBodyDto loginBody)
        {
            if (loginBody == null) { throw new CustomException("Request parameter error"); }
            loginBody.LoginIP = HttpContextExtension.GetClientUserIp(HttpContext);
            SysConfig sysConfig = sysConfigService.GetSysConfigByKey("sys.account.captchaOnOff");
            if (sysConfig?.ConfigValue != "off" && !SecurityCodeHelper.Validate(loginBody.Uuid, loginBody.Code))
            {
                return ToResponse(ResultCode.CAPTCHA_ERROR, "Incorrect captcha");
            }

            sysLoginService.CheckLockUser(loginBody.Username);
            string location = HttpContextExtension.GetIpInfo(loginBody.LoginIP);
            var user = sysLoginService.Login(loginBody, new SysLogininfor() { LoginLocation = location });

            List<SysRole> roles = roleService.SelectUserRoleListByUserId(user.UserId);
            // Permission collection eg *:*:*,system:user:list
            List<string> permissions = permissionService.GetMenuPermission(user);

            TokenModel loginUser = new(user.Adapt<TokenModel>(), roles.Adapt<List<Roles>>());
            CacheService.SetUserPerms(GlobalConstant.UserPermKEY + user.UserId, permissions);
            return SUCCESS(JwtUtil.GenerateJwtToken(JwtUtil.AddClaims(loginUser)));
        }

        /// <summary>
        /// Logout
        /// </summary>
        /// <returns></returns>
        [Log(Title = "Logout")]
        [HttpPost("logout")]
        public IActionResult LogOut()
        {
            var userid = HttpContext.GetUId();
            var name = HttpContext.GetName();

            CacheService.RemoveUserPerms(GlobalConstant.UserPermKEY + userid);
            return SUCCESS(new { name, id = userid });
        }

        /// <summary>
        /// Get user information
        /// </summary>
        /// <returns></returns>
        [Verify]
        [HttpGet("getInfo")]
        public IActionResult GetUserInfo()
        {
            long userid = HttpContext.GetUId();
            var user = sysUserService.SelectUserById(userid);

            // Button permission validation on the front end
            // Role collection eg: admin, operator, common
            List<string> roles = permissionService.GetRolePermission(user);
            // Permission collection eg *:*:*,system:user:list
            List<string> permissions = permissionService.GetMenuPermission(user);
            user.WelcomeContent = GlobalConstant.WelcomeMessages[new Random().Next(0, GlobalConstant.WelcomeMessages.Length)];
            user.Password = string.Empty;
            return SUCCESS(new { user = user.Adapt<SysUserDto>(), roles, permissions });
        }

        /// <summary>
        /// Get router information
        /// </summary>
        /// <returns></returns>
        [Verify]
        [HttpGet("getRouters")]
        public IActionResult GetRouters()
        {
            long uid = HttpContext.GetUId();
            var menus = sysMenuService.SelectMenuTreeByUserId(uid);

            return SUCCESS(sysMenuService.BuildMenus(menus));
        }

        /// <summary>
        /// Get app router information
        /// </summary>
        /// <returns></returns>
        [Verify]
        [HttpGet("getAppRouters")]
        public IActionResult GetAppRouters()
        {
            long uid = HttpContext.GetUId();
            var perms = permissionService.GetMenuPermission(new SysUser() { UserId = uid });

            return SUCCESS(sysMenuService.GetAppMenus(perms));
        }

        /// <summary>
        /// Generate captcha image
        /// </summary>
        /// <returns></returns>
        [HttpGet("captchaImage")]
        public IActionResult CaptchaImage()
        {
            string uuid = Guid.NewGuid().ToString().Replace("-", "");

            SysConfig sysConfig = sysConfigService.GetSysConfigByKey("sys.account.captchaOnOff");
            var captchaOff = sysConfig?.ConfigValue ?? "0";
            var info = SecurityCodeHelper.Generate(uuid, 60);
            var obj = new { captchaOff, uuid, img = info.Base64 };

            return SUCCESS(obj);
        }

        /// <summary>
        /// Register
        /// </summary>
        /// <param name="dto"></param>
        /// <returns></returns>
        [HttpPost("/register")]
        [AllowAnonymous]
        [Log(Title = "Register", BusinessType = BusinessType.INSERT)]
        public IActionResult Register([FromBody] RegisterDto dto)
        {
            SysConfig config = sysConfigService.GetSysConfigByKey("sys.account.register");
            if (config?.ConfigValue != "true")
            {
                return ToResponse(ResultCode.CUSTOM_ERROR, "The registration feature is not enabled in the current system!");
            }
            SysConfig sysConfig = sysConfigService.GetSysConfigByKey("sys.account.captchaOnOff");
            if (sysConfig?.ConfigValue != "off" && !SecurityCodeHelper.Validate(dto.Uuid, dto.Code))
            {
                return ToResponse(ResultCode.CAPTCHA_ERROR, "Incorrect captcha");
            }
            dto.UserIP = HttpContext.GetClientUserIp();
            SysUser user = sysUserService.Register(dto);
            if (user.UserId > 0)
            {
                return SUCCESS(user);
            }
            return ToResponse(ResultCode.CUSTOM_ERROR, "Registration failed, please contact the administrator");
        }

        #region QR Code Login

        /// <summary>
        /// Generate QR code
        /// </summary>
        /// <param name="uuid"></param>
        /// <param name="deviceId"></param>
        /// <returns></returns>
        [HttpGet("/GenerateQrcode")]
        public IActionResult GenerateQrcode(string uuid, string deviceId)
        {
            var state = Guid.NewGuid().ToString();
            var dict = new Dictionary<string, object>
    {
        { "state", state }
    };
            CacheService.SetScanLogin(uuid, dict);
            return SUCCESS(new
            {
                status = 1,
                state,
                uuid,
                codeContent = new { uuid, deviceId }// "https://qm.qq.com/cgi-bin/qm/qr?k=kgt4HsckdljU0VM-0kxND6d_igmfuPlL&authKey=r55YUbruiKQ5iwC/folG7KLCmZ++Y4rQVgNlvLbUniUMkbk24Y9+zNuOmOnjAjRc&noverify=0"
            });
        }

        /// <summary>
        /// Poll to check the scan status
        /// </summary>
        /// <param name="dto"></param>
        /// <returns></returns>
        [HttpPost("/VerifyScan")]
        [AllowAnonymous]
        public IActionResult VerifyScan([FromBody] ScanDto dto)
        {
            int status = -1;
            object token = string.Empty;
            if (CacheService.GetScanLogin(dto.Uuid) is Dictionary<string, object> str)
            {
                status = 0;
                str.TryGetValue("token", out token);
                if (str.ContainsKey("status") && (string)str.GetValueOrDefault("status") == "success")
                {
                    status = 2; // Scan successful
                    CacheService.RemoveScanLogin(dto.Uuid);
                }
            }

            return SUCCESS(new { status, token });
        }

        /// <summary>
        /// Mobile scan login
        /// </summary>
        /// <param name="dto"></param>
        /// <returns></returns>
        [HttpPost("/ScanLogin")]
        [Log(Title = "Scan Login")]
        [Verify]
        public IActionResult ScanLogin([FromBody] ScanDto dto)
        {
            if (dto == null) { return ToResponse(ResultCode.CUSTOM_ERROR, "Scan failed"); }
            var name = App.HttpContext.GetName();

            sysLoginService.CheckLockUser(name);

            TokenModel tokenModel = JwtUtil.GetLoginUser(HttpContext);
            if (CacheService.GetScanLogin(dto.Uuid) is not null)
            {
                Dictionary<string, object> dict = new() { };
                dict.Add("status", "success");
                dict.Add("token", JwtUtil.GenerateJwtToken(JwtUtil.AddClaims(tokenModel)));
                CacheService.SetScanLogin(dto.Uuid, dict);

                return SUCCESS(1);
            }
            return ToResponse(ResultCode.FAIL, "QR code has expired");
        }
        #endregion

        /// <summary>
        /// 
        /// </summary>
        /// <param name="dto"></param>
        /// <returns></returns>
        [HttpPost("/checkMobile")]
        [Log(Title = "Send SMS", BusinessType = BusinessType.INSERT)]
        public IActionResult CheckMobile([FromBody] PhoneLoginDto dto)
        {
            dto.LoginIP = HttpContextExtension.GetClientUserIp(HttpContext);
            var uid = HttpContext.GetUId();
            //SysConfig sysConfig = sysConfigService.GetSysConfigByKey("sys.account.captchaOnOff");
            //if (!SecurityCodeHelper.Validate(dto.Uuid, dto.Code, false))
            //{
            //    return ToResponse(ResultCode.CUSTOM_ERROR, "Incorrect verification code");
            //}
            if (dto.SendType == 0)
            {
                var info = sysUserService.GetFirst(f => f.Phonenumber == dto.PhoneNum) ?? throw new CustomException(ResultCode.CUSTOM_ERROR, "This phone number does not exist", false);
                uid = info.UserId;
            }
            if (dto.SendType == 1)
            {
                if (sysUserService.CheckPhoneBind(dto.PhoneNum).Count > 0)
                {
                    return ToResponse(ResultCode.CUSTOM_ERROR, "Phone number is already bound to another account");
                }
            }

            string location = HttpContextExtension.GetIpInfo(dto.LoginIP);

            smsCodeLogService.AddSmscodeLog(new SmsCodeLog()
            {
                Userid = uid,
                PhoneNum = dto.PhoneNum.ParseToLong(),
                SendType = dto.SendType,
                UserIP = dto.LoginIP,
                Location = location,
            });

            return SUCCESS(1);
        }

        /// <summary>
        /// Phone number login
        /// </summary>
        /// <param name="loginBody">Login object</param>
        /// <returns></returns>
        [Route("PhoneLogin")]
        [HttpPost]
        [Log(Title = "Phone number login")]
        public IActionResult PhoneLogin([FromBody] PhoneLoginDto loginBody)
        {
            if (loginBody == null) { throw new CustomException("Request parameter error"); }
            loginBody.LoginIP = HttpContextExtension.GetClientUserIp(HttpContext);

            if (!CacheService.CheckPhoneCode(loginBody.PhoneNum, loginBody.PhoneCode))
            {
                return ToResponse(ResultCode.CUSTOM_ERROR, "Incorrect SMS verification code");
            }
            var info = sysUserService.GetFirst(f => f.Phonenumber == loginBody.PhoneNum) ?? throw new CustomException(ResultCode.CUSTOM_ERROR, "This phone number does not exist", false);
            sysLoginService.CheckLockUser(info.UserName);
            string location = HttpContextExtension.GetIpInfo(loginBody.LoginIP);
            var user = sysLoginService.PhoneLogin(loginBody, new SysLogininfor() { LoginLocation = location }, info);

            List<SysRole> roles = roleService.SelectUserRoleListByUserId(user.UserId);
            // Permission collection eg *:*:*,system:user:list
            List<string> permissions = permissionService.GetMenuPermission(user);

            TokenModel loginUser = new(user.Adapt<TokenModel>(), roles.Adapt<List<Roles>>());
            CacheService.SetUserPerms(GlobalConstant.UserPermKEY + user.UserId, permissions);
            return SUCCESS(JwtUtil.GenerateJwtToken(JwtUtil.AddClaims(loginUser)));
        }

        /// <summary>
        /// Phone number binding
        /// </summary>
        /// <param name="loginBody"></param>
        /// <returns></returns>
        [Route("/PhoneBind")]
        [HttpPost]
        [Log(Title = "Phone number binding")]
        public IActionResult PhoneBind([FromBody] PhoneLoginDto loginBody)
        {
            if (loginBody == null) { throw new CustomException("Request parameter error"); }
            loginBody.LoginIP = HttpContextExtension.GetClientUserIp(HttpContext);
            var uid = HttpContext.GetUId();
            if (!CacheService.CheckPhoneCode(loginBody.PhoneNum, loginBody.PhoneCode))
            {
                return ToResponse(ResultCode.CUSTOM_ERROR, "Incorrect SMS verification code");
            }
            var result = sysUserService.ChangePhoneNum(uid, loginBody.PhoneNum);

            return SUCCESS(result);
        }

    }
}
