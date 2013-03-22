#Cheerio module used to include parsing texts and injecting link nodes 
#
cheerio = require 'cheerio'
_= require 'underscore'

makeRegex = ( keyword, options ) ->
	flags = 'g'
	flags += 'i' unless options.caseSensitive #make the thing case insensitive otherwise

	new RegExp "\\b(#{keyword})\\b", flags #this is the final regex

	defaults =
		caseSensitive: true
		repeat: 0

	parse = (text, map, options) ->
		text ?= ''
		map ?= {}
		options = _.extend{}, defaults, options ? {}
		keywords = Object.keys map
		regexMap = {}
		countMap = {}
		output = ''

		#wrapping text in div incase the text doesnt contain any markup

		$ = cheerio.load "<div class='linkjet-tag-class'>#{text}</div>"

		#create a regex map and use MakeRegex function on the keyword args
		#with options.
		
		keywords.forEach(keyword) ->
			regexMap[keyword] = makeRegex keyword, options
			countMap[keyword] = 0

		
		#create function descend to check through the tags 
		descend = ($el) ->
			return if $el[0].type is 'tag' and $el[0].name is 'a'
			$children = $el.children()
			$children.each () ->
				desecend $(@)
		
		#a function to Parse text nodes
		$el[0].children.forEach(node) ->
			if node.type is 'text'
				node.data = replace node.data

		#a function to replace the text nodes
		replace = (text) ->
			_.each regexMap, (regex,keyword) ->
				while regex.test(text) and (countMap[keyword] < options.repeat or options.repeat is 0)
					text = text.replace regex, "<a href='#{map[keyword]}' title='#{keyword}'>$1</a>"
					countMap[keyword]++
					break if options.repeat is 0
					countMap[keyword] = 0
					return text
				descend $('.linkjet-tag-class')
				$('.linkjet-tag-class').html()


		
		module.exports = {parse: parse}

		
		#GLORY

