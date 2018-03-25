require('coffeescript/register');
var mincer = require('mincer');
mincer.Template.libs.coffee = require('coffeescript');
module.exports = require('./app');