﻿using Microsoft.AspNetCore.Mvc;
using SqlSugar;
using ZR.Admin.WebApi.Filters;
using ZR.Model.System;
using ZR.Model.System.Dto;
using ZR.ServiceCore.Model;
using ZR.ServiceCore.Model.Dto;
using ZR.ServiceCore.Services.IService;

namespace ZR.Admin.WebApi.Controllers
{
    /// <summary>
    /// 内容管理
    /// </summary>
    [Verify]
    [Route("article")]
    [ApiExplorerSettings(GroupName = "article")]
    public class ArticleController : BaseController
    {
        /// <summary>
        /// 文章接口
        /// </summary>
        private readonly IArticleService _ArticleService;
        private readonly IArticleCategoryService _ArticleCategoryService;
        private readonly IArticlePraiseService _ArticlePraiseService;

        public ArticleController(
            IArticleService ArticleService, 
            IArticleCategoryService articleCategoryService,
            IArticlePraiseService articlePraiseService)
        {
            _ArticleService = ArticleService;
            _ArticleCategoryService = articleCategoryService;
            _ArticleService = ArticleService;
        }

        /// <summary>
        /// 查询文章列表
        /// </summary>
        /// <returns></returns>
        [HttpGet("list")]
        [ActionPermissionFilter(Permission = "system:article:list")]
        public IActionResult Query([FromQuery] ArticleQueryDto parm)
        {
            var response = _ArticleService.GetList(parm);

            return SUCCESS(response);
        }

        /// <summary>
        /// 查询我的文章列表
        /// </summary>
        /// <returns></returns>
        [HttpGet("mylist")]
        public IActionResult QueryMyList([FromQuery] ArticleQueryDto parm)
        {
            parm.UserId = HttpContext.GetUId();
            var response = _ArticleService.GetMyList(parm);

            return SUCCESS(response);
        }

        /// <summary>
        /// 查询文章详情
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        [HttpGet("{id}")]
        [AllowAnonymous]
        public IActionResult Get(int id)
        {
            long userId = HttpContext.GetUId();
            var model = _ArticleService.GetArticle(id, userId);
            return SUCCESS(model);
        }

        /// <summary>
        /// 发布文章
        /// </summary>
        /// <returns></returns>
        [HttpPost("add")]
        [ActionPermissionFilter(Permission = "system:article:add")]
        //[Log(Title = "发布文章", BusinessType = BusinessType.INSERT)]
        public IActionResult Create([FromBody] ArticleDto parm)
        {
            var addModel = parm.Adapt<Article>().ToCreate(context: HttpContext);
            addModel.AuthorName = HttpContext.GetName();
            addModel.UserId = HttpContext.GetUId();
            addModel.UserIP = HttpContext.GetClientUserIp();
            addModel.Location = HttpContextExtension.GetIpInfo(addModel.UserIP);

            return SUCCESS(_ArticleService.InsertReturnIdentity(addModel));
        }

        /// <summary>
        /// 更新文章
        /// </summary>
        /// <returns></returns>
        [HttpPut("edit")]
        [ActionPermissionFilter(Permission = "system:article:update")]
        //[Log(Title = "文章修改", BusinessType = BusinessType.UPDATE)]
        public IActionResult Update([FromBody] ArticleDto parm)
        {
            parm.AuthorName = HttpContext.GetName();
            var modal = parm.Adapt<Article>().ToUpdate(HttpContext);
            var response = _ArticleService.UpdateArticle(modal);

            return SUCCESS(response);
        }

        /// <summary>
        /// 置顶
        /// </summary>
        /// <returns></returns>
        [HttpPut("top")]
        [ActionPermissionFilter(Permission = "system:article:update")]
        [Log(Title = "置顶文章", BusinessType = BusinessType.UPDATE)]
        public IActionResult Top([FromBody] Article parm)
        {
            var response = _ArticleService.TopArticle(parm);

            return SUCCESS(response);
        }

        /// <summary>
        /// 是否公开
        /// </summary>
        /// <returns></returns>
        [HttpPut("changePublic")]
        [ActionPermissionFilter(Permission = "system:article:update")]
        [Log(Title = "是否公开", BusinessType = BusinessType.UPDATE)]
        public IActionResult ChangePublic([FromBody] Article parm)
        {
            var response = _ArticleService.ChangeArticlePublic(parm);

            return SUCCESS(response);
        }

        /// <summary>
        /// 删除文章
        /// </summary>
        /// <returns></returns>
        [HttpDelete("{id}")]
        [ActionPermissionFilter(Permission = "system:article:delete")]
        [Log(Title = "文章删除", BusinessType = BusinessType.DELETE)]
        public IActionResult Delete(int id = 0)
        {
            var response = _ArticleService.Delete(id);
            return SUCCESS(response);
        }

        #region 前端接口

        /// <summary>
        /// 前台查询文章列表
        /// </summary>
        /// <returns></returns>
        [HttpGet("homeList")]
        [AllowAnonymous]
        public IActionResult QueryHomeList([FromQuery] ArticleQueryDto parm)
        {
            var response = _ArticleService.GetHotList(parm);

            return SUCCESS(response);
        }

        /// <summary>
        /// 查询最新文章列表
        /// </summary>
        /// <returns></returns>
        [HttpGet("newList")]
        [AllowAnonymous]
        public IActionResult QueryNew()
        {
            var predicate = Expressionable.Create<Article>();
            predicate = predicate.And(m => m.Status == "1");
            predicate = predicate.And(m => m.IsPublic == 1);
            predicate = predicate.And(m => m.ArticleType == 0);

            var response = _ArticleService.Queryable()
                .Where(predicate.ToExpression())
                .Includes(x => x.ArticleCategoryNav) //填充子对象
                .Take(10)
                .OrderBy(f => f.UpdateTime, OrderByType.Desc).ToList();

            return SUCCESS(response);
        }

        /// <summary>
        /// 点赞
        /// </summary>
        /// <returns></returns>
        [HttpPost("praise")]
        public IActionResult PraiseArticle([FromBody] ArticlePraiseDto parm)
        {
            var addModel = parm.Adapt<ArticlePraise>().ToCreate(context: HttpContext);
            
            addModel.UserId = HttpContext.GetUId();
            addModel.UserIP = HttpContext.GetClientUserIp();
            addModel.Location = HttpContextExtension.GetIpInfo(addModel.UserIP);

            return SUCCESS(_ArticlePraiseService.Praise(addModel));
        }
        #endregion
    }
}