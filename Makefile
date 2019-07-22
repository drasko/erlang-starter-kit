PROJECT = esk
PROJECT_DESCRIPTION = Erlang Starter Kit
PROJECT_VERSION = 0.1.0

DEPS = cowboy lager jsone erlpass epgsql

dep_cowboy_commit = 2.6.3
dep_lager_commit = 3.7.0
dep_erlpass_commit = 1.0.4
dep_jsone_commit = 1.5.0
dep_epgsql_commit = 4.3.0

ERLC_OPTS = +'{parse_transform, lager_transform}'

include erlang.mk
