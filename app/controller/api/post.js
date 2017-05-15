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
