'use strict';

module.exports = app => {
  class PostController extends app.Controller {
    * index(ctx) {
      const posts = yield ctx.service.post.list();
      yield ctx.render('index.tpl', {data: posts})
    }

    * new(ctx) {
      yield ctx.render('new.tpl')
    }

    * create(ctx) {
      let title = ctx.request.body.title;
      let body = ctx.request.body.body;
      yield ctx.service.post.newPost(title, body);

      ctx.redirect('/posts');
    }

    * destroy(ctx) {
      let id = ctx.params.id;
      yield ctx.service.post.deletePost(id);

     ctx.body = 'success';
    }

    * show(ctx) {
      let id = ctx.params.id;
      const post = yield ctx.service.post.detail(id);

      yield ctx.render('show.tpl', {data: post})
    }
  }
  return PostController;
};
