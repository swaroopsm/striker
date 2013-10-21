[![Code Climate](https://codeclimate.com/github/swaroopsm/striker.png)](https://codeclimate.com/github/swaroopsm/striker)
# Striker

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

You can include any front-matter, but `title` and `template` are mandatory fields

The value that you specified for the `template` field, tells the gem to look for a file named `page.html` in the `templates/` directory. Here you can specify the markup of your page.

##### Templating
Striker uses [Liquid Templating](http://liquidmarkup.org).
To define a new template add a file called `my_template.html` in `templates/` and you can specify this template in your `markdown` pages.

#### Dealing with Images
##### Add thumbnail to a page.
If you would like to make an image appear on one of your pages, simply add an image named as thumbnail.(jpg|png|gif) to the images directory of your page.
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

If you would like to display images in your template use the following:
#####
	{% for image in page.images %}
		<img src="{{ image.url }}" />
	{% endfor %}

##### Start the Server
	$ striker strike
This starts the server at `localhost` and port `1619`

##### Helper Tags Available:
*Embed YouTube Video*
#####
	{% youtube bNAyPK2O4fk 650w 400h %}

*Embed Vimeo Video*
#####
	{% vimeo 29897413 650w 400h %}

*Embed SoundCloud Track*
#####
	{% soundcloud 3058346 400w 200h %}

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

