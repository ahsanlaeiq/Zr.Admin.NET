CREATE DATABASE ZrAdmin
GO
USE ZrAdmin
GO
CREATE TABLE Sys_tasksQz
(
	ID VARCHAR(100) NOT NULL PRIMARY KEY,	--任务ID
	Name VARCHAR(50) NOT NULL,				--任务名
	JobGroup varchar(255) NOT NULL,			--'任务分组',
	Cron varchar(255) NOT NULL ,			--'运行时间表达式',
	AssemblyName varchar(255)  NOT NULL ,	--'程序集名称',
	ClassName varchar(255)  NOT NULL ,		--'任务所在类',
	Remark VARCHAR(200)  NULL ,					--'任务描述',
	RunTimes int NOT NULL ,				--'执行次数',
	BeginTime datetime NULL DEFAULT NULL ,	--'开始时间',
	EndTime datetime NULL DEFAULT NULL ,	--'结束时间',
	TriggerType int NOT NULL ,			--'触发器类型（0、simple 1、cron）',
	IntervalSecond int NOT NULL ,		--'执行间隔时间(单位:秒)',
	IsStart int NOT NULL ,			--'是否启动',
	JobParams TEXT  NULL ,				--'传入参数',
	create_time datetime NULL DEFAULT NULL , --'创建时间',
	update_time datetime NULL DEFAULT NULL , --'最后更新时间',
	create_by varchar(50)  NULL DEFAULT NULL , --'创建人编码',
	update_by varchar(50)  NULL DEFAULT NULL , --'更新人编码',
)
GO
INSERT INTO Sys_TasksQz VALUES ('1410905433996136448', '测试任务', 'SYSTEM', '0 0/10 * * * ? ', 'ZR.Tasks', 'Job_SyncTest', NULL, 0, '2021-07-02 18:17:31', '9999-12-31 00:00:00', 1, 1, 1, NULL, '2021-07-02 18:17:23', '2021-07-02 18:17:31', 'admin', NULL);
GO
/**定时任务调度日志表*/
CREATE TABLE sys_Tasks_log  (
  jobLogId bigint NOT NULL PRIMARY KEY IDENTITY(1,1), -- '任务日志ID',
  jobId varchar(20)  NOT NULL  ,		-- '任务id',
  jobName varchar(64) NOT NULL ,		-- '任务名称',
  jobGroup varchar(64) NOT NULL ,		-- '任务组名',
  jobMessage varchar(500)  NULL  ,		-- '日志信息',
  status varchar(1) NULL DEFAULT '0' ,		-- '执行状态（0正常 1失败）',
  exception varchar(2000) NULL DEFAULT '' ,  -- '异常信息',
  createTime datetime NULL ,			-- '创建时间',
  invokeTarget varchar(200)  NULL ,		-- '调用目标',
  elapsed DECIMAL(10, 4) NULL,			-- '作业用时',
)
GO
INSERT INTO sys_Tasks_log VALUES ('1410905433996136448', '测试任务', 'SYSTEM', 'Succeed', '0', NULL, '2021-08-02 15:10:00', 'ZRTasks.Job_SyncTest', 18);
INSERT INTO sys_Tasks_log VALUES ('1410905433996136448', '测试任务', 'SYSTEM', 'Succeed', '0', NULL, '2021-08-02 15:20:00', 'ZRTasks.Job_SyncTest', 14);
GO
/*部门表*/
CREATE TABLE sys_dept  (
  deptId bigint NOT NULL PRIMARY KEY IDENTITY(100,1) ,-- '部门id',
  parentId bigint NULL DEFAULT 0 ,					-- '父部门id',
  ancestors varchar(50)  NULL DEFAULT '' ,			-- '祖级列表',
  deptName varchar(30)  NULL DEFAULT '' ,			-- '部门名称',
  orderNum int NULL DEFAULT 0 ,						-- '显示顺序',
  leader varchar(20)  NULL DEFAULT NULL ,			-- '负责人',
  phone varchar(11)  NULL DEFAULT NULL ,			-- '联系电话',
  email varchar(50)  NULL DEFAULT NULL ,			-- '邮箱',
  status varchar(1)  NULL DEFAULT '0' ,				-- '部门状态（0正常 1停用）',
  delFlag varchar(1)  NULL DEFAULT '0' ,				-- '删除标志（0代表存在 2代表删除）',
  create_by varchar(64)  NULL DEFAULT '' ,			-- '创建者',
  create_time datetime NULL DEFAULT NULL ,			-- '创建时间',
  update_by varchar(64)  NULL DEFAULT '' ,			-- '更新者',
  update_time datetime NULL DEFAULT NULL ,			-- '更新时间',
  remark varchar(255)  NULL DEFAULT NULL ,			-- '备注',
) 
GO
INSERT INTO sys_dept(parentId, ancestors, deptName, orderNum, leader, phone, email, status, delFlag, create_by, create_time, update_by, update_time, remark) VALUES (0, '0,100,100,100,100', '某上市公司', 0, 'zr', '', '', '0', '0', 'admin', '2021-04-20 20:45:52', '', '', NULL);
INSERT INTO sys_dept(parentId, ancestors, deptName, orderNum, leader, phone, email, status, delFlag, create_by, create_time, update_by, update_time, remark) VALUES (100, '0,100', '深圳总公司', 1, 'tom', '', '', '0', '0', 'admin', '2021-04-20 20:45:53', '', NULL, NULL);
INSERT INTO sys_dept(parentId, ancestors, deptName, orderNum, leader, phone, email, status, delFlag, create_by, create_time, update_by, update_time, remark) VALUES (100, '0,100', '长沙分公司', 2, 'tom', '', '', '0', '0', 'admin', '2021-04-20 20:45:53', '', NULL, NULL);
INSERT INTO sys_dept(parentId, ancestors, deptName, orderNum, leader, phone, email, status, delFlag, create_by, create_time, update_by, update_time, remark) VALUES (101, '0,100,101', '研发部门', 1, 'tom', '', '', '0', '0', 'admin', '2021-04-20 20:45:53', '', NULL, NULL);
INSERT INTO sys_dept(parentId, ancestors, deptName, orderNum, leader, phone, email, status, delFlag, create_by, create_time, update_by, update_time, remark) VALUES (101, '0,100,101', '市场部门', 2, 'tom', '', '', '0', '0', 'admin', '2021-04-20 20:45:53', '', NULL, NULL);
INSERT INTO sys_dept(parentId, ancestors, deptName, orderNum, leader, phone, email, status, delFlag, create_by, create_time, update_by, update_time, remark) VALUES (101, '0,100,101', '测试部门', 3, 'tom', '', '', '0', '0', 'admin', '2021-04-20 20:45:53', '', NULL, NULL);
INSERT INTO sys_dept(parentId, ancestors, deptName, orderNum, leader, phone, email, status, delFlag, create_by, create_time, update_by, update_time, remark) VALUES (101, '0,100,101', '财务部门', 4, 'tom', '', '', '0', '0', 'admin', '2021-04-20 20:45:53', '', NULL, NULL);
INSERT INTO sys_dept(parentId, ancestors, deptName, orderNum, leader, phone, email, status, delFlag, create_by, create_time, update_by, update_time, remark) VALUES (200, '0,100,101,200', '研发部门', 1, NULL, NULL, NULL, '0', '0', 'admin', '2021-07-07 15:00:23', '', NULL, NULL);
INSERT INTO sys_dept(parentId, ancestors, deptName, orderNum, leader, phone, email, status, delFlag, create_by, create_time, update_by, update_time, remark) VALUES (200, '0,100,102,108,108,108', '市场部门', 1, 'tom', '', '', '0', '0', 'admin', '2021-04-20 20:45:53', '', '', NULL);
INSERT INTO sys_dept(parentId, ancestors, deptName, orderNum, leader, phone, email, status, delFlag, create_by, create_time, update_by, update_time, remark) VALUES (102, '0,100,102', '财务部门', 2, 'tom', '', '', '0', '0', 'admin', '2021-04-20 20:45:53', '', NULL, NULL);
INSERT INTO sys_dept(parentId, ancestors, deptName, orderNum, leader, phone, email, status, delFlag, create_by, create_time, update_by, update_time, remark) VALUES (100, '0,100,101', '湖北总公司', 3, 'zrr', NULL, NULL, '0', '0', 'admin', '2021-04-21 13:39:13', '', '', NULL);
INSERT INTO sys_dept(parentId, ancestors, deptName, orderNum, leader, phone, email, status, delFlag, create_by, create_time, update_by, update_time, remark) VALUES (102, '0,100,102,108', '研发部门', 1, 'zzzz', NULL, NULL, '0', '0', 'admin', '2021-04-21 13:46:43', '', '', NULL);
GO
--字典类型表
CREATE TABLE sys_dict_type  (
  dictId BIGINT NOT NULL PRIMARY KEY IDENTITY(1,1) ,-- '字典主键',
  dictName varchar(100)  NULL DEFAULT '' ,-- '字典名称',
  dictType varchar(100)  NULL DEFAULT '' ,-- '字典类型',
  status varchar(1)  NULL DEFAULT '0' ,-- '状态（0正常 1停用）',
  create_by varchar(64)  NULL DEFAULT '' ,-- '创建者',
  create_time datetime NULL DEFAULT NULL ,-- '创建时间',
  update_by varchar(64)  NULL DEFAULT '' ,-- '更新者',
  update_time datetime NULL DEFAULT NULL ,-- '更新时间',
  remark varchar(500)  NULL DEFAULT NULL ,-- '备注',
)
GO
CREATE INDEX dictType ON dbo.sys_dict_type(dictType)
GO

INSERT INTO sys_dict_type VALUES ('用户性别', 'sys_user_sex', '0', 'admin', '2021-02-24 10:55:26', '', NULL, '用户性别列表');
INSERT INTO sys_dict_type VALUES ('菜单状态', 'sys_show_hide', '0', 'admin', '2021-02-24 10:55:26', '', NULL, '菜单状态列表');
INSERT INTO sys_dict_type VALUES ('系统开关', 'sys_normal_disable', '0', 'admin', '2021-02-24 10:55:26', '', NULL, '系统开关列表');
INSERT INTO sys_dict_type VALUES ('任务状态', 'sys_job_status', '0', 'admin', '2021-02-24 10:55:26', '', NULL, '任务状态列表');
INSERT INTO sys_dict_type VALUES ('任务分组', 'sys_job_group', '0', 'admin', '2021-02-24 10:55:26', '', NULL, '任务分组列表');
INSERT INTO sys_dict_type VALUES ('系统是否', 'sys_yes_no', '0', 'admin', '2021-02-24 10:55:26', '', NULL, '系统是否列表');
INSERT INTO sys_dict_type VALUES ('通知类型', 'sys_notice_type', '0', 'admin', '2021-02-24 10:55:26', '', NULL, '通知类型列表');
INSERT INTO sys_dict_type VALUES ('通知状态', 'sys_notice_status', '0', 'admin', '2021-02-24 10:55:26', '', NULL, '通知状态列表');
INSERT INTO sys_dict_type VALUES ('操作类型', 'sys_oper_type', '0', 'admin', '2021-02-24 10:55:26', '', NULL, '操作类型列表');
INSERT INTO sys_dict_type VALUES ('系统状态', 'sys_common_status', '0', 'admin', '2021-02-24 10:55:27', '', NULL, '登录状态列表');
INSERT INTO sys_dict_type VALUES ('文章状态', 'sys_article_status', '0', 'admin', '2021-08-19 10:34:33', '', NULL, NULL);
GO
/**字典数据表*/
CREATE TABLE sys_dict_data  (
  dictCode bigint NOT NULL IDENTITY(1,1) PRIMARY KEY , --'字典编码',
  dictSort int NULL DEFAULT 0 ,							-- '字典排序',
  dictLabel varchar(100)  NULL DEFAULT '' ,				-- '字典标签',
  dictValue varchar(100)  NULL DEFAULT '' ,				-- '字典键值',
  dictType varchar(100)  NULL DEFAULT '' ,				-- '字典类型',
  cssClass varchar(100)  NULL DEFAULT NULL ,			-- '样式属性（其他样式扩展）',
  listClass varchar(100)  NULL DEFAULT NULL ,-- '表格回显样式',
  isDefault varchar(1)  NULL DEFAULT 'N' ,-- '是否默认（Y是 N否）',
  status varchar(1)  NULL DEFAULT '0' ,-- '状态（0正常 1停用）',
  create_by varchar(64)  NULL DEFAULT '' ,-- '创建者',
  create_time datetime NULL DEFAULT NULL ,-- '创建时间',
  update_by varchar(64)  NULL DEFAULT '' ,-- '更新者',
  update_time datetime NULL DEFAULT NULL ,-- '更新时间',
  remark varchar(500)  NULL DEFAULT NULL ,-- '备注',
)
GO

INSERT INTO sys_dict_data VALUES (1, '男', '0', 'sys_user_sex', '', '', 'Y', '0', 'admin', '2021-02-24 10:56:21', '', NULL, '性别男');
INSERT INTO sys_dict_data VALUES (2, '女', '1', 'sys_user_sex', '', '', 'N', '0', 'admin', '2021-02-24 10:56:21', '', NULL, '性别女');
INSERT INTO sys_dict_data VALUES (3, '未知', '2', 'sys_user_sex', '', '', 'N', '0', 'admin', '2021-02-24 10:56:21', '', NULL, '性别未知');
INSERT INTO sys_dict_data VALUES (1, '显示', '0', 'sys_show_hide', '', 'primary', 'Y', '0', 'admin', '2021-02-24 10:56:21', '', NULL, '显示菜单');
INSERT INTO sys_dict_data VALUES (2, '隐藏', '1', 'sys_show_hide', '', 'danger', 'N', '0', 'admin', '2021-02-24 10:56:21', '', NULL, '隐藏菜单');
INSERT INTO sys_dict_data VALUES (1, '正常', '0', 'sys_normal_disable', '', 'primary', 'Y', '0', 'admin', '2021-02-24 10:56:21', '', NULL, '正常状态');
INSERT INTO sys_dict_data VALUES (2, '停用', '1', 'sys_normal_disable', '', 'danger', 'N', '0', 'admin', '2021-02-24 10:56:21', '', NULL, '停用状态');
INSERT INTO sys_dict_data VALUES (1, '正常', '0', 'sys_job_status', '', 'primary', 'Y', '0', 'admin', '2021-02-24 10:56:21', '', NULL, '正常状态');
INSERT INTO sys_dict_data VALUES (2, '异常', '1', 'sys_job_status', '', 'danger', 'N', '0', 'admin', '2021-02-24 10:56:21', '', '2021-07-02 14:09:09', '停用状态');
INSERT INTO sys_dict_data VALUES ( 1, '默认', 'DEFAULT', 'sys_job_group', '', '', 'Y', '0', 'admin', '2021-02-24 10:56:21', '', NULL, '默认分组');
INSERT INTO sys_dict_data VALUES ( 2, '系统', 'SYSTEM', 'sys_job_group', '', '', 'N', '0', 'admin', '2021-02-24 10:56:21', '', NULL, '系统分组');
INSERT INTO sys_dict_data VALUES ( 1, '是', 'Y', 'sys_yes_no', '', 'primary', 'Y', '0', 'admin', '2021-02-24 10:56:21', '', NULL, '系统默认是');
INSERT INTO sys_dict_data VALUES ( 2, '否', 'N', 'sys_yes_no', '', 'danger', 'N', '0', 'admin', '2021-02-24 10:56:21', '', NULL, '系统默认否');
INSERT INTO sys_dict_data VALUES ( 1, '通知', '1', 'sys_notice_type', '', 'warning', 'Y', '0', 'admin', '2021-02-24 10:56:22', '', NULL, '通知');
INSERT INTO sys_dict_data VALUES ( 2, '公告', '2', 'sys_notice_type', '', 'success', 'N', '0', 'admin', '2021-02-24 10:56:22', '', NULL, '公告');
INSERT INTO sys_dict_data VALUES ( 1, '正常', '0', 'sys_notice_status', '', 'primary', 'Y', '0', 'admin', '2021-02-24 10:56:22', '', NULL, '正常状态');
INSERT INTO sys_dict_data VALUES ( 2, '关闭', '1', 'sys_notice_status', '', 'danger', 'N', '0', 'admin', '2021-02-24 10:56:22', '', NULL, '关闭状态');
INSERT INTO sys_dict_data VALUES ( 1, '新增', '1', 'sys_oper_type', '', 'info', 'N', '0', 'admin', '2021-02-24 10:56:22', '', NULL, '新增操作');
INSERT INTO sys_dict_data VALUES ( 2, '修改', '2', 'sys_oper_type', '', 'info', 'N', '0', 'admin', '2021-02-24 10:56:22', '', NULL, '修改操作');
INSERT INTO sys_dict_data VALUES ( 3, '删除', '3', 'sys_oper_type', '', 'danger', 'N', '0', 'admin', '2021-02-24 10:56:22', '', NULL, '删除操作');
INSERT INTO sys_dict_data VALUES ( 4, '授权', '4', 'sys_oper_type', '', 'primary', 'N', '0', 'admin', '2021-02-24 10:56:22', '', NULL, '授权操作');
INSERT INTO sys_dict_data VALUES ( 5, '导出', '5', 'sys_oper_type', '', 'warning', 'N', '0', 'admin', '2021-02-24 10:56:22', '', NULL, '导出操作');
INSERT INTO sys_dict_data VALUES ( 6, '导入', '6', 'sys_oper_type', '', 'warning', 'N', '0', 'admin', '2021-02-24 10:56:22', '', NULL, '导入操作');
INSERT INTO sys_dict_data VALUES ( 7, '强退', '7', 'sys_oper_type', '', 'danger', 'N', '0', 'admin', '2021-02-24 10:56:22', '', NULL, '强退操作');
INSERT INTO sys_dict_data VALUES ( 8, '生成代码', '8', 'sys_oper_type', '', 'warning', 'N', '0', 'admin', '2021-02-24 10:56:22', '', NULL, '生成操作');
INSERT INTO sys_dict_data VALUES ( 9, '清空数据', '9', 'sys_oper_type', '', 'danger', 'N', '0', 'admin', '2021-02-24 10:56:22', '', NULL, '清空操作');
INSERT INTO sys_dict_data VALUES ( 1, '成功', '0', 'sys_common_status', '', 'primary', 'N', '0', 'admin', '2021-02-24 10:56:23', '', NULL, '正常状态');
INSERT INTO sys_dict_data VALUES ( 2, '失败', '1', 'sys_common_status', '', 'danger', 'N', '0', 'admin', '2021-02-24 10:56:23', '', NULL, '停用状态');
INSERT INTO sys_dict_data VALUES ( 1, '发布', '1', 'sys_article_status', NULL, NULL, NULL, '0', 'admin', '2021-08-19 10:34:56', '', NULL, NULL);
INSERT INTO sys_dict_data VALUES ( 2, '草稿', '2', 'sys_article_status', NULL, NULL, NULL, '0', 'admin', '2021-08-19 10:35:06', '', NULL, NULL);
GO
CREATE TABLE sys_logininfor  (
  infoId bigint NOT NULL PRIMARY KEY IDENTITY(1,1) ,-- '访问ID',
  userName varchar(50)  NULL DEFAULT '' ,-- '用户账号',
  ipaddr varchar(50)  NULL DEFAULT '' ,-- '登录IP地址',
  loginLocation varchar(255)  NULL DEFAULT '' ,-- '登录地点',
  browser varchar(50)  NULL DEFAULT '' ,-- '浏览器类型',
  os varchar(50)  NULL DEFAULT '' ,-- '操作系统',
  status char(1)  NULL DEFAULT '0' ,-- '登录状态（0成功 1失败）',
  msg varchar(255)  NULL DEFAULT '' ,-- '提示消息',
  loginTime DATETIME NULL DEFAULT NULL  ,-- '访问时间',
  
) 
GO
CREATE TABLE sys_menu  (
  menuId bigint NOT NULL PRIMARY KEY IDENTITY(1,1) ,-- '菜单ID',
  menuName varchar(50)  NOT NULL ,-- '菜单名称',
  parentId bigint NULL DEFAULT 0 ,-- '父菜单ID',
  orderNum int NULL DEFAULT 0 ,-- '显示顺序',
  path varchar(200)  NULL DEFAULT '' ,-- '路由地址',
  component varchar(255)  NULL DEFAULT NULL ,-- '组件路径',
  isFrame int NULL DEFAULT 0 ,-- '是否外链(0 否 1 是)',
  isCache int NULL DEFAULT 0 ,-- '是否缓存(0缓存 1不缓存)',
  menuType char(1)  NULL DEFAULT '' ,-- '菜单类型（M目录 C菜单 F按钮 L链接）',
  visible char(1)  NULL DEFAULT '0' ,-- '菜单状态（0显示 1隐藏）',
  status char(1)  NULL DEFAULT '0' ,-- '菜单状态（0正常 1停用）',
  perms varchar(100)  NULL DEFAULT NULL ,-- '权限标识',
  icon varchar(100)  NULL DEFAULT '#' ,-- '菜单图标',
  create_by varchar(64)  NULL DEFAULT '' ,-- '创建者',
  create_time datetime NULL DEFAULT NULL ,-- '创建时间',
  update_by varchar(64)  NULL DEFAULT '' ,-- '更新者',
  update_time datetime NULL DEFAULT NULL ,-- '更新时间',
  remark varchar(500)  NULL DEFAULT '' ,-- '备注',
) 
GO
SET IDENTITY_INSERT sys_menu ON
--INSERT INTO sys_menu(menuId, menuName, parentId, orderNum, path, component, isFrame, isCache, menuType, visible, status, perms, icon, create_by,create_time, update_by, update_time, remark) VALUES (1, '系统管理', 0, 2, 'system', NULL, 0, 0, 'M', '0', '0', '', 'system', 'admin', '2020-11-26 11:53:26', 'admin', '2021-07-13 15:47:55', '系统管理目录');
INSERT INTO sys_menu(menuId, menuName, parentId, orderNum, path, component, isFrame, isCache, menuType, visible, status, perms, icon, create_by,create_time, update_by, update_time, remark) VALUES (2, '系统监控', 0, 3, 'monitor', NULL, 0, 0, 'M', '0', '0', '', 'monitor', 'admin', '2020-11-26 11:53:26', '', NULL, '系统监控目录');
INSERT INTO sys_menu(menuId, menuName, parentId, orderNum, path, component, isFrame, isCache, menuType, visible, status, perms, icon, create_by,create_time, update_by, update_time, remark) VALUES (3, '系统工具', 0, 6, 'tool', NULL, 0, 0, 'M', '0', '0', '', 'tool', 'admin', '2020-11-26 11:53:26', 'admin', '2021-08-17 17:35:10', '系统工具目录');
INSERT INTO sys_menu(menuId, menuName, parentId, orderNum, path, component, isFrame, isCache, menuType, visible, status, perms, icon, create_by,create_time, update_by, update_time, remark) VALUES (4, '外部打开', 0, 1, 'http://www.izhaorui.cn', NULL, 1, 0, 'M', '0', '0', '', 'link', 'admin', '2020-11-26 11:53:26', 'admin', '2021-08-23 14:04:22', '若依官网地址');
INSERT INTO sys_menu(menuId, menuName, parentId, orderNum, path, component, isFrame, isCache, menuType, visible, status, perms, icon, create_by,create_time, update_by, update_time, remark) VALUES (100, '用户管理', 1, 2, 'user', 'system/user/index', 0, 0, 'C', '0', '0', 'system:user:list', 'user', 'admin', '2020-11-26 11:53:26', '', NULL, '用户管理菜单');
INSERT INTO sys_menu(menuId, menuName, parentId, orderNum, path, component, isFrame, isCache, menuType, visible, status, perms, icon, create_by,create_time, update_by, update_time, remark) VALUES (101, '权限管理', 1, 2, 'role', 'system/role/index', 0, 0, 'C', '0', '0', 'system:role:list', 'peoples', 'admin', '2020-11-26 11:53:26', 'admin', '2021-07-12 16:06:03', '角色管理菜单');
INSERT INTO sys_menu(menuId, menuName, parentId, orderNum, path, component, isFrame, isCache, menuType, visible, status, perms, icon, create_by,create_time, update_by, update_time, remark) VALUES (102, '菜单管理', 1, 3, 'menu', 'system/menu/index', 0, 0, 'C', '0', '0', 'system:menu:list', 'tree-table', 'admin', '2020-11-26 11:53:26', '', NULL, '菜单管理菜单');
INSERT INTO sys_menu(menuId, menuName, parentId, orderNum, path, component, isFrame, isCache, menuType, visible, status, perms, icon, create_by,create_time, update_by, update_time, remark) VALUES (103, '部门管理', 1, 4, 'dept', 'system/dept/index', 0, 0, 'C', '0', '0', 'system:dept:list', 'tree', 'admin', '2021-04-20 20:51:29', 'admin', '2021-07-07 14:04:49', '部门管理菜单');
INSERT INTO sys_menu(menuId, menuName, parentId, orderNum, path, component, isFrame, isCache, menuType, visible, status, perms, icon, create_by,create_time, update_by, update_time, remark) VALUES (104, '岗位管理', 1, 5, 'post', 'system/post/index', 0, 0, 'C', '0', '0', 'system:post:list', 'post', 'admin', '2021-04-20 20:51:29', 'admin', '2021-07-07 14:09:19', '岗位管理菜单');
INSERT INTO sys_menu(menuId, menuName, parentId, orderNum, path, component, isFrame, isCache, menuType, visible, status, perms, icon, create_by,create_time, update_by, update_time, remark) VALUES (108, '日志管理', 1, 9, 'log', '', 0, 0, 'M', '0', '0', '', 'log', 'admin', '2020-11-26 11:53:26', '', NULL, '日志管理菜单');
INSERT INTO sys_menu(menuId, menuName, parentId, orderNum, path, component, isFrame, isCache, menuType, visible, status, perms, icon, create_by,create_time, update_by, update_time, remark) VALUES (110, '定时任务', 2, 1, 'job', 'monitor/job/index', 0, 0, 'C', '0', '0', '', 'job', 'admin', '2020-11-26 11:53:27', 'admin', '2021-08-10 18:26:15', '定时任务菜单');
INSERT INTO sys_menu(menuId, menuName, parentId, orderNum, path, component, isFrame, isCache, menuType, visible, status, perms, icon, create_by,create_time, update_by, update_time, remark) VALUES (112, '服务监控', 2, 4, 'server', 'monitor/server/index', 0, 0, 'C', '0', '0', 'monitor:server:list', 'server', 'admin', '2020-11-26 11:53:27', '', '2021-04-20 19:53:22', '服务监控菜单');
INSERT INTO sys_menu(menuId, menuName, parentId, orderNum, path, component, isFrame, isCache, menuType, visible, status, perms, icon, create_by,create_time, update_by, update_time, remark) VALUES (113, '缓存监控', 2, 5, 'cache', 'monitor/cache/index', 0, 0, 'C', '1', '1', 'monitor:cache:list', 'redis', 'admin', '2020-11-26 11:53:27', '', '2021-04-20 19:53:30', '缓存监控菜单');
INSERT INTO sys_menu(menuId, menuName, parentId, orderNum, path, component, isFrame, isCache, menuType, visible, status, perms, icon, create_by,create_time, update_by, update_time, remark) VALUES (114, '表单构建', 3, 1, 'build', 'tool/build/index', 0, 0, 'C', '0', '0', 'tool:build:list', 'build', 'admin', '2020-11-26 11:53:27', '', NULL, '表单构建菜单');
INSERT INTO sys_menu(menuId, menuName, parentId, orderNum, path, component, isFrame, isCache, menuType, visible, status, perms, icon, create_by,create_time, update_by, update_time, remark) VALUES (116, '系统接口', 3, 3, 'swagger', 'tool/swagger/index', 0, 0, 'C', '0', '0', 'tool:swagger:list', 'swagger', 'admin', '2020-11-26 11:53:27', '', NULL, '系统接口菜单');
INSERT INTO sys_menu(menuId, menuName, parentId, orderNum, path, component, isFrame, isCache, menuType, visible, status, perms, icon, create_by,create_time, update_by, update_time, remark) VALUES (500, '操作日志', 108, 1, 'operlog', 'monitor/operlog/index', 0, 0, 'C', '0', '0', 'monitor:operlog:list', 'form', 'admin', '2020-11-26 11:53:27', '', NULL, '操作日志菜单');
INSERT INTO sys_menu(menuId, menuName, parentId, orderNum, path, component, isFrame, isCache, menuType, visible, status, perms, icon, create_by,create_time, update_by, update_time, remark) VALUES (501, '登录日志', 108, 2, 'logininfor', 'monitor/logininfor/index', 0, 0, 'C', '0', '0', 'monitor:logininfor:list', 'logininfor', 'admin', '2020-11-26 11:53:27', '', NULL, '登录日志菜单');
INSERT INTO sys_menu(menuId, menuName, parentId, orderNum, path, component, isFrame, isCache, menuType, visible, status, perms, icon, create_by,create_time, update_by, update_time, remark) VALUES (1005, '用户导出', 100, 5, '', '', 0, 0, 'F', '0', '0', 'system:user:export', '#', 'admin', '2021-03-01 18:21:35', '', NULL, '');
INSERT INTO sys_menu(menuId, menuName, parentId, orderNum, path, component, isFrame, isCache, menuType, visible, status, perms, icon, create_by,create_time, update_by, update_time, remark) VALUES (1006, '用户导入', 100, 6, '', '', 0, 0, 'F', '0', '0', 'system:user:import', '#', 'admin', '2021-03-01 18:21:36', '', NULL, '');
INSERT INTO sys_menu(menuId, menuName, parentId, orderNum, path, component, isFrame, isCache, menuType, visible, status, perms, icon, create_by,create_time, update_by, update_time, remark) VALUES (1007, '重置密码', 100, 7, '', '', 0, 0, 'F', '0', '0', 'system:user:resetPwd', '#', 'admin', '2021-03-01 18:21:36', '', NULL, '');
INSERT INTO sys_menu(menuId, menuName, parentId, orderNum, path, component, isFrame, isCache, menuType, visible, status, perms, icon, create_by,create_time, update_by, update_time, remark) VALUES (1008, '角色查询', 101, 1, '', '', 0, 0, 'F', '0', '0', 'system:role:query', '#', 'admin', '2021-03-01 18:22:24', 'admin', '2021-07-07 14:27:17', '');
INSERT INTO sys_menu(menuId, menuName, parentId, orderNum, path, component, isFrame, isCache, menuType, visible, status, perms, icon, create_by,create_time, update_by, update_time, remark) VALUES (1009, '角色新增', 101, 2, '', '', 0, 0, 'F', '0', '0', 'system:role:add', '#', 'admin', '2021-03-01 18:22:24', '', NULL, '');
INSERT INTO sys_menu(menuId, menuName, parentId, orderNum, path, component, isFrame, isCache, menuType, visible, status, perms, icon, create_by,create_time, update_by, update_time, remark) VALUES (1010, '角色修改', 101, 3, '', '', 0, 0, 'F', '0', '0', 'system:role:edit', '#', 'admin', '2021-03-01 18:22:24', '', NULL, '');
INSERT INTO sys_menu(menuId, menuName, parentId, orderNum, path, component, isFrame, isCache, menuType, visible, status, perms, icon, create_by,create_time, update_by, update_time, remark) VALUES (1011, '角色删除', 101, 4, '', '', 0, 0, 'F', '0', '0', 'system:role:remove', '#', 'admin', '2021-03-01 18:22:24', '', NULL, '');
INSERT INTO sys_menu(menuId, menuName, parentId, orderNum, path, component, isFrame, isCache, menuType, visible, status, perms, icon, create_by,create_time, update_by, update_time, remark) VALUES (1012, '角色导出', 101, 5, '', '', 0, 0, 'F', '0', '0', 'system:role:export', '#', 'admin', '2021-03-01 18:22:24', '', NULL, '');
INSERT INTO sys_menu(menuId, menuName, parentId, orderNum, path, component, isFrame, isCache, menuType, visible, status, perms, icon, create_by,create_time, update_by, update_time, remark) VALUES (1013, '菜单查询', 102, 1, '', '', 0, 0, 'F', '0', '0', 'system:menu:query', '#', 'admin', '2021-03-01 18:22:24', '', NULL, '');
INSERT INTO sys_menu(menuId, menuName, parentId, orderNum, path, component, isFrame, isCache, menuType, visible, status, perms, icon, create_by,create_time, update_by, update_time, remark) VALUES (1014, '菜单新增', 102, 2, '', '', 0, 0, 'F', '0', '0', 'system:menu:add', '#', 'admin', '2021-03-01 18:22:24', '', NULL, '');
INSERT INTO sys_menu(menuId, menuName, parentId, orderNum, path, component, isFrame, isCache, menuType, visible, status, perms, icon, create_by,create_time, update_by, update_time, remark) VALUES (1015, '菜单修改', 102, 3, '', '', 0, 0, 'F', '0', '0', 'system:menu:edit', '#', 'admin', '2021-03-01 18:22:24', '', NULL, '');
INSERT INTO sys_menu(menuId, menuName, parentId, orderNum, path, component, isFrame, isCache, menuType, visible, status, perms, icon, create_by,create_time, update_by, update_time, remark) VALUES (1016, '菜单删除', 102, 4, '', '', 0, 0, 'F', '0', '0', 'system:menu:remove', '#', 'admin', '2021-03-01 18:22:24', '', NULL, '');
INSERT INTO sys_menu(menuId, menuName, parentId, orderNum, path, component, isFrame, isCache, menuType, visible, status, perms, icon, create_by,create_time, update_by, update_time, remark) VALUES (2013, '控制台', 0, 0, 'dashboard', 'index_v1', 0, 0, 'C', '0', '0', '', 'dashboard', '', '2021-01-08 17:47:35', 'admin', '2021-08-16 14:31:11', '');
INSERT INTO sys_menu(menuId, menuName, parentId, orderNum, path, component, isFrame, isCache, menuType, visible, status, perms, icon, create_by,create_time, update_by, update_time, remark) VALUES (2018, '用户添加', 100, 2, '#', NULL, 0, 0, 'F', '0', '0', 'system:user:add', '', '', '2021-02-24 10:30:37', '', NULL, '');
INSERT INTO sys_menu(menuId, menuName, parentId, orderNum, path, component, isFrame, isCache, menuType, visible, status, perms, icon, create_by,create_time, update_by, update_time, remark) VALUES (2019, '用户查询', 100, 1, '#', NULL, 0, 0, 'F', '0', '0', 'system:user:query', '', '', '2021-02-24 10:31:33', '', NULL, '');
INSERT INTO sys_menu(menuId, menuName, parentId, orderNum, path, component, isFrame, isCache, menuType, visible, status, perms, icon, create_by,create_time, update_by, update_time, remark) VALUES (2020, '用户删除', 100, 4, '#', NULL, 0, 0, 'F', '0', '0', 'system:user:delete', '', '', '2021-02-24 10:32:01', '', NULL, '');
INSERT INTO sys_menu(menuId, menuName, parentId, orderNum, path, component, isFrame, isCache, menuType, visible, status, perms, icon, create_by,create_time, update_by, update_time, remark) VALUES (2021, '字典管理', 1, 5, 'dict', 'system/dict/index', 0, 0, 'C', '0', '0', 'system:dict:list', 'dict', '', '2021-02-24 10:37:50', 'admin', '2021-07-07 13:57:59', '');
INSERT INTO sys_menu(menuId, menuName, parentId, orderNum, path, component, isFrame, isCache, menuType, visible, status, perms, icon, create_by,create_time, update_by, update_time, remark) VALUES (2029, '用户角色', 1, 3, 'roleusers', 'system/roleusers/index', 0, 0, 'C', '0', '0', 'system:role:list', 'people', 'admin', '2021-04-04 18:44:25', 'admin', '2021-07-13 15:39:01', NULL);
INSERT INTO sys_menu(menuId, menuName, parentId, orderNum, path, component, isFrame, isCache, menuType, visible, status, perms, icon, create_by,create_time, update_by, update_time, remark) VALUES (2030, '修改排序', 102, 999, '#', NULL, 0, 0, 'F', '0', '0', 'system:menu:changeSort', '', 'admin', '2021-06-30 17:05:08', 'admin', '2021-06-30 17:07:06', NULL);
INSERT INTO sys_menu(menuId, menuName, parentId, orderNum, path, component, isFrame, isCache, menuType, visible, status, perms, icon, create_by,create_time, update_by, update_time, remark) VALUES (2031, '新增用户', 2029, 1, '#', NULL, 0, 0, 'F', '0', '0', 'system:roleusers:add', NULL, 'admin', '2021-06-30 17:08:12', '', NULL, NULL);
INSERT INTO sys_menu(menuId, menuName, parentId, orderNum, path, component, isFrame, isCache, menuType, visible, status, perms, icon, create_by,create_time, update_by, update_time, remark) VALUES (2032, '删除用户', 2029, 2, '#', NULL, 0, 0, 'F', '0', '0', 'system:roleusers:del', NULL, 'admin', '2021-06-30 17:08:48', '', NULL, NULL);
INSERT INTO sys_menu(menuId, menuName, parentId, orderNum, path, component, isFrame, isCache, menuType, visible, status, perms, icon, create_by,create_time, update_by, update_time, remark) VALUES (2033, '新增', 110, 2, '#', NULL, 0, 0, 'F', '0', '0', 'system:task:add', '', 'admin', '2021-07-02 21:02:06', 'admin', '2021-07-02 21:50:05', NULL);
INSERT INTO sys_menu(menuId, menuName, parentId, orderNum, path, component, isFrame, isCache, menuType, visible, status, perms, icon, create_by,create_time, update_by, update_time, remark) VALUES (2034, '删除', 110, 2, '#', NULL, 0, 0, 'F', '0', '0', 'system:task:delete', '', 'admin', '2021-07-02 21:02:42', 'admin', '2021-07-02 21:49:57', NULL);
INSERT INTO sys_menu(menuId, menuName, parentId, orderNum, path, component, isFrame, isCache, menuType, visible, status, perms, icon, create_by,create_time, update_by, update_time, remark) VALUES (2035, '修改', 110, 3, '#', NULL, 0, 0, 'F', '0', '0', 'system:task:edit', '', 'admin', '2021-07-02 21:03:09', 'admin', '2021-07-02 21:49:53', NULL);
INSERT INTO sys_menu(menuId, menuName, parentId, orderNum, path, component, isFrame, isCache, menuType, visible, status, perms, icon, create_by,create_time, update_by, update_time, remark) VALUES (2036, '启动', 110, 4, '#', NULL, 0, 0, 'F', '0', '0', 'system:task:start', '', 'admin', '2021-07-02 21:03:48', 'admin', '2021-07-02 21:49:49', NULL);
INSERT INTO sys_menu(menuId, menuName, parentId, orderNum, path, component, isFrame, isCache, menuType, visible, status, perms, icon, create_by,create_time, update_by, update_time, remark) VALUES (2037, '查询', 110, 1, '#', NULL, 0, 0, 'F', '0', '0', 'system:task:list', '', 'admin', '2021-07-02 21:06:36', 'admin', '2021-07-02 21:50:10', NULL);
INSERT INTO sys_menu(menuId, menuName, parentId, orderNum, path, component, isFrame, isCache, menuType, visible, status, perms, icon, create_by,create_time, update_by, update_time, remark) VALUES (2038, '运行', 110, 5, '#', NULL, 0, 0, 'F', '0', '0', 'system:task:run', NULL, 'admin', '2021-07-02 21:49:39', '', NULL, NULL);
INSERT INTO sys_menu(menuId, menuName, parentId, orderNum, path, component, isFrame, isCache, menuType, visible, status, perms, icon, create_by,create_time, update_by, update_time, remark) VALUES (2039, '停止', 110, 4, '#', NULL, 0, 0, 'F', '0', '0', 'system:task:stop', NULL, 'admin', '2021-07-02 21:51:18', '', NULL, NULL);
INSERT INTO sys_menu(menuId, menuName, parentId, orderNum, path, component, isFrame, isCache, menuType, visible, status, perms, icon, create_by,create_time, update_by, update_time, remark) VALUES (2040, '查询', 103, 1, '#', NULL, 0, 0, 'F', '0', '0', 'system:dept:query', '', 'admin', '2021-07-05 17:16:52', 'admin', '2021-07-07 14:06:24', NULL);
INSERT INTO sys_menu(menuId, menuName, parentId, orderNum, path, component, isFrame, isCache, menuType, visible, status, perms, icon, create_by,create_time, update_by, update_time, remark) VALUES (2041, '新增', 103, 2, '#', NULL, 0, 0, 'F', '0', '0', 'system:dept:add', NULL, 'admin', '2021-07-05 17:17:26', '', NULL, NULL);
INSERT INTO sys_menu(menuId, menuName, parentId, orderNum, path, component, isFrame, isCache, menuType, visible, status, perms, icon, create_by,create_time, update_by, update_time, remark) VALUES (2042, '修改', 103, 3, '#', NULL, 0, 0, 'F', '0', '0', 'system:dept:update', NULL, 'admin', '2021-07-05 17:17:49', '', NULL, NULL);
INSERT INTO sys_menu(menuId, menuName, parentId, orderNum, path, component, isFrame, isCache, menuType, visible, status, perms, icon, create_by,create_time, update_by, update_time, remark) VALUES (2043, '删除', 103, 4, '#', NULL, 0, 0, 'F', '0', '0', 'system:dept:remove', NULL, 'admin', '2021-07-05 17:18:15', '', NULL, NULL);
INSERT INTO sys_menu(menuId, menuName, parentId, orderNum, path, component, isFrame, isCache, menuType, visible, status, perms, icon, create_by,create_time, update_by, update_time, remark) VALUES (2044, '查询', 104, 1, '#', NULL, 0, 0, 'F', '0', '0', 'system:post:list', NULL, 'admin', '2021-07-05 17:20:52', '', NULL, NULL);
INSERT INTO sys_menu(menuId, menuName, parentId, orderNum, path, component, isFrame, isCache, menuType, visible, status, perms, icon, create_by,create_time, update_by, update_time, remark) VALUES (2045, '添加', 104, 2, '#', NULL, 0, 0, 'F', '0', '0', 'system:post:add', NULL, 'admin', '2021-07-05 17:21:26', '', NULL, NULL);
INSERT INTO sys_menu(menuId, menuName, parentId, orderNum, path, component, isFrame, isCache, menuType, visible, status, perms, icon, create_by,create_time, update_by, update_time, remark) VALUES (2046, '岗位删除', 104, 3, '#', NULL, 0, 0, 'F', '0', '0', 'system:post:remove', NULL, 'admin', '2021-07-05 17:21:48', '', NULL, NULL);
INSERT INTO sys_menu(menuId, menuName, parentId, orderNum, path, component, isFrame, isCache, menuType, visible, status, perms, icon, create_by,create_time, update_by, update_time, remark) VALUES (2047, '岗位编辑', 104, 4, '#', NULL, 0, 0, 'F', '0', '0', 'system:post:edit', '', 'admin', '2021-07-05 17:27:25', 'admin', '2021-07-07 14:28:45', NULL);
INSERT INTO sys_menu(menuId, menuName, parentId, orderNum, path, component, isFrame, isCache, menuType, visible, status, perms, icon, create_by,create_time, update_by, update_time, remark) VALUES (2048, '删除日志', 500, 1, '#', NULL, 0, 0, 'F', '0', '0', 'monitor:operlog:remove', NULL, 'admin', '2021-07-07 13:44:46', '', NULL, NULL);
INSERT INTO sys_menu(menuId, menuName, parentId, orderNum, path, component, isFrame, isCache, menuType, visible, status, perms, icon, create_by,create_time, update_by, update_time, remark) VALUES (2049, '删除日志', 501, 1, '#', NULL, 0, 0, 'F', '0', '0', 'monitor:logininfor:remove', '', 'admin', '2021-07-07 13:45:34', 'admin', '2021-07-07 13:45:52', NULL);
INSERT INTO sys_menu(menuId, menuName, parentId, orderNum, path, component, isFrame, isCache, menuType, visible, status, perms, icon, create_by,create_time, update_by, update_time, remark) VALUES (2050, '新增', 2021, 1, '#', NULL, 0, 0, 'F', '0', '0', 'system:dict:add', NULL, 'admin', '2021-07-07 13:47:51', '', NULL, NULL);
INSERT INTO sys_menu(menuId, menuName, parentId, orderNum, path, component, isFrame, isCache, menuType, visible, status, perms, icon, create_by,create_time, update_by, update_time, remark) VALUES (2051, '修改', 2021, 2, '#', NULL, 0, 0, 'F', '0', '0', 'system:dict:edit', NULL, 'admin', '2021-07-07 13:48:11', '', NULL, NULL);
INSERT INTO sys_menu(menuId, menuName, parentId, orderNum, path, component, isFrame, isCache, menuType, visible, status, perms, icon, create_by,create_time, update_by, update_time, remark) VALUES (2052, '删除', 2021, 3, '#', NULL, 0, 0, 'F', '0', '0', 'system:dict:remove', NULL, 'admin', '2021-07-07 13:48:28', '', NULL, NULL);
INSERT INTO sys_menu(menuId, menuName, parentId, orderNum, path, component, isFrame, isCache, menuType, visible, status, perms, icon, create_by,create_time, update_by, update_time, remark) VALUES (2053, '查询', 2029, 3, '#', NULL, 0, 0, 'F', '0', '0', 'system:roleusers:query', '', 'admin', '2021-07-07 13:57:02', 'admin', '2021-07-07 13:57:21', NULL);
INSERT INTO sys_menu(menuId, menuName, parentId, orderNum, path, component, isFrame, isCache, menuType, visible, status, perms, icon, create_by,create_time, update_by, update_time, remark) VALUES (2054, '用户修改', 100, 3, '#', NULL, 0, 0, 'F', '0', '0', 'system:user:edit', '', 'admin', '2021-07-07 14:19:33', 'admin', '2021-07-07 14:21:32', NULL);
INSERT INTO sys_menu(menuId, menuName, parentId, orderNum, path, component, isFrame, isCache, menuType, visible, status, perms, icon, create_by,create_time, update_by, update_time, remark) VALUES (2055, '文章管理', 0, 4, 'article', NULL, 0, 0, 'M', '0', '0', NULL, 'documentation', 'admin', '2021-08-10 16:07:24', 'admin', '2021-08-17 18:32:43', NULL);
INSERT INTO sys_menu(menuId, menuName, parentId, orderNum, path, component, isFrame, isCache, menuType, visible, status, perms, icon, create_by,create_time, update_by, update_time, remark) VALUES (2056, '创建文章', 2055, 999, 'publish', 'article/publish', 0, 0, 'C', '1', '0', 'system:article:publish', 'log', 'admin', '2021-08-10 16:09:40', 'admin', '2021-08-18 18:18:33', NULL);
INSERT INTO sys_menu(menuId, menuName, parentId, orderNum, path, component, isFrame, isCache, menuType, visible, status, perms, icon, create_by,create_time, update_by, update_time, remark) VALUES (2057, '文章列表', 2055, 999, 'manager', 'article/manager', 0, 0, 'C', '0', '0', 'system:article:list', 'documentation', 'admin', '2021-08-10 16:18:39', 'admin', '2021-08-17 18:32:57', NULL);
INSERT INTO sys_menu(menuId, menuName, parentId, orderNum, path, component, isFrame, isCache, menuType, visible, status, perms, icon, create_by,create_time, update_by, update_time, remark) VALUES (2060, '任务日志', 2, 2, '/job/log', 'monitor/job/log', 0, 0, 'C', '0', '0', NULL, 'log', 'admin', '2021-08-10 18:24:23', 'admin', '2021-08-10 18:27:59', NULL);
INSERT INTO sys_menu(menuId, menuName, parentId, orderNum, path, component, isFrame, isCache, menuType, visible, status, perms, icon, create_by,create_time, update_by, update_time, remark) VALUES (2062, '新增', 2057, 1, '#', NULL, 0, 0, 'F', '0', '0', 'system:article:add', '', 'admin', '2021-08-18 17:27:18', 'admin', '2021-08-18 17:31:13', NULL);
INSERT INTO sys_menu(menuId, menuName, parentId, orderNum, path, component, isFrame, isCache, menuType, visible, status, perms, icon, create_by,create_time, update_by, update_time, remark) VALUES (2063, '修改', 2057, 2, '#', NULL, 0, 0, 'F', '0', '0', 'system:article:update', '', 'admin', '2021-08-18 17:35:55', '', NULL, NULL);
INSERT INTO sys_menu(menuId, menuName, parentId, orderNum, path, component, isFrame, isCache, menuType, visible, status, perms, icon, create_by,create_time, update_by, update_time, remark) VALUES (2064, '删除', 2057, 3, '#', NULL, 0, 0, 'F', '0', '0', 'system:article:delete', '', 'admin', '2021-08-18 17:36:17', '', NULL, NULL);
SET IDENTITY_INSERT sys_menu OFF
GO

-- ---------------------------- 
-- = '操作日志记录' 
-- Table structure for sys_oper_log
-- ----------------------------
CREATE TABLE sys_oper_log  (
  operId bigint NOT NULL PRIMARY KEY IDENTITY(1,1),--'日志主键',
  title varchar(50)  DEFAULT '' , -- '模块标题',
  businessType int NULL DEFAULT 0 , -- '业务类型（0其它 1新增 2修改 3删除）',
  method varchar(100)  DEFAULT '' , -- '方法名称',
  requestMethod varchar(10)  DEFAULT '' , -- '请求方式',
  operatorType int NULL DEFAULT 0 , -- '操作类别（0其它 1后台用户 2手机端用户）',
  operName varchar(50)  DEFAULT '' , -- '操作人员',
  deptName varchar(50)  DEFAULT '' , -- '部门名称',
  operUrl varchar(255)  DEFAULT '' , -- '请求URL',
  operIP varchar(50)  DEFAULT '' , -- '主机地址',
  operLocation varchar(255)  DEFAULT '' , -- '操作地点',
  operParam varchar(2000)  DEFAULT '' , -- '请求参数',
  jsonResult varchar(2000)  DEFAULT '' , -- '返回参数',
  status int NULL DEFAULT 0 , -- '操作状态（0正常 1异常）',
  errorMsg varchar(2000)  DEFAULT '' , -- '错误消息',
  operTime datetime NULL DEFAULT NULL , -- '操作时间',
  elapsed bigint NULL DEFAULT NULL , -- '请求用时',
) 
GO

-- ----------------------------
-- = '岗位信息表'
-- Table structure for sys_post
-- ----------------------------
CREATE TABLE sys_post  (
  postId bigint NOT NULL IDENTITY(1,1) PRIMARY KEY, -- '岗位ID',
  postCode varchar(64)  NOT NULL , -- '岗位编码',
  postName varchar(50)  NOT NULL , -- '岗位名称',
  postSort int NOT NULL , -- '显示顺序',
  status varchar(1)  NOT NULL , -- '状态（0正常 1停用）',
  create_by varchar(64)  DEFAULT '' , -- '创建者',
  create_time datetime NULL DEFAULT NULL , -- '创建时间',
  update_by varchar(64)  DEFAULT '' , -- '更新者',
  update_time datetime NULL DEFAULT NULL , -- '更新时间',
  remark varchar(500)  DEFAULT NULL , -- '备注',
)

-- ----------------------------
-- Records of sys_post
-- ----------------------------
INSERT INTO sys_post VALUES ('CEO', '董事长', 1, '0', 'admin', '2021-04-20 20:43:23', '', NULL, '');
INSERT INTO sys_post VALUES ('SE', '项目经理', 2, '0', 'admin', '2021-04-20 20:43:23', '', NULL, '');
INSERT INTO sys_post VALUES ('HR', '人力资源', 3, '0', 'admin', '2021-04-20 20:43:23', '', NULL, '');
INSERT INTO sys_post VALUES ('USER', '普通员工', 4, '0', 'admin', '2021-04-20 20:43:23', 'admin', '2021-07-07 14:56:39', '普通用户');
INSERT INTO sys_post VALUES ('PM', '人事经理', 0, '0', NULL, '2021-07-07 15:01:20', 'admin', '2021-07-12 15:31:45', NULL);
INSERT INTO sys_post VALUES ('GM', '总经理', 0, '0', NULL, '2021-07-09 18:29:25', '', NULL, NULL);
INSERT INTO sys_post VALUES ('COO', '首席运营官', 0, '0', NULL, '2021-07-09 18:30:06', '', NULL, NULL);
INSERT INTO sys_post VALUES ('CFO', '首席财务官', 0, '0', NULL, '2021-07-09 18:30:28', '', NULL, NULL);
INSERT INTO sys_post VALUES ( 'CTO', '首席技术官', 0, '0', NULL, '2021-07-09 18:30:53', '', NULL, NULL);
INSERT INTO sys_post VALUES ( 'HRD', '人力资源总监', 0, '0', NULL, '2021-07-09 18:31:19', '', NULL, NULL);
INSERT INTO sys_post VALUES ( 'VP', '副总裁', 0, '0', NULL, '2021-07-09 18:31:31', '', NULL, NULL);
INSERT INTO sys_post VALUES ( 'OD', '运营总监', 0, '0', NULL, '2021-07-09 18:31:55', '', NULL, NULL);
INSERT INTO sys_post VALUES ( 'MD', '市场总监', 0, '0', NULL, '2021-07-09 18:32:16', '', NULL, NULL);

GO
/**用户表*/
CREATE TABLE sys_user  (
  userId BIGINT NOT NULL IDENTITY(1,1),	-- '用户ID',
  deptId BIGINT NULL DEFAULT NULL , --'部门ID',
  userName varchar(30) ,  -- '用户账号',
  nickName varchar(30) ,  -- '用户昵称',
  userType varchar(2) DEFAULT '0' , --'用户类型（00系统用户）',
  email varchar(50) ,  -- '用户邮箱',
  phonenumber varchar(11) ,  -- '手机号码',
  sex VARCHAR(1) DEFAULT '0', -- '用户性别（0男 1女 2未知）',
  avatar varchar(400) ,  -- '头像地址',
  password varchar(100) ,  -- '密码',
  status VARCHAR(1) DEFAULT '0', -- ,  -- '帐号状态（0正常 1停用）',
  delFlag VARCHAR(1) NULL DEFAULT '0', -- ,  -- '删除标志（0代表存在 2代表删除）',
  loginIP varchar(50) ,  -- '最后登录IP',
  loginDate datetime NULL , --'最后登录时间',
  create_by varchar(64) ,  -- '创建者',
  create_time datetime NULL , -- '创建时间',
  update_by varchar(64) ,  -- '更新者',
  update_time datetime NULL , -- '更新时间',
  remark varchar(500) , -- '备注',
)
GO
-- ----------------------------
-- Records of sys_user
-- ----------------------------
INSERT INTO sys_user VALUES (0, 'admin', '管理员', '0', '', '', '0', '', 'e10adc3949ba59abbe56e057f20f883e', '0', '0', '127.0.0.1', '2021-08-23 14:03:17', 'admin', '2020-11-26 11:52:59', 'admin', '2021-08-03 10:11:24', '管理员');
INSERT INTO sys_user VALUES (200, 'zr', 'zr', '0', '', '', '0', '', 'e10adc3949ba59abbe56e057f20f883e', '0', '0', '127.0.0.1', NULL, 'admin', '2021-07-05 17:29:13', 'admin', '2021-08-02 16:53:04', '普通用户');
INSERT INTO sys_user VALUES (100, 'editor', '编辑人员', '0', NULL, NULL, '2', 'http://www.izhaorui.cn/static/pay.jpg', 'E10ADC3949BA59ABBE56E057F20F883E', '0', '0', '127.0.0.1', '2021-08-19 09:27:46', 'admin', '2021-08-18 18:24:53', '', NULL, NULL);
GO
CREATE TABLE sys_user_post  (
  userId bigint NOT NULL ,  -- '用户ID',
  postId bigint NOT NULL ,  -- '岗位ID',
)
GO
alter table sys_user_post add primary key(userId,postId)
GO
-- ----------------------------
-- Records of sys_user_post
-- ----------------------------
INSERT INTO sys_user_post VALUES (1, 1);
GO

-- ----------------------------
-- '角色信息表'
-- Table structure for sys_role
-- ----------------------------
CREATE TABLE sys_role  (
  roleId bigint NOT NULL PRIMARY KEY IDENTITY(1,1) , -- '角色ID',
  roleName varchar(30)  NOT NULL , -- '角色名称',
  roleKey varchar(100)  NOT NULL , -- '角色权限字符串',
  roleSort int NOT NULL , -- '显示顺序',
  dataScope varchar(1)  NULL DEFAULT '1' , -- '数据范围（1：全部数据权限 2：自定数据权限 3：本部门数据权限 ）',
  menu_check_strictly int NULL DEFAULT 1 , -- '菜单树选择项是否关联显示',
  dept_check_strictly int NOT NULL DEFAULT 1 , -- '部门树选择项是否关联显示',
  status char(1)  NOT NULL , -- '角色状态（0正常 1停用）',
  delFlag char(1)  NOT NULL DEFAULT '0' , -- '删除标志（0代表存在 2代表删除）',
  create_by varchar(64)  NULL DEFAULT '' , -- '创建者',
  create_time datetime NULL DEFAULT NULL , -- '创建时间',
  update_by varchar(64)  NULL DEFAULT '' , -- '更新者',
  update_time datetime NULL DEFAULT NULL , -- '更新时间',
  remark varchar(500)  NULL DEFAULT NULL , -- '备注',
) 

-- ----------------------------
-- Records of sys_role
-- ----------------------------
INSERT INTO sys_role VALUES ('超级管理员', 'admin', 1, '1', 1, 0, '0', '0', 'admin', '2020-11-26 11:53:16', '', NULL, '超级管理员');
INSERT INTO sys_role VALUES ('普通角色', 'common', 2, '2', 1, 0, '0', '0', 'admin', '2020-11-26 11:53:16', 'admin', '2021-08-02 15:05:29', '普通角色');


-- ----------------------------
-- 用户和角色关联表
-- Table structure for sys_user_role
-- ----------------------------
CREATE TABLE sys_user_role  (
  user_id bigint NOT NULL ,  -- '用户ID',
  role_id bigint NOT NULL ,  -- '角色ID',
)
go
alter table sys_user_role add primary key(user_id,role_id)
GO
-- ----------------------------
-- Records of sys_user_role
-- ----------------------------
INSERT INTO sys_user_role VALUES (1, 1);
INSERT INTO sys_user_role VALUES (2, 2);
INSERT INTO sys_user_role VALUES (3, 3);
INSERT INTO sys_user_role VALUES (101, 2);
INSERT INTO sys_user_role VALUES (109, 116);
INSERT INTO sys_user_role VALUES (110, 2);
GO

-- ----------------------------
-- 角色和菜单关联表
-- Table structure for sys_role_menu
-- ----------------------------
CREATE TABLE sys_role_menu  (
  role_id bigint NOT NULL , -- '角色ID',
  menu_id bigint NOT NULL , -- '菜单ID',
  create_by varchar(20) DEFAULT NULL,
  create_time datetime NULL DEFAULT NULL
)
GO
alter table sys_role_menu add primary key(menu_id,role_id)
GO
-- ----------------------------
-- Records of sys_role_menu
-- ----------------------------
INSERT INTO sys_role_menu VALUES (2, 1, NULL, '2021-07-07 16:32:32');
INSERT INTO sys_role_menu VALUES (2, 2, NULL, '2021-07-07 16:32:32');
INSERT INTO sys_role_menu VALUES (2, 3, NULL, '2021-07-07 16:32:32');
INSERT INTO sys_role_menu VALUES (2, 4, NULL, '2021-07-07 16:32:32');
INSERT INTO sys_role_menu VALUES (2, 100, NULL, '2021-07-07 16:32:32');
INSERT INTO sys_role_menu VALUES (2, 101, NULL, '2021-07-07 16:32:32');
INSERT INTO sys_role_menu VALUES (2, 102, NULL, '2021-07-07 16:32:32');
INSERT INTO sys_role_menu VALUES (2, 103, NULL, '2021-07-07 16:32:32');
INSERT INTO sys_role_menu VALUES (2, 104, NULL, '2021-07-07 16:32:32');
INSERT INTO sys_role_menu VALUES (2, 108, NULL, '2021-07-07 16:32:32');
INSERT INTO sys_role_menu VALUES (2, 110, NULL, '2021-07-07 16:32:32');
INSERT INTO sys_role_menu VALUES (2, 112, NULL, '2021-07-07 16:32:32');
INSERT INTO sys_role_menu VALUES (2, 113, NULL, '2021-07-07 16:32:32');
INSERT INTO sys_role_menu VALUES (2, 114, NULL, '2021-07-07 16:32:32');
INSERT INTO sys_role_menu VALUES (2, 500, NULL, '2021-07-07 16:32:32');
INSERT INTO sys_role_menu VALUES (2, 501, NULL, '2021-07-07 16:32:32');
INSERT INTO sys_role_menu VALUES (2, 1008, NULL, '2021-07-07 16:32:32');
INSERT INTO sys_role_menu VALUES (2, 1013, NULL, '2021-07-07 16:32:32');
INSERT INTO sys_role_menu VALUES (2, 2013, NULL, '2021-07-07 16:32:32');
INSERT INTO sys_role_menu VALUES (2, 2019, NULL, '2021-07-07 16:32:32');
INSERT INTO sys_role_menu VALUES (2, 2029, NULL, '2021-07-07 16:32:32');
INSERT INTO sys_role_menu VALUES (2, 2037, NULL, '2021-07-07 16:32:32');
INSERT INTO sys_role_menu VALUES (2, 2040, NULL, '2021-07-07 16:32:32');
INSERT INTO sys_role_menu VALUES (2, 2044, NULL, '2021-07-07 16:32:32');
INSERT INTO sys_role_menu VALUES (2, 2053, NULL, '2021-07-07 16:32:32');
GO
-- ----------------------------
-- 文章表
-- Table structure for article
-- ----------------------------
CREATE TABLE article  (
  cid int NOT NULL IDENTITY(1,1) PRIMARY KEY,
  title varchar(254) DEFAULT NULL ,  -- '文章标题',
  content text ,  -- '文章内容',
  userId bigint NULL DEFAULT NULL ,  -- '用户id',
  status varchar(20) DEFAULT NULL ,  -- '文章状态1、已发布 2、草稿',
  fmt_type varchar(20) DEFAULT NULL ,  -- '编辑器类型markdown,html',
  tags varchar(100) DEFAULT NULL ,  -- '文章标签',
  hits int NULL DEFAULT NULL ,  -- '点击量',
  category_id int NULL DEFAULT NULL ,  -- '目录id',
  createTime datetime NULL DEFAULT NULL ,  -- '创建时间',
  updateTime datetime NULL DEFAULT NULL ,  -- '修改时间',
  authorName varchar(20) DEFAULT NULL ,  -- '作者名',
)
GO
-- ----------------------------
-- Table structure for articleCategory
-- ----------------------------
CREATE TABLE articleCategory  (
  category_id int NOT NULL IDENTITY(1,1) PRIMARY KEY ,  -- '目录id',
  name varchar(20) NOT NULL ,  -- '目录名',
  create_time datetime NULL DEFAULT NULL ,  -- '创建时间',
  parentId int NULL DEFAULT 0 ,  -- '父级ID',
)

-- ----------------------------
-- Records of articleCategory
-- ----------------------------
INSERT INTO articleCategory VALUES ('C#', '2021-08-13 00:00:00', 0);
INSERT INTO articleCategory VALUES ('java', '2021-08-18 00:00:00', 0);
INSERT INTO articleCategory VALUES ('前端', '2021-08-18 00:00:00', 0);
INSERT INTO articleCategory VALUES ('数据库', '2021-08-18 00:00:00', 0);
INSERT INTO articleCategory VALUES ('其他', '2021-08-19 00:00:00', 0);
INSERT INTO articleCategory VALUES ('羽毛球', '2021-08-19 00:00:00', 5);
INSERT INTO articleCategory VALUES ('vue', '2021-08-19 00:00:00', 3);
INSERT INTO articleCategory VALUES ('sqlserver', '2021-08-19 00:00:00', 4);

SELECT * FROM dbo.sys_dept
GO
SELECT * FROM dbo.sys_dict_data
GO
SELECT * FROM dbo.sys_menu
GO
SELECT * FROM dbo.sys_logininfor
GO
SELECT * FROM dbo.sys_user
GO
SELECT * FROM articleCategory