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

