# Striker

[![Code Climate](https://codeclimate.com/github/swaroopsm/striker.png)](https://codeclimate.com/github/swaroopsm/striker)

A Simple & Fast Static Site Generator. Striker has been released as a pre version as of now, to get reviews and bug reports.

## Installation

<!--
Add this line to your application's Gemfile:

    gem 'striker'

And then execute:

    $ bundle

Or install it yourself as:
-->

    $ gem install striker --pre

## Usage

#### Create New Site
	$ striker new my-awesome-site
	$ cd my-awesome-site

##### This creates the following directory structure:
	my-awesome-site/
		css/
		js/
		media/
			images/
			sounds/
			videos/
		pages/
		templates/
		config.yml


#### Create New Page
	$ striker page --new home --title "Home Page" [--no-media | --no-image | --no-sound | --no-video]
Use the appropriate option if you need images or videos or sound.

This creates a page named `home.md` in `pages/`. The content is written in [markdown](http://daringfireball.net/projects/markdown/).
#####The front matter of this page looks like the following
		---
		title: Home Page
		author: Swaroop SM
		date: 2013-10-19
		template: page
		---

		### Home Page

You can include any front-matter, but `title`, `date` and `template` are mandatory fields

The value that you specified for the `template` field, tells the gem to look for a file named `page.html` in the `templates/` directory. Here you can specify the markup of your page.

##### Templating
Striker uses [Liquid Templating](http://liquidmarkup.org).
To define a new template add a file called `my_template.html` in `templates/` and you can specify this template in your `markdown` pages.

#### Dealing with Images
Make sure you have [ImageMagick](http://www.imagemagick.org/script/index.php) installed.

##### Add thumbnail to a page.
If you would like to make an image appear on one of your pages, simply add an image named as `thumbnail.(jpg|png|gif)` to the images directory of your page.
Eg.: If you would like to add a thumbnail to your home page, place a `thumbnail.jpg` in `images/home/thumbnail.jpg`

Then in your `home.md` you can use the custom liquid tag helper to output the image by doing:
######
	{% thumbnail 250w 250h #[image-id] .[image-class] %}

Explanation:
#####
	thumbnail - the tag name
	250w, 250h - The desired width and height that you would like to resize the image
	#[image-id] - Specify id the the image tag
	.[image-class] - Specify class to the image tag

You can specify the size of the image using width/height. or you can also scale the image. For Eg.: If you would like to reduce the size of the image to 50% of the original size, you can do the following:
#####
	{% thumbnail 0.5s #[image-id] .[image-class] %}

To display non-thumbnail images, drop images into the appropriate page's `images/` directory.
Then to display images in your template use the following:
#####
	{% for image in page.images %}
		<img src="{{ image.url }}" />
	{% endfor %}

##### Start the Server
	$ striker strike
This starts the server at `localhost` and port `1619`

### Some Goodies:
##### Adding tags to pages
In your `config.yml`
#
	tagged:
		style: tagged
This specifies the page that you want to serve for tags. For Eg.: if you want something like `http://yoursite.com/tags` change it to the following:
#
	tagged:
		style: tags

To create markup for your templates `striker` provides two files:

To provide markup for the main tags page. Eg.: `http://yoursite.com/tagged` add markup in the following template.

* `templates/tags/index.html`
		
To provide markup for a specific tag page. Eg.: `http://yoursite.com/tagged/ruby` add markup in the following template

* `templates/tags/tag.html`

##### Site Archive
Archive of posts is quite commin in blogs. If you would like to add an archive to your site, follow the below steps:

In your `config.yml` add the following if it does not exist:
#
	archive:
		style: archive
		period: :month

The `style` parameter specifies the path name; the above would create `http://yoursite.com/archive/2013/10`

You can provide two values to the `period` parameter - `:year` or `:month`

The `:year` value would create a path like: `http://yoursite.com/archive/2013`

The `:month` value would create a path like: `http://yoursite.com/archive/2013/10`

*Note:*

For the archive to be fully functional and work as expected you need to provide the `date` in the front-matter of all your pages without which can lead to incorrect results.

The templates for specifying the markup are in `templates/archive/index.html`.

To access all site archives you can use `site.archives` in your templates

To access a specific archive in your archive templates use the following:
#
	{% for page in archive.pages %}
		<a href="{{ page.url }}">{{ page.title }}</a>
	{% endfor %}

##### Helper Tags Available:
*Share current page on twitter*
#
	{% tweet #[hashtag1 hashtag2 hashtag3] @[mention1 mention2 mention3] %}

*Embed YouTube Video*
#####
	{% youtube bNAyPK2O4fk 650w 400h %}

*Embed Vimeo Video*
#####
	{% vimeo 29897413 650w 400h %}

*Embed SoundCloud Track*
#####
	{% soundcloud 3058346 400w 200h %}

#### Site Configuration
| Name			 	|	*Description*			 			|
| :----: 		 	|	:---------		     			|
|	name   	 	 	| *Your Site Name.*	 			|
|	port			 	|	*Port serving the site.* |
|	basepath	 	|	*Path where your website will be hosted.* For Eg.: If you would like to host it on `http://yourwebsite.com/blog`, then you will have to make this value as: `/blog`	 |
|	assets		 	|	*Directory where your stylesheets, images, javascripts etc. will be compiled to.* |
|	destination |	*Directory where the entire site will be compiled to.* |
|	permalink		| *Appearance of page urls.* <br><br> *style* - This can be either `:title` or `:name`. This creates pages with either the *title* specified in each page or *name* - the page name(eg.: index.md) <br><br> *pretty* - This is used to create pages with .html or not. It can either be `true` - creates a url like: `/about` or `false` - that creates a url like `/about.html` |
| tagged			| *Used for adding tags to a site. Helpful if you are running a blog* <br><br> *style* - If you would like to create a url like `http://yoursite.com/tags` the value for this must be `tags` |
| archive 		| *Adds archive to your blog* <br><br> *style* - The url that you would like to have. For Eg.: To have a archive url like `http://yoursite.com/archive`, then the value for this must be `archive` <br><br> *period* - This can be either `:year` or `:month` for respective urls like: `http://yoursite.com/2013` and `http://yoursite.com/2013/10` |
| homepage | Make any of the pages in your `pages/` directory your site's homepage. For Eg.: If you have a `home.md` in your `pages/` directory and then add: `homepage: home`. This when compiled creates an `index.html` for your site |
| include\_assets | Directories that you would like to be compiled into the `assets` directory of your site. |



#### Build Website
	$ striker build
Generate the final website by creating a `public/` directory

<!--
## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
-->


[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/swaroopsm/striker/trend.png)](https://bitdeli.com/free "Bitdeli Badge")

