Linkject
=======

Linkject is a module that helps you parse text and inject links based on the keywords you provide, hence the name Link(in)ject.
Its pretty useful when you're writing documentation and need to inject anchor links to other parts of your documentation page. 

### So what does it support? 
* It can parse both plain text and HTML but it wont do the abominable act of placing an anchor link inside another anchor link.
* Can match full words but wont really overstep the line with matching. 

### Methods
Use the `parse(text,map,options)` to parse `text` (which can be both plain text and HTML), using `map`'s keys to create an 
anchor link in `text`. 
`options` argument can be set to `caseSensitve` which tells the `parse` method whether the matching text should be case 
sensitive or not. `options` defaults to `true`.

### Usage



