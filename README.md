# Dist::Zilla::Plugin::AnnounceRelease - Announce a new release and its changes

## Synopsis

Using the changelog created by [DZP::IAChangelog](https://github.com/duckduckgo/p5-dzp-iachangelog) will notify specified channel of the new release and what has changed in it.

To activate the plugin, add the following to **dist.ini**:

    [AnnounceRelease]

## Attributes

- **changelog**: Name of the changelog file in the release  Defaults to `ia_changelog.yml`.
- **channel**: Which channel to notify. Defaults to `DuckDuckHack`.

## Contributing

To browse the repository, submit issues, or bug fixes, please visit
the github repository:

+ https://github.com/duckduckgo/p5-dzp-announcerelease

## Author

Zach Thompson <zach@duckduckgo.com>
