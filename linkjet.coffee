#Cheerio module for implementing core jQuery on the server side.
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
		options = _.extend {}, defaults, options ? {}
		keywords = Object.keys map
		regexMap = {}
		countMap = {}
		output = ''

		#wrapping text in div incase the text doesnt contain any markup

		$ = cheerio.load "<div class='linkject-tag-class'>#{text}</div>"

		#create a regex map and use MakeRegex function on the keyword args
		#with options.
		
		keywords.forEach(keyword) ->
			regexMap[keyword] = makeRegex keyword, options
			countMap[keyword] = 0

		
		#create function descend to check through the tags 
		descend = ($el) ->
			return if $el[0].type is 'tag' and $el[0].name is 'a'
			$children = $el.children() #gets the children of the element.
			$children.each () ->
				desecend $(@) 
		
		
		$el[0].children.forEach(node) ->
			if node.type is 'text'
				node.data = replace node.data #replace function used to swap keyword with link

		#a function to replace the text nodes
		replace = (text) ->
			_.each regexMap, (regex,keyword) ->
				while regex.test(text) and (countMap[keyword] < options.repeat or options.repeat is 0)
					text = text.replace regex, "<a href='#{map[keyword]}' title='#{keyword}'>$1</a>"
					countMap[keyword]++
					break if options.repeat is 0
					countMap[keyword] = 0
					return text
				descend $('.linkject-tag-class')
				$('.linkject-tag-class').html()


		#export the one and only Parse function.
		module.exports = {parse: parse}

		
		#GLORY

