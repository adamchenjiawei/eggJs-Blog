# 使用 eggJS 快速打造一个Blog管理系统

EggJS+Mysql+sequelize+Bootstrap
搭建Blog管理系统

标签（空格分隔）： Node

---

[TOC]
## 案例项目Github

git地址： https://github.com/adamchenjiawei/eggJs-Blog

## 第一章：环境准备

教程使用系统：macOS （windows系统下命令行使用 Xshell 或者 Cmd）
开发环境： nodejs  版本：6.0 以上 、npm
使用框架： eggjs
数据库：mysql  版本5.5以上
前端UI框架：Bootstrap


### 1.1 安装nodeJs

```
nodejs官网：http://nodejs.cn/
1. 下载对应系统的安装文件（这里下载的是macOS版本的 node-v6.10.3.pkg）
2. 开始安装（其他系统安装步骤自行百度）

```

### 1.2 安装eggjs

*tip:  可以给npm替换源，能够更快的安装包*
```
// 替换源方法：
// 使用 nrm 参考：http://www.jianshu.com/p/5dd18d246281
** Install **
npm install -g nrm

** Example **

$ nrm ls

* npm ---- https://registry.npmjs.org/
  cnpm --- http://r.cnpmjs.org/
  eu ----- http://registry.npmjs.eu/
  au ----- http://registry.npmjs.org.au/
  sl ----- http://npm.strongloop.com/
  nj ----- https://registry.nodejitsu.com/

$ nrm use cnpm //switch registry to cnpm

    Registry has been set to: http://r.cnpmjs.org/

```

安装Egg
```
// 安装完成 nodejs 之后，npm也安装好了。

npm i egg-init -g

```


### 1.3 安装数据库Mysql

官网下载地址：https://dev.mysql.com/downloads/mysql/
选择对应系统的安装文件。

**教程**
1. Mac下安装Mysql dmg安装文件教程：
http://jingyan.baidu.com/article/59a015e34d2b72f7948865cf.html
http://www.jianshu.com/p/fd3aae701db9
2. Window下安装Mysql  安装教程：http://blog.csdn.net/zhouzezhou/article/details/52446608

---------

*tip: mysql可视化工具*

mac: `sequel pro`  http://www.pc6.com/mac/133145.html
windows: `Navicat for Mysql`  http://download.csdn.net/detail/abc_email/9501830


## 第二章 起步

### 2.1 初始化一个eggJS项目

```
$ egg-init egg-example --type=simple   // 初始化项目
$ cd egg-example  // 进入项目目录
$ npm i    // 安装项目依赖包

#启动
$ npm run dev    // 默认启动端口7001 如果端口被占用会自动切换端口
$ open http://localhost:7001/   // 在浏览器中打开该地址，看到`hi, egg` 第一步就成功了！

```

### 2.2 添加Sequelize ORM框架
为什么使用：使用orm框架，简化了数据库查询过程。
官方文档：http://docs.sequelizejs.com/en/v3/

egg-sequelize Github插件： https://github.com/eggjs/egg-sequelize
sequelize-cli Github插件： https://github.com/sequelize/cli

* 添加Sequelize ORM框架
* 添加Sequelize-cli 命令台工具（主要使用 migrate功能维护创建数据表结构）

**安装**
2.2.1. 安装所需包
```
# 以下在项目目录下安装：

# 安装 Sequelize
$ npm i --save egg-sequelize
# 由于使用的mysql数据库需要安装相关包
$ npm install --save mysql
# sequelize的命令行工具
$ npm install --save sequelize-cli

```

**配置插件**

2.2.2. 添加egg-sequelize插件配置 (添加以下内容)
```
// egg-example/config/plugin.js


exports.sequelize = {
  enable: true,
  package: 'egg-sequelize'
};


```

2.2.3. 配置sequelize-cli 文件目录符合当前项目目录结构

```
$ cd egg-example/

在根目录下创建文件 .sequelizerc

```

```
// egg-example/.sequelizerc
const path = require('path');

module.exports = {
  config: path.resolve('config', 'sequelize.js'),
  migrationsPath: path.resolve('app', 'migrate'),
  seedersPath: path.resolve('app', 'seed'),
  modelsPath: path.resolve('app', 'model')
}

```

2.2.4. 执行命令自动创建sequelize文件目录结构

```
在项目目录下执行： egg-example/

// windows CMD下执行以下会出问题
// windows用户建议使用xshell或者gitbash
// 必须在 egg-example/ 根目录下执行才能读取配置文件 .sequelizerc

$ node_modules/.bin/sequelize init



// 生成一个配置文件和三个目录
//  egg-example/config/sequelize.js  配置文件
//  egg-example/app/migrate/   migrate文件维护数据表结构和创建
//  egg-example/app/seed/     数据库一些初始化操作
//  egg-example/app/model/     数据模型
```


### 2.3 连接数据库配置&创建表

**创建数据库**
方式一： 通过mysql可视化工具创建数据库，数据库命名： egg_db

方式二： 通过mysql命令行创建数据库
```
1). 手动在mysql中创建数据库egg_db （还没有看到sequelize是否有提供创建数据库的命令）
   a. 登陆
   mysql： mysql -uroot -p
   b. 创建数据库：
   CREATE DATABASE IF NOT EXISTS egg_db DEFAULT CHARSET utf8 COLLATE utf8_general_ci;

```

**编辑egg-example项目数据库配置**

2.3.1. 将 sequelize.js 文件内容清空，写入以下内容
```
// egg-example/config/sequelize.js

'use strict';

const local = require('./config.local');
const prod = require('./config.prod');

module.exports = {
  development: local.sequelize,
  production: prod.sequelize
};

```

2.3.2. 在 egg-example/config/ 目录下创建以下2个文件
`config.local.js`  :开发环境项目启动读取的配置文件
`config.prod.js`   :生产环境项目启动读取的配置文件

```
// egg-example/config/config.local.js  or config.prod.js
'use strict';

exports.sequelize = {
  dialect: 'mysql', // support: mysql, mariadb, postgres, mssql
  dialectOptions: {
    charset: 'utf8mb4'
  },
  database: 'egg_db',
  host: 'localhost',
  port: '3306',
  username: 'root',
  password: '123456',
  timezone : "+08:00"
};

```

**创建数据表**

创建包含title和body的post表

2.3.3. 创建数据表迁移文件migrate: `20170513152504-create-posts.js`
```
// app/migrate/20170513152504-create-posts.js

'use strict';

module.exports = {
  up(queryInterface, Sequelize) {
    const { INTEGER, STRING, DATE } = Sequelize;
    return queryInterface.createTable('posts', {
      id: {
        type: INTEGER,
        primaryKey: true,
        autoIncrement: true,
      },
      title: {
        type: STRING,
        comment: '标题'
      },
      body: {
        type: STRING,
        comment: '内容'
      },
      created_at: {
        type: DATE
      },
      updated_at: {
        type: DATE
      }
    });
  },

  down(queryInterface) {
    return queryInterface.dropTable('posts');
  }
};

```

2.3.4. 执行migrate命令生成表结构
```
在项目目录下 egg-example/

// windows CMD下执行以下会出问题
// windows用户建议使用xshell或者gitbash
// 必须在 egg-example/ 根目录下执行才能读取配置文件 .sequelizerc

$  node_modules/.bin/sequelize  db:migrate
// 数据库中就已经创建好了 posts 表
```

### 2.4 配置前端渲染模板

`
这里使用的是官方文档案例的模板引擎： Nunjucks
`
官方文档：http://mozilla.github.io/nunjucks/api.html

2.4.1. 安装插件： egg-view-nunjucks
```
// 在项目目录下安装

$ npm i egg-view-nunjucks --save
```

2.4.2. 配置插件
开启插件(添加以下配置)
```
// config/plugin.js


exports.nunjucks = {
  enable: true,
  package: 'egg-view-nunjucks'
};

```

配置默认模板渲染引擎（添加以下配置）
内容添加在 `return config;` 上面
```
// config/config.defalut.js


 // add your config here
  config.view = {
    defaultViewEngine: 'nunjucks',
    mapping: {
      '.tpl': 'nunjucks',
    },
  };


```

## 第三章 搭建blog

搭建blog之前，我们先来了解下eggJs的部分文件目录结构。

详细目录结构参考官方文档：https://eggjs.org/zh-cn/basics/structure.html

部分目录：
```
egg-example
├── app
|   ├── router.js
│   ├── controller
│   |   └── post.js
│   ├── service
│   |   └── post.js
│   ├── public
│   |   └── reset.css
│   ├── view
│   |   └── index.tpl
│   ├── model
│   |   └── post.js
│   ├── migrate
│   |   └── 20170513152504-create-posts.js
├── config
```

* `app/router.js` 用于配置URL路由规则。
* `app/controller/**`
1. 用于解析用户的输入，处理后返回相应的结果。
2. 在 HTML 页面请求中，Controller 根据用户访问不同的 URL，渲染不同的模板得到 HTML 返回给用户。
* `app/service/**` 用于编写业务逻辑层。
* `app/public/**` 用于放置静态资源。
* `app/view/**` 用于放置前端模板文件。
* `app/model/**` 用于放置sequelize相关模型。
* `app/migrate/**` 用于放置sequelize-cli相关数据库迁移文件

### 3.1 编写blog模块

3.1.1. 创建controller文件：
```
// app/controller/post.js
// 定义一个action：index()

'use strict';

module.exports = app => {
  class PostController extends app.Controller {
    * index(ctx) {
      yield ctx.render('index.tpl', {data: 'hello blog'})
    }
  }
  return PostController;
};


```

3.1.2. 配置router.js
```
// app/router.js

'use strict';

module.exports = app => {
  app.get('/', 'home.index');

  app.get('/posts', 'post.index');
};

```
这样就完成了一个最简单的 Router 定义，当用户执行 `GET /posts`，`app/controller/post.js` 这个里面的 index 方法就会执行。

3.1.3. 编写view界面

新建`app/view/`文件目录
```
// 创建index.tpl文件
// app/view/index.tpl

<html>
<head>
  <title></title>
</head>
<body>
  <h1>{{data}}</h1>
</body>
</html>

```

访问 `http://localhost:7001/posts`
能够看到页面显示 hello blog


### 3.2 引入Bootstrap

官网：http://v3.bootcss.com/

3.2.1. 到官网下载bootstrap

3.2.2. 将下载的bootstrap.min.js 、 bootstrap.min.css 拷贝到项目目录下 `app/pulic/`

3.2.3. 需要调用时在前端页面添加以下标签
```
<link rel="stylesheet" href="/public/bootstrap.min.css" type="text/css">

<script src="/public/bootstrap.min.js"></script>
```


### 3.3 Blog新建内容

3.3.1. 新建一个view: `new.tpl`

```
// app/view/new.tpl

<html>
<head>
  <title></title>
  <link rel="stylesheet" href="/public/bootstrap.min.css" type="text/css">
</head>
<body>
<form action="/posts" method="post" id="article-form">
  <div class="form-group">
    <label>标题</label>
    <input type="text" class="form-control" placeholder="标题" name="title">
  </div>
  <div class="form-group">
    <label>正文内容</label>
    <textarea  class="form-control" rows="3" name="body">
    </textarea>
  </div>

  <input class="btn btn-default" type="submit" value="Submit">
</form>

<script src="/public/bootstrap.min.js"></script>
</body>
</html>

```

3.3.2. 增加新建blog router设置 (新添加以下内容)
```
// app/router.js

  app.get('/posts/new', 'post.new');
  app.post('/posts', 'post.create');

```

3.3.3. 由于需要将数据存入数据库，创建sequelize相关的数据模型
，操作数据库。
新建model： `app/model/post.js`
```
// app/model/post.js

'use strict';

module.exports = app => {
  const {INTEGER, STRING, DATE} = app.Sequelize;

  return app.model.define('posts', {
    id: {
      type: INTEGER,
      primaryKey: true,
      autoIncrement: true,
    },
    title: {
      type: STRING,
      comment: '标题'
    },
    body: {
      type: STRING,
      comment: '内容'
    },
    created_at: {
      type: DATE
    },
    updated_at: {
      type: DATE
    }
  });
};

```

3.3.4. 配置controller，使之能够访问新建blog的页面

新增以下的配置信息
添加2个action
new： 新添加blog的页面
create： 添加blog执行的方法，保存之后重定向到 `/posts` 地址
```
// app/controller/post.js

   * new(ctx) {
      yield ctx.render('new.tpl') // 指定渲染new.tpl 模板
    }

   * create(ctx) {
     let title = ctx.request.body.title;
     let body = ctx.request.body.body;
     yield ctx.service.post.newPost(title, body);

     ctx.redirect('/posts');  // 重定向到posts首页
  }

```

3.3.5. 新建一个service文件，用来处理存储post数据逻辑。

a. 在`app/` 下新建目录`service`

b. 在`app/service/`下新建文件:`post.js`
```
// app/service/post.js

'use strict';

module.exports = app => {
  return class Post extends app.Service {
    * newPost(title, body) {
      const { model } = this.ctx;
      const post = yield model.Post.create({title: title, body: body});
      return post
    }
  };
};

```

定义的`newPost`方法在controller中的`create` action中调用。


3.3.6. 将我们新建的数据展示出来，修改 `index.tpl`增加列表

```
// app/view/index.tpl

<html>
<head>
  <title></title>
  <link rel="stylesheet" href="/public/bootstrap.min.css" type="text/css">
</head>
<body>
<h1> Blog Index </h1>

<a class="btn btn-success" href="/posts/new" role="button">新增Blog</a>
<table class="table table-bordered">
  <tr>
    <td>title</td>
    <td>body</td>
  </tr>
  {% for post in data %}
  <tr class="info">
    <td>{{ post.title }}</td>
    <td>{{ post.body }}</td>
  </tr>
  {% endfor %}
</table>
<script src="/public/bootstrap.min.js"></script>
</body>
</html>

```

同时修改对应的controller的`index` action
修改`index`方法
```
// app/controller/post.js

* index(ctx) {
      const posts = yield ctx.service.post.list();
      yield ctx.render('index.tpl', {data: posts})
    }
```

service：`post.js` 新增`list`方法获取post列表

```
// app/service/post.js  新增方法 list

    * list() {
      const { model } = this.ctx;
      const posts = yield model.Post.findAll();
      return posts
    }

```

3.3.7. 验证我们新建blog功能

a. 打开：http://localhost:7001/posts

b. 点击button`新增Blog`

c. 创建内容

b. 验证table列表中是否有新创建的内容。


### 3.4 查看Blog详情 & 删除Blog数据

接下来我们来做下Blog的详情查看和删除功能。

3.4.1. 修改`index.tpl` 页面，增加`详情`&`删除` 按钮。

```
//  app/view/index.tpl

<html>
<head>
  <title></title>
  <link rel="stylesheet" href="/public/bootstrap.min.css" type="text/css">
</head>
<body>
<h1> Blog Index </h1>

<a class="btn btn-success" href="/posts/new" role="button">新增Blog</a>
<table class="table table-bordered">
  <tr>
    <td>title</td>
    <td>body</td>
    <td>操作</td>
  </tr>
  {% for post in data %}
  <tr class="info">
    <td>{{ post.title }}</td>
    <td>{{ post.body }}</td>
    <td>
      <a class="btn btn-info" href="/posts/{{ post.id }}" role="button">详情</a>
      <a class="btn btn-danger" onclick="deletePost(this)" data-id="{{ post.id }}" role="button">删除</a>
    </td>
  </tr>
  {% endfor %}
</table>
<script src="https://cdn.bootcss.com/jquery/3.2.1/jquery.min.js"></script>
<script src="/public/bootstrap.min.js"></script>
<script>
  function deletePost(self){
    let id = $(self).attr('data-id');
    if (confirm("确定要删除？")) {
      $.ajax({
        contentType: "text;charset=utf-8",
        type: "DELETE",
        url: `/posts/${id}`,
        dataType: "text",
        async: true,
        success: function (res) {
          location.reload();
        }
      });
    }
  }

</script>
</body>
</html>


```

3.4.2. 显示Blog详情

a.  新增页面:`show.tpl`

```
// app/view/show.tpl

<html>
<head>
  <title></title>
  <link rel="stylesheet" href="/public/bootstrap.min.css" type="text/css">
</head>
<body>
<h1> Blog Show </h1>
<a class="btn btn-success" href="/posts" role="button">首页</a>

<div class="form-group">
  <label>标题</label>
  <p>{{ data.title }}</p>
</div>
<div class="form-group">
  <label>正文内容</label>
  <textarea  class="form-control" rows="3" name="body">
    {{ data.body }}
    </textarea>
</div>

<script src="/public/bootstrap.min.js"></script>
</body>
</html>

```

b. 配置对应的`router` 和 `controller` 以及数据查询逻辑 `service`

```
//  app/router.js 新增路由

app.get('/posts/:id', 'post.show');

```

```
// app/controller/post.js
// 新增action： show

    * show(ctx) {
      let id = ctx.params.id;
      const post = yield ctx.service.post.detail(id);

      yield ctx.render('show.tpl', {data: post})
    }
```

```
//  app/service/post.js
// 添加相应的处理方法

   * detail(id) {
      const { model } = this.ctx;
      const post = yield model.Post.find({
        where: {id: id}
      });
      return post;
    }
```

c. 验证查看详情功能

打开 http://localhost:7001/posts
新增一条数据，点击`详情`按钮。

3.4.3. 删除Blog数据

a. 配置对应的`router` 和 `controller` 以及数据删除逻辑 `service`
```
// app/router.js

app.delete('/posts/:id', 'post.destroy');

```

```
// app/controller/post.js
// 新增Action: destroy

    * destroy(ctx) {
      let id = ctx.params.id;
      yield ctx.service.post.deletePost(id);

     ctx.body = 'success';
    }


```

```
//  app/service/post.js
// 添加方法 deletePost()

 * deletePost(id) {
      const { model } = this.ctx;
      yield model.Post.destroy({
        where: {id: id}
      });
      return 'success'
    }

```

b. 开始验证删除功能

打开 http://localhost:7001/posts
新建一条数据，然后点击删除按钮。
```
这个时候会发现数据并没有删除。

打开chrome浏览器的调试工具，查看NetWork， 可以看到发起的delete请求，状态为403。

```
这是因为：Egg 内置的 egg-security 插件默认对所有『非安全』的方法，例如 `POST`，`PUT`，`DELETE` 都进行 CSRF 校验。

c、解决CSRF 校验问题

为了解决以上的问题，我们可以将csrf校验关闭。

修改配置`config.defalut.js`
新添内容在`return config;` 上面

```
// config/config.default.js

 config.security = {
      csrf: {
      enable: false,
    },
  };

```

再次验证，这次就能够正确的删除数据了。


Blog简单管理功能就完成了。


**tip**

最后我们来看下我们的路由配置

```
// app/router.js

'use strict';

module.exports = app => {
  app.get('/', 'home.index');

  app.get('/posts', 'post.index');
  app.get('/posts/new', 'post.new');
  app.post('/posts', 'post.create');
  app.delete('/posts/:id', 'post.destroy');
  app.get('/posts/:id', 'post.show');

  // 也可以使用以下配置替换上面posts的请求
  // 可以参考 https://eggjs.org/zh-cn/basics/router.html  # RESTful 风格的 URL 定义
  // app.resources('posts', '/posts', 'post');
};


```

我们也可以用RESTful的风格定义路由。

我们把每个url看做一种资源，对资源不同的操作可以通过HTTP请求方法描述。

| 请求方式 | 操作 |
| -- | -- |
| GET（SELECT）| 从服务器取出资源（一项或多项） |
| POST（CREATE） | 在服务器新建一个资源。 |
| PUT（UPDATE） | 在服务器更新资源（客户端提供改变后的完整资源）。 |
| DELETE（DELETE） | 从服务器删除资源。 |


Egg的`app.resources('posts', '/posts', 'post');`
会为我们生产CURD的路由结构，我们只需要在controller添加对应的Action就可以对应到指定的路由地址了。
| Method | Path | Route Name | Controller.Action |
| -- | -- |
| GET |	/posts | posts | app.controllers.posts.index |
| GET |	/posts/new | new_post |	app.controllers.posts.new |
| GET | /posts/:id | post |	app.controllers.posts.show |
| GET |	/posts/:id/edit	| edit_post |	app.controllers.posts.edit |
| POST | /posts	| posts | app.controllers.posts.create |
| PUT |	/posts/:id | post |	app.controllers.posts.update |
| DELETE | 	/posts/:id | 	post |	app.controllers.posts.destroy


## 第四章 如何提供API

4.1、 在controller目录下新建一个api文件目录
新建一个`post.js`

```
// app/controller/api/post.js

'use strict';

module.exports = app => {
  class PostController extends app.Controller {
    * index(ctx) {
      const posts = yield ctx.service.post.list();

      ctx.body = {status: {code: 0, message: 'success'}, data: posts};
    }
  }
  return PostController;
};


```

4.2、修改Router.js

```
// app/router.js

app.get('/api/posts', 'api.post.index');

```

4.3、 最后我们来验证一下

首先在http://localhost:7001/posts 新添加几条数据。
然后访问 http://localhost:7001/api/posts  就能够看到刚刚新添加的JSON数据了。



## 第五章 开始部署

### 5.1 生产环境部署项目

启动脚本：

```
$ sh start.sh start  // 启动项目

$ sh start.sh stop  // 停止项目

$ sh start.sh restart  // 重启项目
```

在项目中新建sh文件：
egg-example/start.sh

需要将`PROJECT_PATH` 修改成自己的项目路径。

`stdout.log`、`stderr.log` 项目启动的日志输出以及错误日志。

启动项目后打开：http://localhost:8000/posts 就能够看到项目启动成功了。


```
# start eggjs project

PROJECT_PATH=/Users/adam/Documents/private_repo/egg-example
PROC_NAME="EggExample"
NODE_PORT=8000


start() {
	cd "${PROJECT_PATH}"
	PORT=${NODE_PORT} EGG_SERVER_ENV=prod nohup node index.js --${PROC_NAME} > stdout.log 2> stderr.log &

	proc_id=`ps -ef | grep -i ${PROC_NAME} | grep -v "grep"|awk '{print $2}'`
    echo '---------deployed'
	echo ${PROC_NAME} "pid: "
	echo $proc_id
}

stop() {
	proc_id=`ps -ef | grep -i ${PROC_NAME} | grep -v "grep"|awk '{print $2}'`
	if [[ -z $proc_id ]]; then
		echo "The Task is not running!"
	else
		echo ${PROC_NAME}" pid: "
		echo $proc_id
		echo "-------kill the task"
		for id in ${proc_id[*]}
        do
        	echo ${id}
        	thread=`ps -mp ${id}|wc -l`
        	echo "theads number: "${thread}
        	kill ${id}
        if [ $? -eq 0 ]; then
        	echo "task is killed..."
        else
            echo "kill task failed"
        fi
	    done
	fi
}


case "$1" in
  start)
        start
        ;;
  stop)
        stop
        ;;
 restart|reload)
        stop
        start
        ;;
  *)
        echo "Usage: $0 {start|stop|restart|reload}"
        ;;
esac

```



## 本文参考资料
NodeJS官方网站：http://nodejs.cn/

nrm（npm源管理工具）：http://www.jianshu.com/p/5dd18d246281

Mysql官网地址：https://dev.mysql.com/downloads/mysql/

Mac下安装Mysql dmg安装文件教程：
http://jingyan.baidu.com/article/59a015e34d2b72f7948865cf.html
http://www.jianshu.com/p/fd3aae701db9

Window下安装Mysql  安装教程：http://blog.csdn.net/zhouzezhou/article/details/52446608

EggJs官方文档：https://eggjs.org/zh-cn/intro/index.html

Sequelize官方文档：http://docs.sequelizejs.com/en/v3/

前端模板渲染引擎Nunjucks： http://mozilla.github.io/nunjucks/api.html

Bootstrap官网：http://www.bootcss.com/

