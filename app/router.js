'use strict';

module.exports = app => {
  app.get('/', 'home.index');

  app.get('/posts', 'post.index');
  app.get('/posts/new', 'post.new');
  app.post('/posts', 'post.create');
  app.delete('/posts/:id', 'post.destroy');
  app.get('/posts/:id', 'post.show');
};

