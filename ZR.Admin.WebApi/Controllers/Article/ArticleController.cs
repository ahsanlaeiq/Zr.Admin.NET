using Microsoft.AspNetCore.Mvc;
using ZR.Admin.WebApi.Filters;
using ZR.Model.Content;
using ZR.Model.Content.Dto;
using ZR.Service.Content.IService;

namespace ZR.Admin.WebApi.Controllers
{
    /// <summary>
    /// Content management
    /// </summary>
    [Verify]
    [Route("article")]
    [ApiExplorerSettings(GroupName = "article")]
    public class ArticleController : BaseController
    {
        /// <summary>
        /// Article interface
        /// </summary>
        private readonly IArticleService _ArticleService;
        private readonly IArticleCategoryService _ArticleCategoryService;

        public ArticleController(
            IArticleService ArticleService,
            IArticleCategoryService articleCategoryService)
        {
            _ArticleService = ArticleService;
            _ArticleCategoryService = articleCategoryService;
            _ArticleService = ArticleService;
        }

        /// <summary>
        /// Query article list
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
        /// Batch approve content
        /// </summary>
        /// <returns></returns>
        [HttpPut("pass/{ids}")]
        [ActionPermissionFilter(Permission = "article:audit")]
        [Log(Title = "Content audit", BusinessType = BusinessType.UPDATE)]
        public IActionResult PassedMonents(string ids)
        {
            long[] idsArr = Tools.SpitLongArrary(ids);
            if (idsArr.Length <= 0) { return ToResponse(ApiResult.Error($"Failed to approve Id cannot be empty")); }

            return ToResponse(_ArticleService.Passed(idsArr));
        }

        /// <summary>
        /// Batch reject content
        /// </summary>
        /// <returns></returns>
        [HttpPut("reject/{ids}")]
        [ActionPermissionFilter(Permission = "article:audit")]
        [Log(Title = "Content audit", BusinessType = BusinessType.UPDATE)]
        public IActionResult RejectMonents(string ids, string reason = "")
        {
            long[] idsArr = Tools.SpitLongArrary(ids);
            if (idsArr.Length <= 0) { return ToResponse(ApiResult.Error($"Failed to reject Id cannot be empty")); }

            int result = _ArticleService.Reject(reason, idsArr);
            return ToResponse(result);
        }

        /// <summary>
        /// Query my article list
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
        /// Query article details
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        [HttpGet("{id}")]
        public IActionResult Get(int id)
        {
            long userId = HttpContext.GetUId();
            var model = _ArticleService.GetArticle(id, userId);

            ApiResult apiResult = ApiResult.Success(model);

            return ToResponse(apiResult);
        }

        /// <summary>
        /// Publish article
        /// </summary>
        /// <returns></returns>
        [HttpPost("add")]
        [ActionPermissionFilter(Permission = "system:article:add")]
        //[Log(Title = "Publish article", BusinessType = BusinessType.INSERT)]
        public IActionResult Create([FromBody] ArticleDto parm)
        {
            var addModel = parm.Adapt<Article>().ToCreate(context: HttpContext);
            addModel.AuthorName = HttpContext.GetName();
            addModel.UserId = HttpContext.GetUId();
            addModel.UserIP = HttpContext.GetClientUserIp();
            addModel.Location = HttpContextExtension.GetIpInfo(addModel.UserIP);
            addModel.AuditStatus = Model.Enum.AuditStatusEnum.Passed;

            return SUCCESS(_ArticleService.InsertReturnIdentity(addModel));
        }

        /// <summary>
        /// Update article
        /// </summary>
        /// <returns></returns>
        [HttpPut("edit")]
        [ActionPermissionFilter(Permission = "system:article:update")]
        //[Log(Title = "Modify article", BusinessType = BusinessType.UPDATE)]
        public IActionResult Update([FromBody] ArticleDto parm)
        {
            parm.AuthorName = HttpContext.GetName();
            var modal = parm.Adapt<Article>().ToUpdate(HttpContext);
            var response = _ArticleService.UpdateArticle(modal);

            return SUCCESS(response);
        }

        /// <summary>
        /// Top
        /// </summary>
        /// <returns></returns>
        [HttpPut("top")]
        [ActionPermissionFilter(Permission = "system:article:update")]
        [Log(Title = "Top article", BusinessType = BusinessType.UPDATE)]
        public IActionResult Top([FromBody] Article parm)
        {
            var response = _ArticleService.TopArticle(parm);

            return SUCCESS(response);
        }

        /// <summary>
        /// Is public
        /// </summary>
        /// <returns></returns>
        [HttpPut("changePublic")]
        [ActionPermissionFilter(Permission = "system:article:update")]
        [Log(Title = "Is public", BusinessType = BusinessType.UPDATE)]
        public IActionResult ChangePublic([FromBody] Article parm)
        {
            var response = _ArticleService.ChangeArticlePublic(parm);

            return SUCCESS(response);
        }

        /// <summary>
        /// Delete article
        /// </summary>
        /// <returns></returns>
        [HttpDelete("{id}")]
        [ActionPermissionFilter(Permission = "system:article:delete")]
        [Log(Title = "Delete article", BusinessType = BusinessType.DELETE)]
        public IActionResult Delete(int id = 0)
        {
            var response = _ArticleService.Delete(id);
            return SUCCESS(response);
        }
    }
}