-- 
create table episodic (
  id text not null primary key, -- uuid
  title text not null, -- actual name
  year integer not null, -- original release year

  date_added text not null, -- iso8601 from go, date of when this episodic was added
  date_updated text, -- iso8601 from go, date of when this configuration was last changed

  integration_id text, -- uuid, which integration the data for this episodical is pulled from

  filesystem_id text, -- uuid, the filesystem to find files within
  path text, -- the path within the filesystem specifically

  is_active integer, -- boolean, if this episodic is continuing
  genre text, -- any particular genre information for the episodic
  public_db_id text, -- the identifier in the linkable public database

  last_checked text, -- iso8601 from go, date of when the auto last ran if enabled
  auto_update integer not null -- boolean, whether the metadata references should be autoupdated
);

create table episodic_episode (
  id text not null primary key, -- uuid
  episodic_id text not null, -- uuid of episodic
  title text, -- title of the episode
  season_id integer, -- which season this belongs to
  episode_number integer, -- which episode number this is within the season

  date_added text not null, -- iso8601 from go, date this was added to episodical
  date_updated text, -- iso8601 from go, date this was updated within episodical

  is_watched integer, -- boolean, whether this episode is marked as watched
  date_watched text, -- iso8601 from go, when the episode was marked as watched

  file_entry text, -- identifier for the file reference if found

  integration_identifier text, -- the identifier to reference this episode from the integration
  date_first_aired text, -- iso8601 from go, the date when this episode was first aired
  overview text -- blurb text for the episode content
);

--
create table artistic (
  id text not null primary key, -- uuid
  name text not null, -- actual name
  origin_country text not null, -- country of origin to help distinguish

  date_added text not null, -- iso8601 from go, date of when this artistic was added
  date_updated text, -- iso8601 from go, date of when this configuration was last changed

  integration_used text, -- uuid, which integration the data for this artistic is pulled from

  file_system integer not null, -- boolean, whether there are files corresponding to this
  path_id text, -- uuid, the identifier for which filesystem

  last_checked text, -- iso8601 from go, date of when the auto last ran if enabled
  auto_update integer not null -- boolean, whether the metadata references should be autoupdated
);

--
create table document (
  id text not null primary key, -- uuid
  name text not null, -- actual name

  auto_update integer not null -- boolean, whether the metadata references should be autoupdated
);

--
create table filesystem (
  id text not null primary key, -- uuid
  title text not null, -- pretty name top refer to the filesystem
  base_path text not null, -- the location on the filesystem where files can be found

  auto_update integer not null, -- boolean, whether the files under this location should be automatically scanned for updates
  last_checked text -- iso8601 from go, date of when the scan was last actioned
);

--
create table integrations (
  id text not null primary key, -- uuid
  title text not null, -- pretty name to refer to the integration

  access_key text, -- a key used for API access if required
  base_model text, -- which integration configuration internally to utilise

  collection_type text check(collection_type in ('episodic', 'artistic', 'document')) not null -- which type the integration is used for
);

--
create table audit_log (
  id text not null primary key, -- uuid
  collection_type text check(collection_type in ('episodic', 'artistic', 'document')) not null, -- which type this audit was about
  item_id text not null, -- the identifier within the type specifically
  date_occurred text not null, -- iso8601 from go, when the event occurred
  success integer not null, -- whether the action was a success
  action text not null -- details of what happened
);

--
create table event_log (
  id text not null primary key, -- uuid
  collection_type text check(collection_type in ('episodic', 'artistic', 'document')) not null, -- which type this event happened for
  collection_id text not null, -- the identifier of the specific collection affected
  item_id text not null, -- the identifier within the type specifically
  date_occurred text not null, -- iso8601 from go, when the event occurred
  event_type text check(event_type in ('auto', 'manual')) not null, -- whether the event was made by the auto processing internally or from an external source
  action text not null -- details of what happened
);
