using Quartz.Spi;
using SqlSugar;
using SqlSugar.IOC;
using ZR.Model.System;
using ZR.Tasks;

namespace ZR.Admin.WebApi.Extensions
{
    /// <summary>
    /// Task extension methods
    /// </summary>
    public static class TasksExtension
    {
        /// <summary>
        /// Register tasks
        /// </summary>
        /// <param name="services"></param>
        /// <exception cref="ArgumentNullException"></exception>
        public static void AddTaskSchedulers(this IServiceCollection services)
        {
            if (services == null) throw new ArgumentNullException(nameof(services));

            // Add Quartz services
            services.AddSingleton<IJobFactory, JobFactory>();
            services.AddTransient<ITaskSchedulerServer, TaskSchedulerServer>();
        }

        /// <summary>
        /// Add task schedules after the program starts
        /// </summary>
        /// <param name="app"></param>
        /// <returns></returns>
        public static IApplicationBuilder UseAddTaskSchedulers(this IApplicationBuilder app)
        {
            ITaskSchedulerServer _schedulerServer = app.ApplicationServices.GetRequiredService<ITaskSchedulerServer>();

            var tasks = DbScoped.SugarScope.Queryable<SysTasks>()
                .Where(m => m.IsStart == 1).ToListAsync();

            // Register all scheduled tasks after the program starts
            foreach (var task in tasks.Result)
            {
                var result = _schedulerServer.AddTaskScheduleAsync(task);
                if (result.Result.IsSuccess())
                {
                    Console.WriteLine($"Registered task [{task.Name}] ID: {task.ID} successfully");
                }
            }

            return app;
        }

        /// <summary>
        /// Initialize dictionaries
        /// </summary>
        /// <param name="app"></param>
        /// <returns></returns>
        public static IApplicationBuilder UseInit(this IApplicationBuilder app)
        {
            //Console.WriteLine("Initializing dictionary data...");
            var db = DbScoped.SugarScope;
            var types = db.Queryable<SysDictType>()
                .Where(it => it.Status == "0")
                .Select(it => it.DictType)
                .ToList();

            // Place time-consuming operations above Any to ensure they are executed only once after the program starts
            if (!db.ConfigQuery.Any())
            {
                foreach (var type in types)
                {
                    db.ConfigQuery.SetTable<SysDictData>(it => SqlFunc.ToString(it.DictValue), it => it.DictLabel, type, it => it.DictType == type);
                }
            }
            return app;
        }
    }

}
