# master (unreleased)

# 2.2.1 (2017-12-20)

* Fixes #21. Properly kill YARD server on Windows. (sshaw)

# 2.2.0 (2016-12-28)

* Added the server option `host`. (pascalturbo)

# 2.1.4 (2014-11-06)

* Upgraded to use new `Guard::Plugin` standard. (stefanvermaas)

# 2.1.3 (2014-10-22)

* Fixes #14, #15. `Process.wait2` only waits when a PID exists. (panthomakos)

# 2.1.2 (2014-10-14)

* Fixed #13. `Process.wait2` now waits specifically for the server PID. (panthomakos)

# 2.1.0

* Added possibility to specify cli-options for server start. (maxigs)

# 2.0.1

* Fixed issue where .yardopts files were not being used. (panthomakos)
