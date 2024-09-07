--
create table tokens (
  id text not null primary key, -- uuid

  integration_id text not null, -- uuid of integration
  is_valid integer, -- whether this token is still valid
  value text not null, -- the actual token content itself

  date_added text not null, -- date token was added
  date_expires text not null -- date the token will become invalid
);

