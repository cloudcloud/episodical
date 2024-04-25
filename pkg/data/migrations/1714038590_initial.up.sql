-- 
create table episodic (
  id text not null primary key, -- uuid
  title text not null, -- actual name
  year int not null, -- original release year

  date_added text not null, -- iso8601 from go, date of when this episodic was added
  date_updated text, -- iso8601 from go, date of when this configuration was last changed

  integration_id text, -- uuid, which integration the data for this episodical is pulled from

  file_system int not null, -- boolean, whether there are files corresponding to this
  path_id text, -- uuid, the identifier for which filesystem

  last_checked text, -- iso8601 from go, date of when the auto last ran if enabled
  auto_update int not null -- boolean, whether the metadata references should be autoupdated
);

--
create table artistic (
  id text not null primary key, -- uuid
  name text not null, -- actual name

  auto_update int not null -- boolean, whether the metadata references should be autoupdated
);

--
create table document (
  id text not null primary key, -- uuid
  name text not null, -- actual name

  auto_update int not null -- boolean, whether the metadata references should be autoupdated
);

--
create table integrations (
  id text not null primary key, -- uuid
  name text not null, -- actual name

  access_key text, -- a key used for API access if required
  base_url text, -- a base URL for calls if required

  collection_type text check(collection_type in ('episodic', 'artistic', 'document')) not null -- which type the integration is used for
);

--
create table audit_log (
  id text not null primary key, -- uuid
  collection_type text check(collection_type in ('episodic', 'artistic', 'document')) not null, -- which type this audit was about
  item_id text not null, -- the identifier within the type specifically
  date_occurred text not null, -- iso8601 from go, when the event occurred
  success int not null, -- whether the action was a success
  action text not null -- details of what happened
);

--
create table event_log (
);
