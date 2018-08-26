PROJECT = esk
PROJECT_DESCRIPTION = Erlang Starter Kit
PROJECT_VERSION = 0.1.0

DEPS = cowboy lager jsone erlpass couchbeam

dep_cowboy_commit = 2.4.0
dep_lager_commit = 3.6.4
dep_erlpass_commit = 1.0.4
dep_jsone_commit = 1.4.7
dep_cocuhbeam_commit = 1.3.1

ERLC_OPTS = +'{parse_transform, lager_transform}'

include erlang.mk
