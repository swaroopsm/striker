# Striker

<!--
[![Code Climate](https://codeclimate.com/github/swaroopsm/striker.png)](https://codeclimate.com/github/swaroopsm/striker)
-->

A Simple & Fast Static Site Generator. Striker has been released as a pre version as of now, to get reviews and bug reports.

## Installation

<!--
Add this line to your application's Gemfile:

    gem 'striker'

And then execute:

    $ bundle

Or install it yourself as:
-->
	
	$ git clone git@github.com:swaroopsm/striker.git

   <!-- $ gem install striker --pre -->
   

## Usage

#### Create New Site
	$ bin/striker new my-awesome-site
	$ cd my-awesome-site

##### This creates the following directory structure:
	my-awesome-site/
		css/
		extras/
		includes/
		js/
		media/
			images/
			sounds/
			videos/
		pages/
		plugins/
		templates/
		config.yml
		server.yml

#### Directory Structure
#
	css/
	Contains all stylesheets.
#
	extras/
	Contains any files that you would like to include in your destination. 
	Eg.: Files like sitemap.xml, robots.txt, .htaccess etc.
#
	includes/
	Contains pages that you would like to include in your templates
	Eg.: header.html, footer.html, analytics.html etc.
#
	js/
	Contains all javascripts.
#
	media/
	Contains page specific images etc.
	If you would lke to add an image to a page about-us, then you need to add it in media/images/about-us/image.png
	If you would like to add an image that is available throughtout the site, like a logo.jpg, you can add it im media/images/logo.png
#
	pages/
	Contains all the pages that are in markdown.
#
	plugins/
	Contains all your custom plugins. These plugins are written in ruby.
#
	templates/
	Contains markup for your pages.
#
	config.yml
	Configuration file for the website, that striker depends on.
#
	server.yml
	Configuration file for uploading your website on to your production server.


#### Create New Page
	$ bin/striker page --new about-us --title "About Us" [--no-media | --no-image | --no-sound | --no-video]
Use the appropriate option if you need images or videos or sound.

This creates a page named `about-us.md` in `pages/`. The content is written in [markdown](http://daringfireball.net/projects/markdown/).
#####The front matter of this page looks like the following
		---
		title: About Us
		author: Swaroop SM
		date: 2013-10-19
		template: page
		---

		### About Us

You can include any front-matter, but `title`, `date` and `template` are mandatory fields

The value that you specified for the `template` field, tells the gem to look for a file named `page.html` in the `templates/` directory. Here you can specify the markup of your page.

##### Templating
Striker uses [Liquid Templating](http://liquidmarkup.org).
To define a new template add a file called `my_template.html` in `templates/` and you can specify this template in your `markdown` pages.

#### Dealing with Images
Make sure you have [ImageMagick](http://www.imagemagick.org/script/index.php) installed.

##### Add thumbnail to a page.
If you would like to make an image appear on one of your pages, simply add an image named as `thumbnail.(jpg|png|gif)` to the images directory of your page.
Eg.: If you would like to add a thumbnail to your about-us page, place a `thumbnail.jpg` in `images/about-us/thumbnail.jpg`

Then in your `about-us.md` you can use the custom liquid tag helper to output the image by doing:
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
	name: tagged
This specifies the page that you want to serve for tags. For Eg.: if you want something like `http://yoursite.com/blog/tags` change it to the following:
#
	tagged: 
	name: tags
	permalink: blog/

Creating markup for your tag template:

To provide markup for specific tag. Eg.: `http://yoursite.com/tagged/ruby` add markup in the following template.

* `templates/tags/tag.html`
		
Here you get the `tagged` variable that contains the following fields:
#
	tagged.name: The name of the tag
	tagged.pages: All pages that have the specified tag name

<!--
##### Site Archive
Archive of posts is quite commin in blogs. If you would like to add an archive to your site, follow the below steps:

In your `config.yml` add the following if it does not exist:
#
	archive: /
	OR
	archive: archive_url_name

*Note:*

For the archive to be fully functional and work as expected you need to provide the `date` in the front-matter of all your pages without which can lead to incorrect results.

The templates for specifying the markup are in `templates/archive/yearly.html` and `templates/archive/monthly.html`.

To access all site archives you can use `site.archives` in your templates

To access a specific archive in your archive templates use the following:
#
	{% for page in pages %}
		<a href="{{ page.url }}">{{ page.title }}</a>
	{% endfor %}
-->

##### Generating Sitemap
[Sitemaps](http://en.wikipedia.org/wiki/Sitemaps) are useful for search engines to crawl url's on a website.

To generate a `sitemap.xml` and `robots.txt` run the following:
	
	bin/striker sitemap
This generates `sitemap.xml` and `robots.txt` in the `extras/` directory.

##### Helper Tags Available:
*Share current page on twitter*
#
	{% tweet #[hashtag1 hashtag2 hashtag3] @[mention1 mention2 mention3] %}

*Embed Github Gist*
#
	{% gist swvist 2692786 %}

*Embed YouTube Video*
#####
	{% youtube bNAyPK2O4fk 650w 400h %}

*Embed Vimeo Video*
#####
	{% vimeo 29897413 650w 400h %}

*Embed SoundCloud Track*
#####
	{% soundcloud 3058346 400w 200h %}

*Include Page*
#####
	{% include header %}

*Sections*
If you would like to target a particular content of your markdown in a specific html element in your template, then use the following in your markdown file:

	{% section mysection %}
	Hi, this is a section
	{% endsection mysection %}

And you can display this `section` in your template by using:

	{{ page.sections.mysection }}

<!--
#### Available Page Data
*Note that all variables configured in the `yaml front-matter` for each page and all site config that is mentioned in the following section is availble with `page` and `site` variables. For Eg.: If you would like to display the page title you can use `{{ page.title }}`. Similarly to display the `site name`, you can use `{{ site.name }}`*

Additional variables provided by `striker` for each page is as follows:

| *Variable* | *Description* |
| :---:			 | :------			 |
| name			 | *Name of the page that is url friendly* |
| url				 | *The full url path of a page* |
| thumbnail  | *The image source, content-type and the url of the thumbnail for the page* |
| filename   | *The filename of the page* <br><br>Eg.: If you have a filename called `index.md` in your `pages` directory then the value for this will be `index.md` |
| base_dir   | *The filename without the extension* |
| images		 | *List of all images w.r.t a page* |

#### Site Configuration
| Name			 	|	*Description*			 			|
| :----: 		 	|	:---------		     			|
|	name   	 	 	| *Your Site Name.*	 			|
|	port			 	|	*Port serving the site.* |
|	basepath	 	|	*Path where your website will be hosted.* For Eg.: If you would like to host it on `http://yourwebsite.com/blog`, then you will have to make this value as: `/blog`	 |
|	assets		 	|	*Directory where your stylesheets, images, javascripts etc. will be compiled to.* |
|	destination |	*Directory where the entire site will be compiled to.* |
|	permalink		| *Appearance of page urls.* <br><br> *style* - This can be either `:title` or `:name`. This creates pages with either the *title* specified in each page or *name* - the page name(eg.: index.md) <br><br> *pretty* - This is used to create pages with .html or not. It can either be `true` - creates a url like: `/about` or `false` - that creates a url like `/about.html` <br><br> You can also override this property by specifying this option in the `yaml front-matter` of your individual pages.|
| tagged			| *Used for adding tags to a site. Helpful if you are running a blog* <br><br> *style* - If you would like to create a url like `http://yoursite.com/tags` the value for this must be `tags` |
| archive 		| *Specify the archive style*.<br><br> For Eg.: To have a archive url like `http://yoursite.com/archive/2013/09/`, then the value for this must be `archive` <br><br>If you would like to ignore a specific page to be listed in the archive you can add `ignore_archive: true` in the `yaml front-matter` of the respective page. <br><br>To have a archive url like `http://yoursite.com/2013/09/`, then the value for this must be `/` <br><br> To add your content for the `yearly` and `monthly` archive edit the `templates/archive/yearly.html` and `templates/archive/monthly.html` files respectively|
| homepage | Make any of the pages in your `pages/` directory your site's homepage. For Eg.: If you have a `home.md` in your `pages/` directory and then add: `homepage: home`. This when compiled creates an `index.html` for your site |
| include\_assets | Directories that you would like to be compiled into the `assets` directory of your site. |
| include | Include any directories/files other than pages to be copied into the `public` directory. You need to specify them as an array of files/directories and this would recursively copy everything specified in the directory. A good example would be: <br><br> *include*: <br> - .htaccess |

-->

#### Preview Site
	$ bin/striker strike

To preview in your browser go to:
#
	http://localhost:1619

#### Preview Site Without Building
	$ bin/striker strike --quiet

#### Build Website
	$ bin/striker build
Generate the final website by creating a `public/` directory

#### Upload/Sunc Site To Remote Server
	$ bin/striker sync

<!--
## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
-->


[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/swaroopsm/striker/trend.png)](https://bitdeli.com/free "Bitdeli Badge")

