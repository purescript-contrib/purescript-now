"use strict";

exports.now = function () {
  return Date.now();
};

exports.getTimezoneOffset = function (date) {
  return date.getTimezoneOffset()
};
