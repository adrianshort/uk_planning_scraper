# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]()

## [0.4.6](https://github.com/adrianshort/uk_planning_scraper/tree/f9e70cb21c60a732f6ec5f72e55e4887e7455405) - 2020-04-22

### Fixed

- Major change to Northgate output semantics. Scraper previously returned `date_received` from the search results pages. Now it returns `date_validated` which is correct. Previously collected data needs to be moved to this new column or rescraped. [#40](https://github.com/adrianshort/uk_planning_scraper/issues/40)
- Upgraded `rake` to fix [CVE-2020-8130](http://cve.circl.lu/cve/CVE-2020-8130).

## [0.4.5](https://github.com/adrianshort/uk_planning_scraper/tree/624efc0ecf0aaccbd3a90df887beefce1f386e5d) - 2020-02-24

### Added

- Gateshead Council.

## [0.4.4](https://github.com/adrianshort/uk_planning_scraper/tree/557678ea7c9efa67bccd3f972b23aff588368ab8) - 2019-10-29

### Changed

- URLs for Camden, Islington and Merton councils.

## [0.4.3](https://github.com/adrianshort/uk_planning_scraper/tree/45427b73ffb36400ee3c5aa7dd52bccd42caa4a0) - 2019-01-22

### Changed

- Kingston becomes Idox.

## [0.4.2](https://github.com/adrianshort/uk_planning_scraper/tree/dcd996772be2939c4fc153c207a18267d64566eb) - 2019-01-08

## [0.4.1](https://github.com/adrianshort/uk_planning_scraper/tree/b8a303381ea7bab1ea6a5cb371f57b52b8f21950) - 2018-10-18

## [0.4.0](https://github.com/adrianshort/uk_planning_scraper/tree/09b289d1fec89346f3182d2e6eedb3f4295b76e3) - 2018-10-12

## [0.3.2](https://github.com/adrianshort/uk_planning_scraper/tree/9cfbdd4a1819b20bb2a078d97dea74925a95f933) - 2018-10-10

## [0.3.1](https://github.com/adrianshort/uk_planning_scraper/tree/dd8e0849e2b96303891b9023692cae0feaa2e153) - 2018-10-10

## [0.3.0](https://github.com/adrianshort/uk_planning_scraper/tree/45427b73ffb36400ee3c5aa7dd52bccd42caa4a0) - 2019-10-09

## [0.2.0](https://github.com/adrianshort/uk_planning_scraper/tree/b9e75b3507523d64c0a14168dbd38d967d6c4781) - 2018-09-19 

## [0.1.1](https://github.com/adrianshort/uk_planning_scraper/tree/b9e75b3507523d64c0a14168dbd38d967d6c4781) - 2018-09-15

### Fixed

-  [#3](https://github.com/adrianshort/uk_planning_scraper/issues/3)

## [0.1.0](https://github.com/adrianshort/uk_planning_scraper/tree/7f48783e71195a884ae6c2ea80f28decaa2d9530) - 2018-09-14

### Added

- Basic Idox scraper.
