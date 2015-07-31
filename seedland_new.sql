-- MySQL dump 10.13  Distrib 5.6.24, for osx10.8 (x86_64)
--
-- Host: 127.0.0.1    Database: seedland20150710
-- ------------------------------------------------------
-- Server version	5.6.25

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `yehnet_admin`
--

DROP TABLE IF EXISTS `yehnet_admin`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `yehnet_admin` (
  `id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID号',
  `group_id` int(10) NOT NULL COMMENT '角色组id',
  `name` varchar(50) NOT NULL COMMENT '登陆账号',
  `pass` varchar(50) NOT NULL COMMENT '密码',
  `username` varchar(50) DEFAULT NULL COMMENT '姓名',
  `phone` varchar(20) DEFAULT NULL COMMENT '手机号',
  `email` varchar(100) DEFAULT NULL COMMENT '邮箱',
  `company` varchar(100) DEFAULT NULL COMMENT '公司名称',
  `department` varchar(100) DEFAULT NULL COMMENT '部门',
  `job` varchar(100) DEFAULT NULL COMMENT '职位',
  `status` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '1正常2锁定',
  `if_system` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '1系统管理员0普通管理员',
  `popedom` text NOT NULL COMMENT '权限',
  `langid` varchar(255) DEFAULT 'zh' COMMENT '可操作的语言权限，系统管理员不限',
  `note` varchar(1000) DEFAULT NULL COMMENT '备注',
  `add_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=124 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `yehnet_admin`
--

LOCK TABLES `yehnet_admin` WRITE;
/*!40000 ALTER TABLE `yehnet_admin` DISABLE KEYS */;
/*!40000 ALTER TABLE `yehnet_admin` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `yehnet_admin_group`
--

DROP TABLE IF EXISTS `yehnet_admin_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `yehnet_admin_group` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `if_system` tinyint(1) NOT NULL,
  `popedom` text NOT NULL,
  `description` text,
  `langid` varchar(225) DEFAULT 'zh',
  `is_sales` int(2) DEFAULT '0' COMMENT '是否置业顾问',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `yehnet_admin_group`
--

LOCK TABLES `yehnet_admin_group` WRITE;
/*!40000 ALTER TABLE `yehnet_admin_group` DISABLE KEYS */;
/*!40000 ALTER TABLE `yehnet_admin_group` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `yehnet_cache`
--

DROP TABLE IF EXISTS `yehnet_cache`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `yehnet_cache` (
  `id` varchar(50) NOT NULL COMMENT 'ID号',
  `langid` varchar(5) NOT NULL DEFAULT 'zh' COMMENT '语言ID',
  `content` longtext NOT NULL COMMENT '缓存内容',
  `postdate` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '缓存时间',
  PRIMARY KEY (`id`,`langid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `yehnet_cache`
--

LOCK TABLES `yehnet_cache` WRITE;
/*!40000 ALTER TABLE `yehnet_cache` DISABLE KEYS */;
/*!40000 ALTER TABLE `yehnet_cache` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `yehnet_cate`
--

DROP TABLE IF EXISTS `yehnet_cate`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `yehnet_cate` (
  `id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增ID号',
  `identifier` varchar(30) NOT NULL COMMENT '标识串，必须是唯一的',
  `langid` varchar(5) NOT NULL COMMENT '语言标识',
  `cate_name` varchar(100) NOT NULL COMMENT '分类名称',
  `parentid` mediumint(8) unsigned NOT NULL DEFAULT '0' COMMENT '父级ID，如果为根分类，则使用0',
  `module_id` mediumint(8) unsigned NOT NULL DEFAULT '0' COMMENT '模块ID',
  `tpl_index` varchar(100) NOT NULL COMMENT '封面模板',
  `tpl_list` varchar(100) NOT NULL COMMENT '列表模板',
  `tpl_file` varchar(100) NOT NULL COMMENT '内容模板',
  `if_index` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '是否是封面，0否1是',
  `taxis` tinyint(3) unsigned NOT NULL DEFAULT '255' COMMENT '排序，值越小越往前靠',
  `status` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '1使用中0禁用',
  `if_hidden` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '1隐藏0显示',
  `keywords` varchar(255) NOT NULL COMMENT 'SEO关键字',
  `description` varchar(255) NOT NULL COMMENT 'SEO描述',
  `ifspec` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '0非单页1单页',
  `note` text NOT NULL COMMENT '简要描述',
  `psize` tinyint(3) unsigned NOT NULL DEFAULT '30' COMMENT '每页显示数量，默认30',
  `inpic` varchar(100) NOT NULL COMMENT '前台默认图片关联',
  `linkurl` varchar(255) NOT NULL COMMENT '自定义链接',
  `target` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '新窗口打开1是0否',
  `ordertype` varchar(100) NOT NULL DEFAULT 'post_date:desc' COMMENT '排序类型，默认是发布时间',
  `subcate` varchar(100) NOT NULL COMMENT '分类副标题',
  `ico` varchar(255) NOT NULL COMMENT '图标',
  `small_pic` varchar(255) NOT NULL COMMENT '小图',
  `medium_pic` varchar(255) NOT NULL COMMENT '中图',
  `big_pic` varchar(255) NOT NULL COMMENT '大图',
  `fields` varchar(255) NOT NULL COMMENT '有效字段',
  PRIMARY KEY (`id`),
  KEY `module_id` (`module_id`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `yehnet_cate`
--

LOCK TABLES `yehnet_cate` WRITE;
/*!40000 ALTER TABLE `yehnet_cate` DISABLE KEYS */;
/*!40000 ALTER TABLE `yehnet_cate` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `yehnet_commission`
--

DROP TABLE IF EXISTS `yehnet_commission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `yehnet_commission` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增ID号',
  `cid` mediumint(8) NOT NULL COMMENT '客户id',
  `cellphone` varchar(20) NOT NULL COMMENT '客户电话',
  `username` varchar(100) NOT NULL COMMENT '客户名称',
  `uid` mediumint(8) unsigned NOT NULL DEFAULT '0' COMMENT '经纪人uid',
  `phone` varchar(20) NOT NULL COMMENT '经纪人电话',
  `uname` varchar(200) NOT NULL COMMENT '经纪人名字',
  `guwenid` mediumint(8) NOT NULL COMMENT '顾问id',
  `guwentel` varchar(20) NOT NULL COMMENT '置业顾问电话',
  `guwenname` varchar(220) NOT NULL COMMENT '置业顾问名称',
  `pid` int(10) NOT NULL COMMENT '项目id',
  `proname` varchar(220) NOT NULL DEFAULT '0',
  `ctype` varchar(20) NOT NULL DEFAULT '0',
  `money` float NOT NULL COMMENT '佣金数目',
  `status` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '0未审核1通过（待结）2不通过3已结',
  `postdate` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '生成时间',
  PRIMARY KEY (`id`),
  KEY `listid` (`uid`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `yehnet_commission`
--

LOCK TABLES `yehnet_commission` WRITE;
/*!40000 ALTER TABLE `yehnet_commission` DISABLE KEYS */;
/*!40000 ALTER TABLE `yehnet_commission` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `yehnet_customer`
--

DROP TABLE IF EXISTS `yehnet_customer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `yehnet_customer` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增ID号',
  `username` varchar(100) DEFAULT NULL COMMENT '客户名称',
  `cellphone` varchar(20) NOT NULL DEFAULT '' COMMENT '客户手机号',
  `officetel` varchar(32) DEFAULT NULL COMMENT '办公电话',
  `hometel` varchar(32) DEFAULT NULL COMMENT '家庭电话',
  `id_number` varchar(25) DEFAULT NULL COMMENT '身份证号',
  `grade` varchar(45) DEFAULT NULL COMMENT '等级',
  `tag` varchar(45) DEFAULT NULL COMMENT '标签',
  `remark` text COMMENT '备注',
  `add_time` datetime NOT NULL COMMENT '添加时间',
  PRIMARY KEY (`id`,`cellphone`)
) ENGINE=MyISAM AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 COMMENT='客户信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `yehnet_customer`
--

LOCK TABLES `yehnet_customer` WRITE;
/*!40000 ALTER TABLE `yehnet_customer` DISABLE KEYS */;
/*!40000 ALTER TABLE `yehnet_customer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `yehnet_customer_admin`
--

DROP TABLE IF EXISTS `yehnet_customer_admin`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `yehnet_customer_admin` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `c_id` int(11) NOT NULL COMMENT '客户ID',
  `a_id` int(11) NOT NULL COMMENT '置业顾问ID',
  `remark` text CHARACTER SET utf8 COMMENT '备注',
  `status` tinyint(2) DEFAULT NULL COMMENT '1有效 2无效',
  `add_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '添加时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1 COMMENT='客户与置业顾问关系表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `yehnet_customer_admin`
--

LOCK TABLES `yehnet_customer_admin` WRITE;
/*!40000 ALTER TABLE `yehnet_customer_admin` DISABLE KEYS */;
/*!40000 ALTER TABLE `yehnet_customer_admin` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `yehnet_customer_project`
--

DROP TABLE IF EXISTS `yehnet_customer_project`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `yehnet_customer_project` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `c_id` int(11) NOT NULL COMMENT '客户ID',
  `u_id` int(11) DEFAULT NULL COMMENT '经纪人ID',
  `p_id` int(11) NOT NULL COMMENT '项目ID',
  `apartment` varchar(100) DEFAULT NULL COMMENT '房屋户型',
  `housetype` varchar(100) DEFAULT NULL COMMENT '房屋类型',
  `housesquare` varchar(100) DEFAULT NULL COMMENT '房屋面积',
  `housefloor` varchar(100) DEFAULT NULL COMMENT '房屋楼层',
  `other` text COMMENT '其他',
  `status` int(11) DEFAULT '2' COMMENT '1无效 2有效',
  `add_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '添加时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 COMMENT='客户与房源的关系表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `yehnet_customer_project`
--

LOCK TABLES `yehnet_customer_project` WRITE;
/*!40000 ALTER TABLE `yehnet_customer_project` DISABLE KEYS */;
/*!40000 ALTER TABLE `yehnet_customer_project` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `yehnet_customer_status`
--

DROP TABLE IF EXISTS `yehnet_customer_status`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `yehnet_customer_status` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `c_id` int(11) NOT NULL COMMENT '客户ID',
  `u_id` int(11) DEFAULT NULL COMMENT '经纪人ID',
  `a_id` int(11) DEFAULT NULL COMMENT '陪同的置业顾问ID',
  `p_id` int(11) DEFAULT NULL COMMENT '项目ID',
  `type` int(2) NOT NULL COMMENT '1为到访，2为认筹，3为认购，4为签约',
  `number` varchar(50) DEFAULT NULL COMMENT '认筹编号、认购编号、签约合同编号',
  `price` float(8,2) DEFAULT NULL COMMENT '认购价、签约价',
  `payment` varchar(50) DEFAULT NULL COMMENT '付款方式',
  `remark` text COMMENT '备注',
  `status` int(2) DEFAULT '1' COMMENT '1有效 2无效',
  `operator_id` int(11) DEFAULT NULL COMMENT '操作人ID',
  `add_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '添加时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `yehnet_customer_status`
--

LOCK TABLES `yehnet_customer_status` WRITE;
/*!40000 ALTER TABLE `yehnet_customer_status` DISABLE KEYS */;
/*!40000 ALTER TABLE `yehnet_customer_status` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `yehnet_customer_user`
--

DROP TABLE IF EXISTS `yehnet_customer_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `yehnet_customer_user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `c_id` int(11) NOT NULL COMMENT '客户ID',
  `u_id` int(11) NOT NULL COMMENT '经纪人ID',
  `status` tinyint(2) DEFAULT '1' COMMENT '1为未审核，2为通过，3为未通过，4为过期',
  `commission` float DEFAULT '0' COMMENT '佣金',
  `remark` text COMMENT '变更备注',
  `add_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '添加时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8 COMMENT='客户与经纪人的关系表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `yehnet_customer_user`
--

LOCK TABLES `yehnet_customer_user` WRITE;
/*!40000 ALTER TABLE `yehnet_customer_user` DISABLE KEYS */;
/*!40000 ALTER TABLE `yehnet_customer_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `yehnet_gd`
--

DROP TABLE IF EXISTS `yehnet_gd`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `yehnet_gd` (
  `id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增ID号',
  `pictype` varchar(50) NOT NULL DEFAULT '' COMMENT '图片类型标识',
  `picsubject` varchar(255) NOT NULL DEFAULT '' COMMENT '类型名称',
  `width` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '图片宽度',
  `height` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '图片高度',
  `water` varchar(255) NOT NULL DEFAULT '' COMMENT '水印图片位置',
  `picposition` varchar(100) NOT NULL DEFAULT '' COMMENT '水印位置',
  `trans` tinyint(3) unsigned NOT NULL DEFAULT '65' COMMENT '透明度，默认是60',
  `cuttype` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '图片生成方式，支持缩放法和裁剪法两种，默认使用缩放法',
  `quality` tinyint(3) unsigned NOT NULL DEFAULT '80' COMMENT '图片生成质量，默认是80',
  `border` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否支持边框，1是0否',
  `bordercolor` varchar(10) NOT NULL DEFAULT 'FFFFFF' COMMENT '边框颜色',
  `padding` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '间距，默认是0,最大不超过255',
  `bgcolor` varchar(10) NOT NULL DEFAULT 'FFFFFF' COMMENT '补白背景色，默认是白色',
  `bgimg` varchar(255) NOT NULL DEFAULT '' COMMENT '背景图片，默认为空',
  `status` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '是否使用，默认是使用',
  `taxis` tinyint(3) unsigned NOT NULL DEFAULT '255' COMMENT '排序，值越小越往前靠，最大不超过255，最小为0',
  `edit_default` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `yehnet_gd`
--

LOCK TABLES `yehnet_gd` WRITE;
/*!40000 ALTER TABLE `yehnet_gd` DISABLE KEYS */;
/*!40000 ALTER TABLE `yehnet_gd` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `yehnet_housetype`
--

DROP TABLE IF EXISTS `yehnet_housetype`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `yehnet_housetype` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `listid` int(11) DEFAULT NULL COMMENT 'list的外键',
  `title` varchar(45) CHARACTER SET utf8 DEFAULT NULL COMMENT '户型',
  `type` varchar(50) CHARACTER SET utf8 DEFAULT NULL COMMENT '产品类别',
  `floor` varchar(50) CHARACTER SET utf8 DEFAULT NULL COMMENT '楼层',
  `size` varchar(50) DEFAULT NULL COMMENT '面积',
  `count` int(11) DEFAULT NULL COMMENT '数量',
  `price` float(11,0) DEFAULT NULL COMMENT '单价',
  `sum` float(11,0) DEFAULT NULL COMMENT '总价',
  `value` float(11,2) DEFAULT NULL COMMENT '佣金',
  PRIMARY KEY (`id`),
  UNIQUE KEY `listid_title` (`listid`,`title`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=119 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `yehnet_housetype`
--

LOCK TABLES `yehnet_housetype` WRITE;
/*!40000 ALTER TABLE `yehnet_housetype` DISABLE KEYS */;
/*!40000 ALTER TABLE `yehnet_housetype` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `yehnet_identifier`
--

DROP TABLE IF EXISTS `yehnet_identifier`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `yehnet_identifier` (
  `id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `sign` varchar(32) NOT NULL COMMENT '标识符，用于本系统内所有需要此功能，仅限字母数字及下划线且第一个必须是字母',
  `title` varchar(100) NOT NULL COMMENT '名称',
  `langid` varchar(5) NOT NULL COMMENT '语言编号，如zh,en等',
  `module_id` mediumint(8) unsigned NOT NULL COMMENT '一个标识符只能用于一个模块，一个模块有多个标识符',
  `if_system` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '1系统0自定义',
  `g_sign` varchar(100) NOT NULL COMMENT '组标识，仅在核心技术中使用',
  `taxis` tinyint(3) unsigned NOT NULL DEFAULT '255' COMMENT '排序',
  PRIMARY KEY (`id`),
  KEY `module_id` (`module_id`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=12 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `yehnet_identifier`
--

LOCK TABLES `yehnet_identifier` WRITE;
/*!40000 ALTER TABLE `yehnet_identifier` DISABLE KEYS */;
/*!40000 ALTER TABLE `yehnet_identifier` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `yehnet_input`
--

DROP TABLE IF EXISTS `yehnet_input`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `yehnet_input` (
  `input` varchar(50) NOT NULL COMMENT '扩展框类型',
  `langid` varchar(5) NOT NULL DEFAULT 'zh' COMMENT '语言ID',
  `name` varchar(100) NOT NULL COMMENT '名字',
  `taxis` tinyint(3) unsigned NOT NULL DEFAULT '255' COMMENT '排序',
  `ifuser` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否允许会员表使用0否1是',
  PRIMARY KEY (`input`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `yehnet_input`
--

LOCK TABLES `yehnet_input` WRITE;
/*!40000 ALTER TABLE `yehnet_input` DISABLE KEYS */;
/*!40000 ALTER TABLE `yehnet_input` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `yehnet_integration`
--

DROP TABLE IF EXISTS `yehnet_integration`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `yehnet_integration` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `yehnet_integration`
--

LOCK TABLES `yehnet_integration` WRITE;
/*!40000 ALTER TABLE `yehnet_integration` DISABLE KEYS */;
/*!40000 ALTER TABLE `yehnet_integration` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `yehnet_integration_order`
--

DROP TABLE IF EXISTS `yehnet_integration_order`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `yehnet_integration_order` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `uid` int(11) NOT NULL COMMENT '兑换人ID',
  `orderid` int(11) DEFAULT NULL COMMENT '订单编号',
  `cn` varchar(45) DEFAULT NULL COMMENT '核销码',
  `order_type` tinyint(2) DEFAULT NULL COMMENT '订单类型：1自提；2快递',
  `item_name` varchar(100) DEFAULT NULL COMMENT '商品名称',
  `num` int(10) DEFAULT NULL COMMENT '兑换数量',
  `points` int(11) DEFAULT NULL COMMENT '兑换积分',
  `name` varchar(60) DEFAULT NULL COMMENT '收货人姓名',
  `phone` varchar(20) DEFAULT NULL COMMENT '收货人联系方式',
  `province` varchar(20) DEFAULT NULL,
  `city` varchar(20) DEFAULT NULL,
  `area` varchar(20) DEFAULT NULL,
  `address` varchar(100) DEFAULT NULL,
  `zipcode` int(10) DEFAULT NULL COMMENT '邮编',
  `status` tinyint(2) DEFAULT NULL COMMENT '0在购物车；1未出库；2已出库；3已签收；4关闭',
  `note` text COMMENT '备注',
  `ck_time` datetime DEFAULT NULL COMMENT '出库时间',
  `qs_time` datetime DEFAULT NULL COMMENT '签收时间',
  `ck_operator` varchar(60) DEFAULT NULL COMMENT '出库操作人',
  `add_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '下单时间',
  `username` varchar(45) DEFAULT NULL COMMENT '兑换人姓名',
  `cellphone` varchar(45) DEFAULT NULL COMMENT '兑换人手机号',
  `kd_company` varchar(45) DEFAULT NULL COMMENT '快递公司',
  `kd_no` varchar(45) DEFAULT NULL COMMENT '快递编号',
  `kd_remark` varchar(200) DEFAULT NULL,
  `item_id` int(11) DEFAULT NULL COMMENT '商品ID',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=69 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `yehnet_integration_order`
--

LOCK TABLES `yehnet_integration_order` WRITE;
/*!40000 ALTER TABLE `yehnet_integration_order` DISABLE KEYS */;
/*!40000 ALTER TABLE `yehnet_integration_order` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `yehnet_integration_setting`
--

DROP TABLE IF EXISTS `yehnet_integration_setting`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `yehnet_integration_setting` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(50) DEFAULT NULL COMMENT '名称',
  `key` varchar(50) DEFAULT NULL COMMENT '英文名',
  `value` int(11) DEFAULT NULL COMMENT '积分值',
  `description` varchar(200) DEFAULT NULL COMMENT '描述',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `yehnet_integration_setting`
--

LOCK TABLES `yehnet_integration_setting` WRITE;
/*!40000 ALTER TABLE `yehnet_integration_setting` DISABLE KEYS */;
/*!40000 ALTER TABLE `yehnet_integration_setting` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `yehnet_integration_shop`
--

DROP TABLE IF EXISTS `yehnet_integration_shop`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `yehnet_integration_shop` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `code` varchar(11) DEFAULT NULL COMMENT '商品编码；纯数字；六位数',
  `name` varchar(100) DEFAULT NULL COMMENT '商品名称',
  `brand` varchar(60) DEFAULT NULL COMMENT '品牌',
  `thumb_id` mediumint(8) DEFAULT NULL,
  `images` varchar(200) DEFAULT NULL COMMENT '商品轮播图片',
  `num` int(11) unsigned DEFAULT NULL COMMENT '库存',
  `description` text COMMENT '产品规格',
  `info` text,
  `status` int(2) DEFAULT '3' COMMENT '1上架 ;2下架;3关闭',
  `points` int(11) DEFAULT NULL COMMENT '兑换积分',
  `is_activity` int(2) DEFAULT NULL COMMENT '是否参与活动；1是2否',
  `ordid` int(10) DEFAULT NULL COMMENT '排序',
  `start_time` datetime DEFAULT NULL COMMENT '上架时间',
  `end_time` datetime DEFAULT NULL COMMENT '下架时间',
  `add_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `yehnet_integration_shop`
--

LOCK TABLES `yehnet_integration_shop` WRITE;
/*!40000 ALTER TABLE `yehnet_integration_shop` DISABLE KEYS */;
/*!40000 ALTER TABLE `yehnet_integration_shop` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `yehnet_integration_shop_setting`
--

DROP TABLE IF EXISTS `yehnet_integration_shop_setting`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `yehnet_integration_shop_setting` (
  `id` int(11) unsigned NOT NULL,
  `is_points` tinyint(2) DEFAULT NULL COMMENT '是否显示积分;1显示；0不显示',
  `is_num` tinyint(2) DEFAULT NULL COMMENT '是否显示库存；1显示；0不显示',
  `is_activity` tinyint(2) DEFAULT NULL COMMENT '是否参与限时活动；1是0否',
  `is_shop` tinyint(2) DEFAULT NULL COMMENT '是否显示正常兑换；1是2否',
  `is_history` tinyint(2) DEFAULT NULL COMMENT '显示历史兑换；1是2否',
  `start_time` datetime DEFAULT NULL COMMENT '兑换开始时间',
  `end_time` datetime DEFAULT NULL COMMENT '兑换结束时间',
  `images` varchar(100) DEFAULT NULL COMMENT '首页轮播图片',
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `yehnet_integration_shop_setting`
--

LOCK TABLES `yehnet_integration_shop_setting` WRITE;
/*!40000 ALTER TABLE `yehnet_integration_shop_setting` DISABLE KEYS */;
/*!40000 ALTER TABLE `yehnet_integration_shop_setting` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `yehnet_lang`
--

DROP TABLE IF EXISTS `yehnet_lang`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `yehnet_lang` (
  `langid` varchar(5) NOT NULL DEFAULT 'zh' COMMENT '语言ID',
  `title` varchar(100) NOT NULL COMMENT '显示名',
  `status` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '状态1不使用2使用',
  `note` varchar(255) NOT NULL COMMENT '描述',
  `taxis` tinyint(3) unsigned NOT NULL DEFAULT '255' COMMENT '排序，小值排前',
  `ifdefault` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '是否是系统默认',
  `ifsystem` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '1系统语言0应用语言',
  `ico` varchar(255) NOT NULL COMMENT '图标',
  `small_pic` varchar(255) NOT NULL COMMENT '小图',
  `medium_pic` varchar(255) NOT NULL COMMENT '中图',
  `big_pic` varchar(255) NOT NULL COMMENT '大图',
  PRIMARY KEY (`langid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `yehnet_lang`
--

LOCK TABLES `yehnet_lang` WRITE;
/*!40000 ALTER TABLE `yehnet_lang` DISABLE KEYS */;
/*!40000 ALTER TABLE `yehnet_lang` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `yehnet_lang_msg`
--

DROP TABLE IF EXISTS `yehnet_lang_msg`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `yehnet_lang_msg` (
  `id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增ID号',
  `langid` varchar(5) NOT NULL DEFAULT 'zh' COMMENT '语言ID',
  `ltype` enum('www','admin','all') NOT NULL DEFAULT 'all' COMMENT '语言包应用范围',
  `var` varchar(100) NOT NULL COMMENT '语言变量名，仅英文数字及下划线',
  `val` varchar(255) NOT NULL COMMENT '语言值',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=469 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `yehnet_lang_msg`
--

LOCK TABLES `yehnet_lang_msg` WRITE;
/*!40000 ALTER TABLE `yehnet_lang_msg` DISABLE KEYS */;
/*!40000 ALTER TABLE `yehnet_lang_msg` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `yehnet_list`
--

DROP TABLE IF EXISTS `yehnet_list`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `yehnet_list` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `module_id` mediumint(8) unsigned NOT NULL COMMENT '模块ID',
  `cate_id` mediumint(8) unsigned NOT NULL COMMENT '分类ID',
  `title` varchar(255) NOT NULL COMMENT '主题',
  `subtitle` varchar(255) DEFAULT NULL COMMENT '副标题',
  `images` varchar(500) DEFAULT NULL COMMENT '实景图',
  `style` varchar(255) DEFAULT NULL COMMENT '主题样式',
  `content` text COMMENT '内容',
  `status` tinyint(1) unsigned DEFAULT '0' COMMENT '状态，1正常0锁定',
  `hidden` tinyint(1) unsigned DEFAULT '0' COMMENT '1隐藏0显示',
  `link_url` varchar(255) DEFAULT NULL COMMENT '访问网址',
  `target` tinyint(1) unsigned DEFAULT '0' COMMENT '是否在新窗口打开1是0否',
  `author` varchar(100) DEFAULT NULL COMMENT '发布人',
  `author_type` enum('admin','user','guest') DEFAULT 'user' COMMENT '发布人类型',
  `keywords` varchar(255) DEFAULT NULL COMMENT '关键字，标签',
  `description` varchar(255) DEFAULT NULL COMMENT '简要描述用于SEO优化',
  `note` text COMMENT '简要描述，用于列表简要说明',
  `identifier` varchar(100) DEFAULT NULL COMMENT '访问标识串，为空时使用系统ID',
  `hits` int(10) unsigned DEFAULT '0' COMMENT '点击率',
  `good_hits` int(10) unsigned DEFAULT '0' COMMENT '支持次数',
  `bad_hits` int(10) unsigned DEFAULT '0' COMMENT '拍砖次数',
  `post_date` int(10) unsigned DEFAULT '0' COMMENT '发布时间',
  `modify_date` int(10) unsigned DEFAULT '0' COMMENT '最后修改时间',
  `begin_date` int(10) unsigned DEFAULT NULL COMMENT '活动开始时间',
  `end_date` int(10) unsigned DEFAULT NULL COMMENT '活动结束时间',
  `telphone` varchar(15) DEFAULT NULL COMMENT '活动联系电话',
  `act_addr` varchar(25) DEFAULT NULL COMMENT '活动地点',
  `thumb_id` mediumint(8) unsigned DEFAULT '0' COMMENT '缩略图ID',
  `istop` tinyint(1) unsigned DEFAULT '0' COMMENT '1置顶0非置顶',
  `isvouch` tinyint(1) unsigned DEFAULT '0' COMMENT '1推荐0非推荐',
  `isbest` tinyint(1) unsigned DEFAULT '0' COMMENT '1精华0非精华',
  `langid` varchar(5) DEFAULT 'zh' COMMENT '语言ID，默认是中文',
  `points` int(10) DEFAULT '0' COMMENT '积分，点数',
  `ip` varchar(100) DEFAULT NULL COMMENT '发布人IP号',
  `replydate` int(10) unsigned DEFAULT '0' COMMENT '最后回复时间',
  `taxis` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '自定义排序，值越大越往前靠',
  `htmltype` enum('mid','cateid','date','root') DEFAULT 'date' COMMENT 'HTML存储方式，默认是以时间来存储',
  `tplfile` varchar(100) DEFAULT NULL COMMENT '模板文件',
  `star` float unsigned DEFAULT '0' COMMENT '星级评论，默认为0，根据评论表中的星数来决定',
  `yongjin` float(10,2) DEFAULT NULL COMMENT '佣金',
  `jili` varchar(200) DEFAULT NULL,
  `map_url` varchar(200) DEFAULT NULL COMMENT '地图地址',
  `jiage` varchar(200) DEFAULT NULL COMMENT '价格',
  `address` varchar(200) DEFAULT NULL,
  `phone` varchar(50) DEFAULT NULL,
  `huxingjieshao` text,
  `province` varchar(20) DEFAULT NULL,
  `city` varchar(20) DEFAULT NULL,
  `area` varchar(20) DEFAULT NULL,
  `leibie` varchar(25) DEFAULT NULL COMMENT '类别',
  PRIMARY KEY (`id`),
  KEY `module_id` (`module_id`,`cate_id`,`title`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=19 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `yehnet_list`
--

LOCK TABLES `yehnet_list` WRITE;
/*!40000 ALTER TABLE `yehnet_list` DISABLE KEYS */;
/*!40000 ALTER TABLE `yehnet_list` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `yehnet_list_c`
--

DROP TABLE IF EXISTS `yehnet_list_c`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `yehnet_list_c` (
  `id` int(10) unsigned NOT NULL COMMENT '主题ID',
  `field` varchar(30) NOT NULL DEFAULT '' COMMENT '字段名',
  `val` text NOT NULL COMMENT '内容',
  PRIMARY KEY (`id`,`field`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `yehnet_list_c`
--

LOCK TABLES `yehnet_list_c` WRITE;
/*!40000 ALTER TABLE `yehnet_list_c` DISABLE KEYS */;
/*!40000 ALTER TABLE `yehnet_list_c` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `yehnet_module`
--

DROP TABLE IF EXISTS `yehnet_module`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `yehnet_module` (
  `id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `group_id` mediumint(8) unsigned NOT NULL COMMENT '组ID',
  `langid` varchar(5) NOT NULL DEFAULT 'zh' COMMENT '语言ID，默认是zh',
  `identifier` varchar(32) NOT NULL DEFAULT '0' COMMENT '标识符',
  `title` varchar(100) NOT NULL COMMENT '名称',
  `ico` varchar(255) NOT NULL COMMENT '图标',
  `note` varchar(255) NOT NULL COMMENT '备注',
  `ctrl_init` varchar(100) NOT NULL COMMENT '执行文件，不同模块可能执行相同的文件，使用标识符区分',
  `status` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '0不使用1使用',
  `taxis` tinyint(3) unsigned NOT NULL DEFAULT '255' COMMENT '排序值越小越往靠，最小为0',
  `if_system` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '1系统模块2自定义添加模块',
  `if_cate` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '是否启用分类功能，1使用0不使用',
  `if_biz` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '是否支持电子商务，0否1是',
  `if_propety` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '0不支持属性，1支持',
  `if_hits` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '0不持点击1支持',
  `popedom` varchar(255) NOT NULL COMMENT '权限ID，多个权限ID用英文逗号隔开',
  `if_thumb` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '1支持缩略图0不支持',
  `if_thumb_m` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '1必填0非必填',
  `if_point` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '0不支持点数1支持点数',
  `if_url_m` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '0不支持自定义网址，1支持，2支持且必填',
  `inpic` varchar(100) NOT NULL COMMENT '前台默认图片关联',
  `insearch` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '支持前台搜索',
  `if_content` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '0不支持读取内容1读取内容及管理员回复',
  `if_email` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '1邮件通知0不通知',
  `link_id` mediumint(8) unsigned NOT NULL DEFAULT '0' COMMENT '联动ID，0为不使用联动搜索',
  `search_id` varchar(30) NOT NULL COMMENT '联动搜索的字段名',
  `psize` tinyint(3) unsigned NOT NULL DEFAULT '30' COMMENT '默认分页数量',
  `if_subtitle` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否启用副标题0否1是',
  `small_pic` varchar(255) NOT NULL COMMENT '小图',
  `medium_pic` varchar(255) NOT NULL COMMENT '中图',
  `big_pic` varchar(255) NOT NULL COMMENT '大图',
  `tplset` enum('list','pic') NOT NULL DEFAULT 'list' COMMENT 'list列表，pic图文',
  `title_nickname` varchar(50) NOT NULL COMMENT '主题别称',
  `subtitle_nickname` varchar(50) NOT NULL COMMENT '副标题别称',
  `sign_nickname` varchar(50) NOT NULL COMMENT '标识串别称',
  `if_sign_m` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '标识串是否必填',
  `if_ext` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '可选扩展1使用0不使用',
  `if_des` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '简短描述1允许0不使用',
  `if_list` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '1支持0不支持',
  `if_msg` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '1支持0不支持',
  `layout` varchar(255) NOT NULL COMMENT '后台布局设置',
  PRIMARY KEY (`id`),
  KEY `group_id` (`group_id`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=32 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `yehnet_module`
--

LOCK TABLES `yehnet_module` WRITE;
/*!40000 ALTER TABLE `yehnet_module` DISABLE KEYS */;
/*!40000 ALTER TABLE `yehnet_module` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `yehnet_module_fields`
--

DROP TABLE IF EXISTS `yehnet_module_fields`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `yehnet_module_fields` (
  `id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `module_id` mediumint(8) unsigned NOT NULL COMMENT '模块ID',
  `identifier` varchar(32) NOT NULL COMMENT '标识符',
  `title` varchar(100) NOT NULL COMMENT '主题',
  `if_post` tinyint(1) NOT NULL DEFAULT '0' COMMENT '1支持会员0不支持',
  `if_guest` tinyint(1) NOT NULL DEFAULT '0' COMMENT '1支持游客0不支持',
  `sub_left` varchar(60) NOT NULL COMMENT '左侧主题',
  `sub_note` varchar(120) NOT NULL COMMENT '右侧备注信息',
  `input` varchar(50) NOT NULL DEFAULT 'text' COMMENT '表单类型',
  `width` varchar(20) NOT NULL COMMENT '宽度',
  `height` varchar(20) NOT NULL COMMENT '高度',
  `default_val` varchar(50) NOT NULL COMMENT '默认值',
  `list_val` varchar(255) NOT NULL COMMENT '值列表',
  `link_id` int(10) NOT NULL DEFAULT '0' COMMENT '联动组ID',
  `taxis` tinyint(3) unsigned NOT NULL DEFAULT '255' COMMENT '自定义排序，值越小越往前靠',
  `if_must` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '1必填0非必填',
  `if_html` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '1支持HTML，0不支持',
  `error_note` varchar(255) NOT NULL COMMENT '错误时的提示',
  `status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '1启用0禁用',
  `if_system` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '1系统字段，0用户配置字段',
  `tbl` enum('ext','c') NOT NULL COMMENT 'ext指长度不大于255的表中，c指长度大于255的数据',
  `show_html` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '0不显示源码1显示源码',
  `if_js` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '1支持0不支持',
  `if_search` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '是否允许搜索',
  PRIMARY KEY (`id`),
  KEY `module_id` (`module_id`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `yehnet_module_fields`
--

LOCK TABLES `yehnet_module_fields` WRITE;
/*!40000 ALTER TABLE `yehnet_module_fields` DISABLE KEYS */;
/*!40000 ALTER TABLE `yehnet_module_fields` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `yehnet_module_group`
--

DROP TABLE IF EXISTS `yehnet_module_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `yehnet_module_group` (
  `id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `langid` varchar(32) NOT NULL DEFAULT 'zh' COMMENT '语言编号，如zh,en等',
  `title` varchar(100) NOT NULL COMMENT '组名称',
  `ico` varchar(250) NOT NULL,
  `status` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '0不使用1使用',
  `taxis` tinyint(3) unsigned NOT NULL DEFAULT '255' COMMENT '值越小越往靠，最小为0',
  `js_function` varchar(100) NOT NULL DEFAULT '' COMMENT 'JS控制器，为空使用系统自动生成',
  `if_system` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '1系统0自定义',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=12 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `yehnet_module_group`
--

LOCK TABLES `yehnet_module_group` WRITE;
/*!40000 ALTER TABLE `yehnet_module_group` DISABLE KEYS */;
/*!40000 ALTER TABLE `yehnet_module_group` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `yehnet_msg_log`
--

DROP TABLE IF EXISTS `yehnet_msg_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `yehnet_msg_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `u_id` int(11) DEFAULT NULL,
  `cellphone` varchar(20) CHARACTER SET utf8 DEFAULT NULL,
  `status` tinyint(4) DEFAULT NULL COMMENT '短信发送状态',
  `value` varchar(50) CHARACTER SET utf8 DEFAULT NULL COMMENT '短信回馈的状态',
  `msg` text CHARACTER SET utf8 COMMENT '发送内容',
  `add_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=42 DEFAULT CHARSET=latin1 COMMENT='短信发送记录';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `yehnet_msg_log`
--

LOCK TABLES `yehnet_msg_log` WRITE;
/*!40000 ALTER TABLE `yehnet_msg_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `yehnet_msg_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `yehnet_operation_log`
--

DROP TABLE IF EXISTS `yehnet_operation_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `yehnet_operation_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `u_id` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `action` varchar(255) CHARACTER SET utf8 DEFAULT NULL COMMENT '增删改',
  `model` varchar(255) CHARACTER SET utf8 DEFAULT NULL COMMENT '模型',
  `object` text CHARACTER SET utf8 COMMENT '对象',
  `status` int(255) DEFAULT NULL,
  `add_time` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=654 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `yehnet_operation_log`
--

LOCK TABLES `yehnet_operation_log` WRITE;
/*!40000 ALTER TABLE `yehnet_operation_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `yehnet_operation_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `yehnet_points_log`
--

DROP TABLE IF EXISTS `yehnet_points_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `yehnet_points_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `u_id` int(11) DEFAULT NULL COMMENT '会员ID',
  `points` int(5) DEFAULT NULL COMMENT '积分',
  `type` varchar(50) DEFAULT NULL COMMENT '积分类型',
  `add_time` varchar(100) DEFAULT NULL,
  `from_id` int(11) DEFAULT NULL COMMENT '文章的id',
  `key` varchar(100) DEFAULT NULL COMMENT 'key值',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=158 DEFAULT CHARSET=utf8 COMMENT='积分记录';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `yehnet_points_log`
--

LOCK TABLES `yehnet_points_log` WRITE;
/*!40000 ALTER TABLE `yehnet_points_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `yehnet_points_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `yehnet_session`
--

DROP TABLE IF EXISTS `yehnet_session`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `yehnet_session` (
  `id` varchar(32) NOT NULL COMMENT 'session_id',
  `data` text NOT NULL COMMENT 'session 内容',
  `lasttime` int(10) unsigned NOT NULL COMMENT '时间',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `yehnet_session`
--

LOCK TABLES `yehnet_session` WRITE;
/*!40000 ALTER TABLE `yehnet_session` DISABLE KEYS */;
/*!40000 ALTER TABLE `yehnet_session` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `yehnet_tpl`
--

DROP TABLE IF EXISTS `yehnet_tpl`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `yehnet_tpl` (
  `id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增ID号',
  `langid` varchar(5) NOT NULL DEFAULT 'zh' COMMENT '语言ID，默认是zh',
  `title` varchar(100) NOT NULL COMMENT '名称',
  `folder` varchar(50) NOT NULL COMMENT '文件夹',
  `ext` varchar(10) NOT NULL DEFAULT 'html' COMMENT '模板后缀',
  `autoimg` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '是否自动解析图片地址',
  `ifdefault` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '是否默认',
  `ifsystem` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '1系统模板0用户模板',
  `taxis` tinyint(3) unsigned NOT NULL DEFAULT '255' COMMENT '排序',
  `status` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '1正在使用0未使用',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `yehnet_tpl`
--

LOCK TABLES `yehnet_tpl` WRITE;
/*!40000 ALTER TABLE `yehnet_tpl` DISABLE KEYS */;
/*!40000 ALTER TABLE `yehnet_tpl` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `yehnet_upfiles`
--

DROP TABLE IF EXISTS `yehnet_upfiles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `yehnet_upfiles` (
  `id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT COMMENT '图片ID',
  `title` varchar(100) NOT NULL COMMENT '标题',
  `filename` varchar(255) NOT NULL COMMENT '图片路径，基于网站根目录的相对路径',
  `thumb` varchar(255) NOT NULL COMMENT '缩略图路径，基于网站根目录的相对路径',
  `postdate` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '上传时间',
  `ftype` varchar(10) NOT NULL COMMENT '附件类型',
  `uid` mediumint(8) unsigned NOT NULL DEFAULT '0' COMMENT '会员ID号，0表示管理员上传',
  `flv_pic` varchar(255) NOT NULL COMMENT 'FLV封面图片',
  `sessid` varchar(50) NOT NULL COMMENT '游客上传标识串',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=51 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `yehnet_upfiles`
--

LOCK TABLES `yehnet_upfiles` WRITE;
/*!40000 ALTER TABLE `yehnet_upfiles` DISABLE KEYS */;
/*!40000 ALTER TABLE `yehnet_upfiles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `yehnet_upfiles_gd`
--

DROP TABLE IF EXISTS `yehnet_upfiles_gd`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `yehnet_upfiles_gd` (
  `pid` mediumint(8) unsigned NOT NULL DEFAULT '0' COMMENT '图片ID，对应upfiles里的ID',
  `gdtype` varchar(100) NOT NULL COMMENT '图片类型',
  `filename` varchar(255) NOT NULL COMMENT '图片地址（生成类型的图片地址）',
  PRIMARY KEY (`pid`,`gdtype`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `yehnet_upfiles_gd`
--

LOCK TABLES `yehnet_upfiles_gd` WRITE;
/*!40000 ALTER TABLE `yehnet_upfiles_gd` DISABLE KEYS */;
/*!40000 ALTER TABLE `yehnet_upfiles_gd` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `yehnet_user`
--

DROP TABLE IF EXISTS `yehnet_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `yehnet_user` (
  `id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `groupid` mediumint(8) unsigned NOT NULL DEFAULT '1' COMMENT '会员组ID',
  `rankid` int(11) NOT NULL,
  `openid` varchar(100) DEFAULT NULL COMMENT '微信openid',
  `username` varchar(100) NOT NULL COMMENT '会员名称',
  `verify` varchar(10) DEFAULT NULL,
  `pass` varchar(50) NOT NULL COMMENT '密码',
  `phone` varchar(100) NOT NULL COMMENT '手机',
  `intro_phone` varchar(100) DEFAULT NULL,
  `idnumber` text COMMENT '身份证号',
  `regdate` int(10) unsigned DEFAULT '0' COMMENT '注册时间',
  `status` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '1正常2锁定',
  `fxstatus` tinyint(1) DEFAULT NULL,
  `job` varchar(150) DEFAULT NULL,
  `company` varchar(20) DEFAULT NULL,
  `headimgurl` varchar(200) DEFAULT NULL COMMENT '微信头像',
  `thumb_id` int(10) unsigned DEFAULT NULL COMMENT '个性头像ID',
  `bankAccount` varchar(100) DEFAULT NULL COMMENT '银行卡户主名',
  `cardCode` varchar(100) DEFAULT NULL COMMENT '银行卡号',
  `bankName` varchar(100) DEFAULT NULL COMMENT '银行卡户名称',
  `points` int(11) DEFAULT '0' COMMENT '积分',
  `experience` int(11) DEFAULT '0' COMMENT '经验值',
  `credit_to_cash` int(11) DEFAULT NULL,
  `userguid` varchar(255) DEFAULT NULL,
  `usercode` varchar(255) DEFAULT NULL,
  `createtime` varchar(255) DEFAULT NULL,
  `department_name` varchar(255) DEFAULT NULL,
  `station_name` varchar(255) DEFAULT NULL,
  `nickname` varchar(100) DEFAULT NULL,
  `sex` varchar(4) DEFAULT NULL,
  `province` varchar(20) DEFAULT NULL,
  `city` varchar(20) DEFAULT NULL,
  `add_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=55 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `yehnet_user`
--

LOCK TABLES `yehnet_user` WRITE;
/*!40000 ALTER TABLE `yehnet_user` DISABLE KEYS */;
/*!40000 ALTER TABLE `yehnet_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `yehnet_user_group`
--

DROP TABLE IF EXISTS `yehnet_user_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `yehnet_user_group` (
  `id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT COMMENT '会员组ID',
  `group_type` enum('user','guest') NOT NULL DEFAULT 'user' COMMENT '用户组类型',
  `title` varchar(100) NOT NULL COMMENT '组名称',
  `integral_need` int(11) NOT NULL,
  `rankid` int(11) NOT NULL,
  `content` text NOT NULL COMMENT '特权',
  `popedom_post` text NOT NULL COMMENT '发布权限',
  `popedom_reply` text NOT NULL COMMENT '回复权限',
  `popedom_read` text NOT NULL COMMENT '阅读权限，默认为all',
  `post_cert` tinyint(1) NOT NULL DEFAULT '0' COMMENT '发布0需要验证1免验证',
  `reply_cert` tinyint(1) NOT NULL DEFAULT '0' COMMENT '回复0需要验证1免验证',
  `ifsystem` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否系统组0否1是',
  `ifdefault` tinyint(1) NOT NULL DEFAULT '0' COMMENT '会员注册后默认选择的组',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `yehnet_user_group`
--

LOCK TABLES `yehnet_user_group` WRITE;
/*!40000 ALTER TABLE `yehnet_user_group` DISABLE KEYS */;
/*!40000 ALTER TABLE `yehnet_user_group` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2015-07-29  9:51:03
