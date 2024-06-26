using Infrastructure.Attribute;
using ZR.Model.System;

namespace ZR.ServiceCore.Services
{
    /// <summary>
    /// Business layer processing for parameter configuration service
    /// </summary>
    [AppService(ServiceType = typeof(ISysConfigService), ServiceLifetime = LifeTime.Transient)]
    public class SysConfigService : BaseService<SysConfig>, ISysConfigService
    {
        #region Business Logic Code

        public SysConfig GetSysConfigByKey(string key)
        {
            return Queryable().First(f => f.ConfigKey == key);
        }

        #endregion
    }

}