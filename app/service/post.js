'use strict';

module.exports = app => {
  return class Post extends app.Service {
    * newPost(title, body) {
      const { model } = this.ctx;
      const post = yield model.Post.create({title: title, body: body});
      return post
    }

    * list() {
      const { model } = this.ctx;
      const posts = yield model.Post.findAll();
      return posts
    }

    * deletePost(id) {
      const { model } = this.ctx;
      yield model.Post.destroy({
        where: {id: id}
      });
      return 'success'
    }

    * detail(id) {
      const { model } = this.ctx;
      const post = yield model.Post.find({
        where: {id: id}
      });
      return post;
    }
  };
};