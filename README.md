# UK Planning Scraper

**PRE-ALPHA: Only works with Idox and Northgate sites and spews a lot of stuff to STDOUT. Not for production use.**

This gem scrapes planning applications data from UK local planning authority websites, eg Westminster City Council. Data is returned as an array of hashes, one hash for each planning application.

This scraper gem doesn't use a database. Storing the output is up to you. It's just a convenient way to get the data.

Currently this only works for Idox and Northgate sites. The ultimate aim is to provide a consistent interface in a single gem for all variants of all planning systems: Idox Public Access, Northgate Planning Explorer, OcellaWeb, Agile Planning and all the one-off systems.

This project is not affiliated with any organisation.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'uk_planning_scraper', :git => 'https://github.com/adrianshort/uk_planning_scraper/'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install specific_install
    $ gem specific_install adrianshort/uk_planning_scraper

## Usage

### First, require your stuff

```ruby
require 'uk_planning_scraper'
require 'pp'
```

### Scrape from a council

```ruby
apps = UKPlanningScraper::Authority.named('Westminster').scrape({ decided_days: 7 })
pp apps
```

### Scrape from a bunch of councils

```ruby
auths = UKPlanningScraper::Authority.tagged('london')

auths.each do |auth|
  apps = auth.scrape({ decided_days: 7 })
  pp apps # You'll probably want to save `apps` to your database here
end
```

Yes, we just scraped the last week's planning decisions across the whole of London (actually 23 of the 35 authorities right now) with five lines of code.

### Satisfy your niche interests

```ruby
auths = UKPlanningScraper::Authority.tagged('scotland')

auths.each do |auth|
  apps = auth.scrape({ validated_days: 7, keywords: 'launderette' })
  pp apps # You'll probably want to save `apps` to your database here
end
```

### More search parameters

```ruby

# Don't try these all at once
params = {
  received_to: Date.today,
  received_from: Date.today - 30,
  received_days: 7, # instead of received_to, received_from
  validated_to: Date.today,
  validated_from: Date.today - 30,
  validated_days: 7, # instead of validated_to, validated_from
  decided_to: Date.today,
  decided_from: Date.today - 30,
  decided_days: 7 # instead of decided_to, decided_from
  keywords: "hip gable", # Check that the systems you're scraping return the results you expect for multiple keywords (AND or OR?)
}

apps = UKPlanningScraper::Authority.named('Camden').scrape(params)
```

### Save to a SQLite database

This gem has no interest whatsoever in persistence. What you do with the data it outputs is up to you: relational databases, document stores, VHS and clay tablets are all blissfully none of its business. But using the [ScraperWiki](https://github.com/openaustralia/scraperwiki-ruby) gem is a really easy way to store your data:

```ruby
require 'scraperwiki' # Must be installed, of course
ScraperWiki.save_sqlite([:authority_name, :council_reference], apps)
```

That `apps` param can be a hash or an array of hashes, which is what gets returned by our `search()`.

### Find authorities by tag

Tags are always lowercase and one word.

```ruby
london_auths = UKPlanningScraper::Authority.tagged('london')
```

We've got tags for areas:

- london
- innerlondon
- outerlondon
- northlondon
- southlondon
- surrey
- wales

and software systems:

- idox
- northgate
- ocellaweb
- agileplanning
- unknownsystem -- use when you can't identify the system

and whatever you'd like to add that would be useful to others.

### WTF is up with London?

London has got 32 London Boroughs, tagged `londonboroughs`. These are the councils under the authority of the Mayor of London and the Greater London Authority.

It has 33 councils: the London Boroughs plus the City of London (named `City of London`). We don't currently have a tag for this, but if you want to add `londoncouncils` please go ahead.

And it's got 35 local planning authorities: the 33 councils plus the two `londondevelopmentcorporations`, named `London Legacy Development Corporation` and `Old Oak and Park Royal Development Corporation`. The tag `london` covers all (and only) the 35 local planning authorities in London.

```ruby
UKPlanningScraper::Authority.tagged('londonboroughs').size
 => 32
 
UKPlanningScraper::Authority.tagged('londondevelopmentcorporations').size
 => 2

UKPlanningScraper::Authority.tagged('london').size
 => 35
```

### More fun with Authority tags

```ruby
UKPlanningScraper::Authority.named('Merton').tags
# => ["england", "london", "londonboroughs", "northgate", "outerlondon", "southlondon"]

UKPlanningScraper::Authority.not_tagged('london')
# => [...]

UKPlanningScraper::Authority.named('Islington').tagged?('southlondon')
# => false
```

### List all authorities

```ruby
UKPlanningScraper::Authority.all.each { |a| puts a.name }
```

### List all tags

```ruby
pp UKPlanningScraper::Authority.tags
```
## Add your favourite local planning authorities

The list of authorities is in a CSV file in `/lib/uk_planning_scraper`:

https://github.com/adrianshort/uk_planning_scraper/blob/master/lib/uk_planning_scraper/authorities.csv

The easiest way to add to or edit this list is to edit within GitHub (use the pencil icon) and create a new pull request for your changes. If accepted, your changes will be available to everyone with the next version of the gem.

The file format is one line per authority, with comma-separated:

- Name (omit "the", "council", "borough of", "city of", etc. and write "and" not "&", except for `City of London` which is a special case)
- URL of the search form (use the advanced search URL if there is one)
- Tags (use as many comma-separated tags as is reasonable, lowercase and all one word.)

Currently only `idox` and `northgate` scrapers work but feel free to add authorities that use other systems, along with appropriate system tags like `ocellaweb` and `agileplanning`. Use `unknownsystem` if you can't identify the system. This gem selects the appropriate scraper by examining the URL not by looking at the tags, so it doesn't matter what you use as long as it's consistent with others.

Please check the tag list before you change anything:

```ruby
pp UKPlanningScraper::Authority.tags
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/adrianshort/uk_planning_scraper.
