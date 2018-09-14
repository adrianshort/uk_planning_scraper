# UK Planning Scraper

**PRE-ALPHA: Only works with some Idox sites and spews a lot of stuff to STDOUT. Not for production use.**

This gem scrapes planning applications data from UK council/local planning authority websites, eg Westminster City Council. Data is returned as an array of hashes, one hash for each planning application.

This scraper gem doesn't use a database. Storing the output is up to you. It's just a convenient way to get the data.

Currently this only works for some Idox sites. The ultimate aim is to provide a consistent interface in a single gem for all variants of all planning systems: Idox Public Access, Northgate Planning Explorer, OcellaWeb, and all the one-off systems.

This project is not affiliated with any organisation.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'uk_planning_scraper', :git => 'https://github.com/adrianshort/uk_planning_scraper/'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install specific_install
    $ gem specific_install adrianshort/uk_planning_scraper

## Usage

```ruby
require 'uk_planning_scraper'
require 'date'
require 'pp'

# change this to the URL of the advanced search page for the council you want
url = 'https://planning.anytown.gov.uk/online-applications/search.do?action=advanced'

options = {
  delay: 10, # seconds between scrape requests; optional, defaults to 10
}

params = {
  validated_from: Date.today - 30, # Must be a Date object; optional
  validated_to: Date.today, # Must be a Date object; optional
  description: 'keywords to search for', # Optional
}

apps = UKPlanningScraper.search(url, params, options)
pp apps

```

Try [ScraperWiki](https://github.com/openaustralia/scraperwiki-ruby) if you want a quick and easy way to throw the results into an SQLite database:

```ruby
require 'scraperwiki' # Must be installed, of course
ScraperWiki.save_sqlite([:council_reference], apps)
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/adrianshort/uk_planning_scraper.
