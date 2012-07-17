# tinker-ruby

`tinker-ruby` is an API for Tinker, written in ruby. This document will attempt
to document how it'll work, but it will build up slowly, since I'm still
figuring out how everything will work/look.

```
GET /v1/tinker/b8h5F
```

```json
{
	"meta": {
		"title": "Tinker title",
		"description": "Description of the tinker, up to 255 characters"
	},
	"dependancies": {
		"javascripts": [
			"http://ajax.googleapis.com/ajax/libs/mootools/1.4.5/mootools.js"
		],
		"stylesheets": [
			"https://github.com/necolas/normalize.css/raw/master/normalize.css"
		]
	},
	"code": {
		"markup": {
			"type": "html",
			"body": "<p>Hello!</p>"
		},
		"style": {
			"type": "css",
			"body": "body { color: red; }"
		},
		"behaviour": {
			"type": "js",
			"body": "document.getElement('p').setStyle('color', 'blue');"
		}
	}
}
```
