'use strict';
const local = require('./config.local');
const prod = require('./config.prod');
module.exports = {
  development: local.sequelize,
  production: prod.sequelize
};