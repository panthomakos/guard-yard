# Guard::Yard

Guard::Yard allows you to automatically run and update your local YARD Documentation Server. It aims to centralize your file monitoring to guard instead of using the `yard server --reload` command which can be unreliable and provides little control over the generated documentation. Guard::Yard monitors files and updates only the documentation than changes, as opposed to generating the entire documentation suite. That means that changes to your documentation are available sooner!

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

Guard::Yard automatically detects changes in your app, lib and ext directories, but you can have it monitor additional files using the Guardfile DSL.

Guard::Yard also provides some basic options for doc generation and running the YARD server.

    guard 'yard', :port => '8808', :doc => '', :server => '' do
      ...
    end

Available options:

    :port => '8808'         # Port on which the server shoud run.
    :doc => '--private'     # Command line options to pass to the yard doc command.
    :server => '--no-stats' # Command line options to pass to the yard server command.

Guard::Yard will always use the cached version of files (-c command line option). This enables individual documentation files to be updated so that the entire YARD documentation database does not need to be generated on every file change.

## Generating Initial Documentation

When running guard, if you use `Ctrl-\`, Guard::Yard will generate and cache all of your documentation. This is a great way to get all of your initial docs into your YARD database. After this point Guard::Yard will only update the documentation for files that you change. If you prefer to not execute a run-all on all of your guards, you can issue the following command instead:

    yard doc --no-cache
