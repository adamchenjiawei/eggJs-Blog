'use strict';

// had enabled by egg
// exports.static = true;

exports.sequelize = {
  enable: true,
  package: 'egg-sequelize'
};

exports.nunjucks = {
  enable: true,
  package: 'egg-view-nunjucks'
};