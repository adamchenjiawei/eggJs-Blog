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