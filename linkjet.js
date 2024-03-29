
(function() {
  var cheerio, makeRegex, _;

  cheerio = require('cheerio');

  _ = require('underscore');

  makeRegex = function(keyword, options) {
    var defaults, flags, parse;

    flags = 'g';
    if (!options.caseSensitive) {
      flags += 'i';
    }
    new RegExp("\\b(" + keyword + ")\\b", flags);
    defaults = {
      caseSensitive: true,
      repeat: 0
    };
    return parse = function(text, map, options) {
      var $, countMap, descend, keywords, output, regexMap, replace;

      if (text == null) {
        text = '';
      }
      if (map == null) {
        map = {};
      }
      options = _.extend({}, defaults, options != null ? options : {});
      keywords = Object.keys(map);
      regexMap = {};
      countMap = {};
      output = '';
      $ = cheerio.load("<div class='linkjet-tag-class'>" + text + "</div>");
      keywords.forEach(keyword)(function() {
        regexMap[keyword] = makeRegex(keyword, options);
        return countMap[keyword] = 0;
      });
      descend = function($el) {
        var $children;

        if ($el[0].type === 'tag' && $el[0].name === 'a') {
          return;
        }
        $children = $el.children();
        return $children.each(function() {
          return desecend($(this));
        });
      };
      $el[0].children.forEach(node)(function() {
        if (node.type === 'text') {
          return node.data = replace(node.data);
        }
      });
      replace = function(text) {
        return _.each(regexMap, function(regex, keyword) {
          while (regex.test(text) && (countMap[keyword] < options.repeat || options.repeat === 0)) {
            text = text.replace(regex, "<a href='" + map[keyword] + "' title='" + keyword + "'>$1</a>");
            countMap[keyword]++;
            if (options.repeat === 0) {
              break;
            }
            countMap[keyword] = 0;
            return text;
          }
          descend($('.linkjet-tag-class'));
          return $('.linkjet-tag-class').html();
        });
      };
      return module.exports = {
        parse: parse
      };
    };
  };

}).call(this);
