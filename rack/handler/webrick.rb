# Intentionally empty.
#
# staticmatic.rb requires 'rack/handler/webrick' at load time for its own
# preview server, which this project no longer uses (see config.ru). The file
# was removed from Rack in 3.0 and from rackup in 2.2, so this stub exists only
# to keep that require from raising.
