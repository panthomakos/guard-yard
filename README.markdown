# Guard::Yard

Guard::Yard allows you to automatically run and update your local YARD Documentation Server. It aims to centralize your file monitoring to guard instead of using the `yard server --reload` command which can be unreliable and provides little control over the generated documentation.

## Install

Ensure you have [Guard](https://github.com/guard/guard) installed before you continue.

Add guard-yard to your Gemfile (inside development group):

    gem 'guard-yard'

Install or update your bundle:

    bundle install

Add the default guard-yard definition to your Guardfile:

    guard init yard

## Guardfile

Please read the [Guardfile DSL documentation](https://github.com/guard/guard#readme) for additional information.

Guard::Yard automatically detects changes in your app and lib directories, but you can have it monitor additional files using the Guardfile DSL.

Guard::Yard also provides some basic options for doc generation and running the YARD server.

    guard 'yard', :port => '8808', :doc => '', :server => '' do
      ...
    end

Available options:

    :port => '8808' # Port on which the server shoud run.
    :doc => '-q'    # Command line options to pass to the yard doc command.
    :server => '-c' # Command line options to pass to the yard server command.

Guard::Yard will always use the cached version of files (-c command line option). This enables individual documentation files to be updated so that the entire YARD documentation does not need to be generated on every file change.
