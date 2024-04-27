# Schema details

This document provides some additional detail about the structure of the database, and how tables interact with each other. Over time this document will be updated to reflect changes that are made to the schema.

The `filesystem` denotes a base path where `filesystem_file` will be found. These files are then captured to be used as references for the episodical types as they are found. As such, a filesystem can be added, numerous files in various paths can be added, and as episodic (for instance) entries are created, the files can be associated.

`episodic` _can_ reference within a `filesystem`, though doesn't have to. Each `episode` _can_ make a reference to a single `filesystem_file` entry then, based on the `filesystem` that is referenced from the `episodic`.

`integrations` are used to retrieve further information about the collection details. This means that `episode` lists can be loaded without `filesystem_file` entries, or vice versa.

## Integrations

- `thetvdb.org` / **DIY**
- `musicbrainz.org` / `https://git.sr.ht/~phw/go-musicbrainzws2`
- `openlibrary.org` / **https://openlibrary.org/dev/docs/api/search**
- `isbndb.org`

