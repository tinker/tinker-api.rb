# tinker-api

## Tinkers

### Create a new tinker

```
POST /v1/tinkers
```

### Fetch a single tinker

If the revision is omitted, the latest revision will be fetched.

```
GET /v1/tinkers/:hash
GET /v1/tinkers/:hash/:revision
```

```json
{
	"meta": {
		"hash": "b8h5F",
		"revision": 1,
		"title": "Tinker title",
		"description": "Description of the tinker, up to 255 characters"
	},
	"dependencies": {
		"scripts": [
			"http://ajax.googleapis.com/ajax/libs/mootools/1.4.5/mootools.js"
		],
		"styles": [
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
than updating the revision you are `PUT`-ing to. If you attempt to PUT to a url
with a revision appended, you will get a 403 Forbidden code.

```
PUT /v1/tinkers/:hash
```

### Delete a tinker

You cannot `DELETE` any tinkers that do not belong to you, therefore you will
need to authenticate to use this method.

```
DELETE /v1/tinkers/:hash
DELETE /v1/tinkers/:hash/:revision
```

