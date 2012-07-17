# tinker-ruby

`tinker-ruby` is an API for Tinker, written in ruby. This document will attempt
to document how it'll work, but it will build up slowly, since I'm still
figuring out how everything will work/look.

## Tinkers

### Create a new tinker

```
POST /v1/tinker
```

### Fetch a single tinker

If the revision is omitted, the latest revision will be fetched.

```
GET /v1/tinker/b8h5F
GET /v1/tinker/b8h5F/1
```

```json
{
	"meta": {
		"hash": "b8h5F",
		"revision": 1,
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

### Update a tinker

Note: this will actually create a new revision for the current tinker, rather
than updating the revision you are `PUT`-ing to.

```
PUT /v1/tinker/b8h5F
PUT /v1/tinker/b8h5F/1
```

### Delete a tinker

You cannot `DELETE` any tinkers that do not belong to you, therefore you will
need to authenticate to use this method.

```
DELETE /v1/tinker/b8h5F
DELETE /v1/tinker/b8h5F/1
```

