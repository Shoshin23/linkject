

cheerio = require 'cheerio'
_= require 'underscore'

makeRegex = ( keyword, options ) ->
	flags = 'g'
	flags += 'i' unless options.caseSensitive

	new RegExp "\\b(#{keyword})\\b", flags

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
		
		#create function descend to check through the tags 
		
		#a function to Parse text nodes
		
		#a function to replace the text nodes
		
		#export parse
		
		#GLORY

