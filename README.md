<h2 align="center"> ZR.Admin.NET Back-end management system</h2>
<h4 align="center">base .Net7 + vue2.x/vue3.x/uniapp Front-end and back-end separation of .NET rapid development framework</h4>

<div style="text-align:center">

[![stars](https://gitee.com/izory/ZrAdminNetCore/badge/star.svg?theme=dark)](https://gitee.com/izory/ZrAdminNetCore)
[![fork](https://gitee.com//izory/ZrAdminNetCore/badge/fork.svg?theme=dark)](https://gitee.com/izory/ZrAdminNetCore/members)
[![Change log](https://img.shields.io/badge/ChangeLog-20240105-yellow)](http://www.izhaorui.cn/doc/changelog.html)

[![GitHub license](https://img.shields.io/github/license/izhaorui/ZrAdmin.NET)](https://github.com/izhaorui/ZrAdmin.NET/blob/main/LICENSE)
[![GitHub stars](https://img.shields.io/github/stars/izhaorui/ZrAdmin.NET?style=social)](https://github.com/izhaorui/ZrAdmin.NET/stargazers)
[![GitHub forks](https://img.shields.io/github/forks/izhaorui/ZrAdmin.NET?style=social)](https://github.com/izhaorui/ZrAdmin.NET/network)

</div>

---

<div align="center">
	<p><strong><a href="README.md">English</a> | <a href="README.cn.md">简体中文</a></strong></p>
</div>

---

## 🍟 overview

- This project is suitable for developers with some NetCore and vue foundation
  -Based on. NET5/. A common rights management platform (RBAC model) implemented by NET7. Integrate the latest technology for efficient and rapid development, front-end and back-end separation mode, out of the box.
- Less code, simple to learn, easy to understand, powerful, easy to extend, lightweight, make web development faster, simpler and more efficient (say goodbye to 996), solve 70% of repetitive work, focus on your business, easy development from now on!
- 提供了技术栈(Ant Design Vue)版[Ant Design Vue](https://gitee.com/billzh/mc-dull.git)

```
If it helps you, you can click "Star" in the upper right corner to collect it, so that the author has the motivation to continue to go on for free, thank you! ~
```

## 📈 Quick start

- Quick start：[https://www.izhaorui.cn/doc/quickstart.html](https://www.izhaorui.cn/doc/quickstart.html)

## 🍿 Online experience

- Official documentation：http://www.izhaorui.cn/doc
- Join a group chat：[立即加入](http://www.izhaorui.cn/doc/contact.html)
- Vue3.x experience：[http://www.izhaorui.cn/vue3](http://www.izhaorui.cn/vue3)
- Vue2.x experience：[http://www.izhaorui.cn/admin](http://www.izhaorui.cn/admin)
- Uniapp experience：[http://www.izhaorui.cn/h5](http://www.izhaorui.cn/h5)
- account/password：admin/123456

| H5                                                                                     | WeChat mini program                                                                  |
| -------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------ |
| ![alt](https://gitee.com/izory/ZrAdminNetCore/raw/master/document/images/qrcodeH5.png) | ![alt](https://gitee.com/izory/ZrAdminNetCore/raw/master/document/images/qrcode.jpg) |

```
Since it is a personal project, the funds are limited, and the experience server is low-fied, please cherish it, poke it lightly, and appreciate it!!
```

## 💒 Code repository

| repository | Github                                                      | Gitee                                                    |
| ---------- | ----------------------------------------------------------- | -------------------------------------------------------- |
| Net7       | [Clone/Download](https://github.com/izhaorui/Zr.Admin.NET)  | [Clone/Download](https://gitee.com/izory/ZrAdminNetCore) |
| Vue3(Hot)  | [Clone/Download](https://github.com/izhaorui/ZR.Admin.Vue3) | [Clone/Download](https://gitee.com/izory/ZRAdmin-vue)    |

## 🍁 Front-end technology

Vue Front-end technology stack: Based on Vue2.x/Vue3.x/UniApp, Vue, Vue-router, Vue-CLI, AXIOS, Element-UI, Echats, i18N Internationalization, etc., the front-end adopts VSCODE tool development

## 🍀 Back-end technology

- Core Framework: . Net7.0 + Web API + sqlsugar + swagger + signalR + IpRateLimit + Quartz.net + Redis
- Scheduled tasks: Quartz.Net component that supports the execution of assemblies or HTTP network requests
- Security support: filters (data permission filtering), SQL injection, request forgery
- Log management: NLog, login log, operation log, scheduled task log
- Tools: Captcha, rich public functions
- Interface throttling: Supports interface throttling to avoid excessive pressure on the service layer caused by malicious requests
- Code generation: efficient development, the code generator can generate all front-end and back-end code with one click
- Data dictionary: Support data dictionary, which can facilitate the management of some states
- Sub-library and table sharding: Using orm sqlsugar can easily achieve sub-library and table sharding with excellent performance
- Multi-tenant: Support multi-tenancy function
- Cache data: Built-in memory cache and Redis

## 🍖 Built-in features

1. User management: The user is the system operator, and this function mainly completes the system user configuration.
2. Department management: configure the system organization (company, department, group), tree structure display.
3. Job management: configure the position of the system user.
4. Menu management: configure system menus, operation permissions, button permission identification, etc.
5. Role Management: Role menu permission assignment.
6. Dictionary management: maintain some relatively fixed data that is often used in the system.
7. Operation log: system normal operation log records and queries; System exception information logging and querying.
8. Login logon: The system logon log record query contains logon exceptions.
9. System Interface: Use Swagger to generate relevant API interface documentation.
10. Service monitoring: Monitor the current system CPU, memory, disk, stack, and other related information.
11. Online Builder: Drag form elements to generate the corresponding VUE code (only VUE2 supported).
12. Task system: Based on the Quartz.NET, you can schedule tasks online (add, modify, delete, manually execute) including execution result logs.
13. Article management: You can write article records.
14. Code generation: You can generate front-end and back-end code (.cs, .vue, .js, .sql, etc.) with one click, support download, customize the configuration of front-end display controls, and make development faster and more efficient (the strongest in history).
15. Parameter management: dynamically configure common parameters for the system.
16. Send Mail: You can send mail to multiple users.
17. File management: You can manage uploaded files, which currently supports uploading to on-premises and Alibaba Cloud.
18. Notification management: The system notifies and announces information release and maintenance, and uses SignalR to realize real-time notification to users.
19. Account Registration: You can register an account to log in to the system.
20. Multi-language management: support static and back-end dynamic configuration internationalization. Currently only supports Chinese, English, and Traditional characters (only VUE3 is supported)

## 🍻 Project structure
```
├─ZR.Service                 ->[Your business service layer library]: Provides WebApi interface calls; 
├─ZR.ServiceCore             		->[System service layer library]: Provides WebApi interface calls; 
├─ZR.Repository                     ->[Repository layer library]: Conveniently provides operations with executing stored procedures; 
├─ZR.Model                		->[Entity layer library]: Provides database tables and data transfer objects in the project; 
├─ZR.Admin.WebApi               	->[WebApi interface]: Provides interface services for Vue version or other third-party systems. 
├─ZR.Tasks               		->[Scheduled task library]: Provides project scheduled task implementation functions; 
├─ZR.CodeGenerator               	->[Code generation function]: Includes code generation templates, methods, and code generation downloads. 
├─ZR.Vue               			->[Front-end UI]: Vue 2.0 version UI layer (no longer updated, recommend using Vue 3). 
├─document               		->[Documentation]: Database scripts
```


## 🍎 Storyplate

<table>
    <tr>
        <td><img src="https://gitee.com/izory/ZrAdminNetCore/raw/master/document/images/1.png"/></td>
        <td><img src="https://gitee.com/izory/ZrAdminNetCore/raw/master/document/images/2.png"/></td>
    </tr>
    <tr>
        <td><img src="https://gitee.com/izory/ZrAdminNetCore/raw/master/document/images/3.png"/></td>
        <td><img src="https://gitee.com/izory/ZrAdminNetCore/raw/master/document/images/4.png"/></td>
    </tr>
    <tr>
        <td><img src="https://gitee.com/izory/ZrAdminNetCore/raw/master/document/images/5.png"/></td>
        <td><img src="https://gitee.com/izory/ZrAdminNetCore/raw/master/document/images/6.png"/></td>
    </tr>
	<tr>
        <td><img src="https://gitee.com/izory/ZrAdminNetCore/raw/master/document/images/7.png"/></td>
        <td><img src="https://gitee.com/izory/ZrAdminNetCore/raw/master/document/images/8.png"/></td>
    </tr>	
	<tr>
        <td><img src="https://gitee.com/izory/ZrAdminNetCore/raw/master/document/images/9.png"/></td>
        <td><img src="https://gitee.com/izory/ZrAdminNetCore/raw/master/document/images/10.png"/></td>
    </tr>
	<tr>
        <td><img src="https://gitee.com/izory/ZrAdminNetCore/raw/master/document/images/11.png"/></td>
        <td><img src="https://gitee.com/izory/ZrAdminNetCore/raw/master/document/images/12.png"/></td>
    </tr>
	<tr>
        <td><img src="https://gitee.com/izory/ZrAdminNetCore/raw/master/document/images/13.png"/></td>
        <td><img src="https://gitee.com/izory/ZrAdminNetCore/raw/master/document/images/14.png"/></td>
    </tr>
	<tr>
        <td><img src="https://gitee.com/izory/ZrAdminNetCore/raw/master/document/images/15.png"/></td>
        <td><img src="https://gitee.com/izory/ZrAdminNetCore/raw/master/document/images/16.png"/></td>
    </tr>
	<tr>
        <td><img src="https://gitee.com/izory/ZrAdminNetCore/raw/master/document/images/17.png"/></td>
		<td><img src="https://gitee.com/izory/ZrAdminNetCore/raw/master/document/images/18.png"/></td>
    </tr>
	<tr>
		<td><img src="https://gitee.com/izory/ZrAdminNetCore/raw/master/document/images/19.png"/></td>
		<td><img src="https://gitee.com/izory/ZrAdminNetCore/raw/master/document/images/20.png"/></td>
	</tr>
	<tr>
		<td><img src="https://gitee.com/izory/ZrAdminNetCore/raw/master/document/images/21.png"/></td>
		<td><img src="https://gitee.com/izory/ZrAdminNetCore/raw/master/document/images/22.png"/></td>
	</tr>
	<tr>
		<td><img src="https://gitee.com/izory/ZrAdminNetCore/raw/master/document/images/23.png"/></td>
	</tr>
</table>

## 📱 Mobile Storyplate

<table>
    <tr>
        <td><img src="https://gitee.com/izory/ZrAdminNetCore/raw/master/document/images/a1.png"/></td>
        <td><img src="https://gitee.com/izory/ZrAdminNetCore/raw/master/document/images/a2.png"/></td>
    </tr>
    <tr>
        <td><img src="https://gitee.com/izory/ZrAdminNetCore/raw/master/document/images/a8.png"/></td>
        <td><img src="https://gitee.com/izory/ZrAdminNetCore/raw/master/document/images/a4.png"/></td>
    </tr>
    <tr>
        <td><img src="https://gitee.com/izory/ZrAdminNetCore/raw/master/document/images/a5.png"/></td>
        <td><img src="https://gitee.com/izory/ZrAdminNetCore/raw/master/document/images/a6.png"/></td>
    </tr>
		<tr>
        <td><img src="https://gitee.com/izory/ZrAdminNetCore/raw/master/document/images/a7.png"/></td>
        <td><img src="https://gitee.com/izory/ZrAdminNetCore/raw/master/document/images/a9.png"/></td>
    </tr>
		<tr>
        <td><img src="https://gitee.com/izory/ZrAdminNetCore/raw/master/document/images/a10.png"/></td>
				<td><img src="https://gitee.com/izory/ZrAdminNetCore/raw/master/document/images/a11.png"/></td>
    </tr>
		<tr>
        <td><img src="https://gitee.com/izory/ZrAdminNetCore/raw/master/document/images/a12.png"/></td>
    </tr>

</table>

## 🎉 Advantages

1. The front-end system does not need to write login, authorization, and authentication modules; Just write the business module
2. The background system can be used directly after release without any secondary development
3. The front-end and back-end systems are separated, and they are separate systems (domain names can be independent)
4. Unified handling of global exceptions
5. Custom code generation features
6. Less dependence, easy to get started
7. Comprehensive documentation

## 💐 Special thanks

- 👉Ruoyi.vue：[Ruoyi](http://www.ruoyi.vip/)
- 👉SqlSugar：[SqlSugar](https://gitee.com/dotnetchina/SqlSugar)
- 👉vue-element-admin：[vue-element-admin](https://github.com/PanJiaChen/vue-element-admin)
- 👉Meiam.System：[Meiam.System](https://github.com/91270/Meiam.System)
- 👉Furion：[Furion](https://gitee.com/dotnetchina/Furion)

## 🎀 donation

If you feel that the project has helped you, you can ask the author for a cup of coffee as a sign of encouragement ☕️
<img src="https://gitee.com/izory/ZrAdminNetCore/raw/master/document/images/pay.jpg"/>
