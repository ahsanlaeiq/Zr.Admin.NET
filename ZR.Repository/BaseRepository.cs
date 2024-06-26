using Infrastructure.Extensions;
using Mapster;
using SqlSugar;
using SqlSugar.IOC;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq.Expressions;
using System.Reflection;
using ZR.Model;

namespace ZR.Repository
{
    /// <summary>
    /// Data repository class
    /// </summary>
    /// <typeparam name="T"></typeparam>
    public class BaseRepository<T> : SimpleClient<T> where T : class, new()
    {
        public ITenant itenant = null;// Multi-tenant transaction
        public BaseRepository(ISqlSugarClient context = null) : base(context)
        {
            // Get ConfigId through attribute
            var configId = typeof(T).GetCustomAttribute<TenantAttribute>()?.configId;
            if (configId != null)
            {
                Context = DbScoped.SugarScope.GetConnectionScope(configId);// Automatically select based on the ConfigId passed in by the class
            }
            else
            {
                Context = context ?? DbScoped.SugarScope.GetConnectionScope(0);// No default db0
            }
            //Context = DbScoped.SugarScope.GetConnectionScopeWithAttr<T>();
            itenant = DbScoped.SugarScope;// Set tenant interface
        }

        #region add

        /// <summary>
        /// Insert entity
        /// </summary>
        /// <param name="t"></param>
        /// <returns></returns>
        public int Add(T t, bool ignoreNull = true)
        {
            return Context.Insertable(t).IgnoreColumns(ignoreNullColumn: ignoreNull).ExecuteCommand();
        }

        public int Insert(List<T> t)
        {
            return InsertRange(t) ? 1 : 0;
        }
        public int Insert(T parm, Expression<Func<T, object>> iClumns = null, bool ignoreNull = true)
        {
            return Context.Insertable(parm).InsertColumns(iClumns).IgnoreColumns(ignoreNullColumn: ignoreNull).ExecuteCommand();
        }
        public IInsertable<T> Insertable(T t)
        {
            return Context.Insertable(t);
        }
        #endregion add

        #region update
        //public IUpdateable<T> Updateable(T entity)
        //{
        //    return Context.Updateable(entity);
        //}

        /// <summary>
        /// Update entity based on primary key
        /// </summary>
        /// <param name="entity"></param>
        /// <param name="ignoreNullColumns"></param>
        /// <returns></returns>
        public int Update(T entity, bool ignoreNullColumns = false, object data = null)
        {
            return Context.Updateable(entity).IgnoreColumns(ignoreNullColumns)
                .EnableDiffLogEventIF(data.IsNotEmpty(), data).ExecuteCommand();
        }

        /// <summary>
        /// Update entity based on primary key and specified fields
        /// return Update(new SysUser(){ Status = 1 }, t => new { t.NickName, }, true);
        /// </summary>
        /// <param name="entity"></param>
        /// <param name="expression"></param>
        /// <param name="ignoreAllNull"></param>
        /// <returns></returns>
        public int Update(T entity, Expression<Func<T, object>> expression, bool ignoreAllNull = false)
        {
            return Context.Updateable(entity).UpdateColumns(expression).IgnoreColumns(ignoreAllNull).ExecuteCommand();
        }

        /// <summary>
        /// Update specified columns based on specified conditions eg: Update(new SysUser(){ Status = 1 }, it => new { it.Status }, f => f.Userid == 1));
        /// Only update the Status column, condition is contains
        /// </summary>
        /// <param name="entity">Entity class</param>
        /// <param name="expression">Expression of columns to update</param>
        /// <param name="where">Where expression</param>
        /// <returns></returns>
        public int Update(T entity, Expression<Func<T, object>> expression, Expression<Func<T, bool>> where)
        {
            return Context.Updateable(entity).UpdateColumns(expression).Where(where).ExecuteCommand();
        }

        /// <summary>
        /// Update specified columns eg: Update(w => w.NoticeId == model.NoticeId, it => new SysNotice(){ Update_time = DateTime.Now, Title = "Notification Title" });
        /// </summary>
        /// <param name="where"></param>
        /// <param name="columns"></param>
        /// <returns></returns>
        public int Update(Expression<Func<T, bool>> where, Expression<Func<T, T>> columns)
        {
            return Context.Updateable<T>().SetColumns(columns).Where(where).RemoveDataCache().ExecuteCommand();
        }
        #endregion update

        public DbResult<bool> UseTran(Action action)
        {
            try
            {
                var result = Context.Ado.UseTran(() => action());
                return result;
            }
            catch (Exception ex)
            {
                Context.Ado.RollbackTran();
                Console.WriteLine(ex.Message);
                throw;
            }
        }

        /// <summary>
        /// Use transaction
        /// </summary>
        /// <param name="client"></param>
        /// <param name="action">CRUD method</param>
        /// <returns></returns>
        public DbResult<bool> UseTran(ISqlSugarClient client, Action action)
        {
            try
            {
                var result = client.AsTenant().UseTran(() => action());
                return result;
            }
            catch (Exception ex)
            {
                Console.WriteLine("Transaction exception: " + ex.Message);
                client.AsTenant().RollbackTran();
                throw;
            }
        }

        /// <summary>
        /// Use transaction
        /// </summary>
        /// <param name="action"></param>
        /// <returns></returns>
        public bool UseTran2(Action action)
        {
            Console.WriteLine("---Transaction start---");
            var result = Context.Ado.UseTran(() => action());
            Console.WriteLine("---Transaction end---");
            return result.IsSuccess;
        }

        #region delete
        public IDeleteable<T> Deleteable()
        {
            return Context.Deleteable<T>();
        }

        public int Delete(object id, string title = "")
        {
            return Context.Deleteable<T>(id).EnableDiffLogEventIF(title.IsNotEmpty(), title).ExecuteCommand();
        }
        public int DeleteTable()
        {
            return Context.Deleteable<T>().ExecuteCommand();
        }
        public bool Truncate()
        {
            return Context.DbMaintenance.TruncateTable<T>();
        }
        #endregion delete

        #region query

        public bool Any(Expression<Func<T, bool>> expression)
        {
            return Context.Queryable<T>().Where(expression).Any();
        }

        public ISugarQueryable<T> Queryable()
        {
            return Context.Queryable<T>();
        }

        public List<T> SqlQueryToList(string sql, object obj = null)
        {
            return Context.Ado.SqlQuery<T>(sql, obj);
        }

        /// <summary>
        /// Query a Model record based on the SQL Query
        /// https://github.com/DotNetNext/SqlSugar/wiki/7.Ado
        /// </summary>
        /// <param name="query">SQL Query</param>
        /// <returns>DataTable</returns>
        public DataTable GetModelRawQuery(string query)
        {
            return Context.Ado.GetDataTable(query);
        }

        /// <summary>
        /// Query a single record based on the primary key value
        /// </summary>
        /// <param name="pkValue">Primary key value</param>
        /// <returns>Generic entity</returns>
        public T GetId(object pkValue)
        {
            return Context.Queryable<T>().InSingle(pkValue);
        }


        

        /// <summary>
        /// Query paged data based on conditions
        /// </summary>
        /// <param name="where"></param>
        /// <param name="parm"></param>
        /// <returns></returns>
        public PagedInfo<T> GetPages(Expression<Func<T, bool>> where, PagerInfo parm)
        {
            var source = Context.Queryable<T>().Where(where);

            return source.ToPage(parm);
        }

        /// <summary>
        /// Get paged data
        /// </summary>
        /// <param name="where">Condition expression</param>
        /// <param name="parm"></param>
        /// <param name="order"></param>
        /// <param name="orderEnum"></param>
        /// <returns></returns>
        public PagedInfo<T> GetPages(Expression<Func<T, bool>> where, PagerInfo parm, Expression<Func<T, object>> order, OrderByType orderEnum = OrderByType.Asc)
        {
            var source = Context
                .Queryable<T>()
                .Where(where)
                .OrderByIF(orderEnum == OrderByType.Asc, order, OrderByType.Asc)
                .OrderByIF(orderEnum == OrderByType.Desc, order, OrderByType.Desc);

            return source.ToPage(parm);
        }

        public PagedInfo<T> GetPages(Expression<Func<T, bool>> where, PagerInfo parm, Expression<Func<T, object>> order, string orderByType)
        {
            return GetPages(where, parm, order, orderByType == "desc" ? OrderByType.Desc : OrderByType.Asc);
        }

        /// <summary>
        /// Query all data (without pagination, use with caution)
        /// </summary>
        /// <returns></returns>
        public List<T> GetAll(bool useCache = false, int cacheSecond = 3600)
        {
            return Context.Queryable<T>().WithCacheIF(useCache, cacheSecond).ToList();
        }

        #endregion query

        /// <summary>
        /// This method return Dataset output value of given Query
        /// var list = new List<SugarParameter>();
        /// list.Add(new SugarParameter(ParaName, ParaValue)); // input
        /// </summary>
        /// <param name="query"></param>
        /// <param name="parameters"></param>
        /// <returns></returns>
        public DataTable UseQueryToDataTable(string query, List<SugarParameter> parameters)
        {
            return Context.Ado.GetDataTable(query, parameters);
        }


        /// <summary>
        /// This method does not return an output value
        /// var list = new List<SugarParameter>();
        /// list.Add(new SugarParameter(ParaName, ParaValue)); // input
        /// </summary>
        /// <param name="procedureName"></param>
        /// <param name="parameters"></param>
        /// <returns></returns>
        public DataTable UseStoredProcedureToDataTable(string procedureName, List<SugarParameter> parameters)
        {
            return Context.Ado.UseStoredProcedure().GetDataTable(procedureName, parameters);
        }

        /// <summary>
        /// This method returns an output value
        /// var list = new List<SugarParameter>();
        /// list.Add(new SugarParameter(ParaName, ParaValue, true)); // output
        /// list.Add(new SugarParameter(ParaName, ParaValue)); // input
        /// </summary>
        /// <param name="procedureName"></param>
        /// <param name="parameters"></param>
        /// <returns></returns>
        public (DataTable, List<SugarParameter>) UseStoredProcedureToTuple(string procedureName, List<SugarParameter> parameters)
        {
            var result = (Context.Ado.UseStoredProcedure().GetDataTable(procedureName, parameters), parameters);
            return result;
        }
    }

    /// <summary>
    /// Paging query extension
    /// </summary>

    public static class QueryableExtension
    {
        /// <summary>
        /// Read a list
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="source">Query expression</param>
        /// <param name="parm">Pagination parameters</param>
        /// <returns></returns>
        public static PagedInfo<T> ToPage<T>(this ISugarQueryable<T> source, PagerInfo parm)
        {
            var page = new PagedInfo<T>();
            var total = 0;
            page.PageSize = parm.PageSize;
            page.PageIndex = parm.PageNum;
            if (parm.Sort.IsNotEmpty())
            {
                source.OrderByPropertyName(parm.Sort, parm.SortType.Contains("desc") ? OrderByType.Desc : OrderByType.Asc);
            }
            page.Result = source
                //.OrderByIF(parm.Sort.IsNotEmpty(), $"{parm.Sort.ToSqlFilter()} {(!string.IsNullOrWhiteSpace(parm.SortType) && parm.SortType.Contains("desc") ? "desc" : "asc")}")
                .ToPageList(parm.PageNum, parm.PageSize, ref total);
            page.TotalNum = total;
            return page;
        }

        /// <summary>
        /// Convert to a specified entity class DTO
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <typeparam name="T2"></typeparam>
        /// <param name="source"></param>
        /// <param name="parm"></param>
        /// <returns></returns>
        public static PagedInfo<T2> ToPage<T, T2>(this ISugarQueryable<T> source, PagerInfo parm)
        {
            var page = new PagedInfo<T2>();
            var total = 0;
            page.PageSize = parm.PageSize;
            page.PageIndex = parm.PageNum;
            if (parm.Sort.IsNotEmpty())
            {
                source.OrderByPropertyName(parm.Sort, parm.SortType.Contains("desc") ? OrderByType.Desc : OrderByType.Asc);
            }
            var result = source
                //.OrderByIF(parm.Sort.IsNotEmpty(), $"{parm.Sort.ToSqlFilter()} {(!string.IsNullOrWhiteSpace(parm.SortType) && parm.SortType.Contains("desc") ? "desc" : "asc")}")
                .ToPageList(parm.PageNum, parm.PageSize, ref total);

            page.TotalNum = total;
            page.Result = result.Adapt<List<T2>>();
            return page;
        }
    }

}
