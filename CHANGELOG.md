# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased](https://github.com/adrianshort/uk_planning_scraper/compare/v0.5.0...master)

This functionality is on GitHub but not yet in the gem.

## [0.5.0](https://github.com/adrianshort/uk_planning_scraper/compare/v0.4.6...v0.5.0) - 2020-04-30

### Added

- Case officer search for Northgate
- Status search for Idox and Northgate

## [0.4.6](https://github.com/adrianshort/uk_planning_scraper/compare/v0.4.5...v0.4.6) - 2020-04-22

### Fixed

- Major change to Northgate output semantics. Scraper previously returned `date_received` from the search results pages. Now it returns `date_validated` which is correct. Previously collected data needs to be moved to this new column or rescraped. [#40](https://github.com/adrianshort/uk_planning_scraper/issues/40)
- Upgraded `rake` to fix [CVE-2020-8130](http://cve.circl.lu/cve/CVE-2020-8130).

## [0.4.5](https://github.com/adrianshort/uk_planning_scraper/compare/v0.4.4...v0.4.5) - 2020-02-24

### Added

- Gateshead Council.

## [0.4.4](https://github.com/adrianshort/uk_planning_scraper/compare/v0.4.3...v0.4.4) - 2019-10-29

### Fixed

- URLs for Camden, Islington and Merton councils.

## [0.4.3](https://github.com/adrianshort/uk_planning_scraper/compare/v0.4.2...v0.4.3) - 2019-01-22

### Changed

- `uk_planning_scraper` [published as a gem on RubyGems](https://rubygems.org/gems/uk_planning_scraper/versions/0.4.5) for the first time.

## [0.4.2](https://github.com/adrianshort/uk_planning_scraper/compare/v0.4.1...v0.4.2) - 2019-01-08

### Changed

- Kingston becomes Idox.

### Fixed
- Bradford and Leeds tagged `westyorkshire` not `westmidlands`.

## [0.4.1](https://github.com/adrianshort/uk_planning_scraper/compare/v0.4.0...v0.4.1) - 2018-10-18

### Added

- 39 new councils.

### Changed

- Use spaces not commas to separate tags in `authorities.csv` file.
- Use `pry` not `irb` as default console.

## [0.4.0](https://github.com/adrianshort/uk_planning_scraper/compare/v0.3.2...v0.4.0) - 2018-10-12

### Changed

- Use chained methods rather than an options hash for the scraper parameters. This permits better error checking. [#15](https://github.com/adrianshort/uk_planning_scraper/issues/15)

## [0.3.2](https://github.com/adrianshort/uk_planning_scraper/compare/v0.3.1...v0.3.2) - 2018-10-10

## [0.3.1](https://github.com/adrianshort/uk_planning_scraper/compare/v0.3.0...v0.3.1) - 2018-10-10

## [0.3.0](https://github.com/adrianshort/uk_planning_scraper/compare/v0.2.0...v0.3.0) - 2019-10-09

## [0.2.0](https://github.com/adrianshort/uk_planning_scraper/compare/v0.1.1...v0.2.0) - 2018-09-19 

## [0.1.1](https://github.com/adrianshort/uk_planning_scraper/compare/v0.1.0...v0.1.1) - 2018-09-15

### Fixed

-  [#3](https://github.com/adrianshort/uk_planning_scraper/issues/3)

## [0.1.0](https://github.com/adrianshort/uk_planning_scraper/releases/tag/v0.1.0) - 2018-09-14

### Added

- Basic Idox scraper.
