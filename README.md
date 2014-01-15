Overview
========
*This cookbook is derived from Steve Androlakis's mytardis/mytardis-chef cookbook which is in turn based on Tim Dettrick's original work for UQ.*

This version has been refactored to be Berkshelf-ready, and modified to:
* remove some dubious fiddling with 'iptables',
* implement backups (optional),
* guard against potentially dangerous schema migrations (optional), and
* implement MyTardis log watching (if logwatch is installed).

By default, this Cookbook installs the current master of MyTardis - [http://github.com/mytardis/mytardis][1] - in "/opt/mytardis".  It also installs and configures an 'nginx' front-end webserver and a 'postgresql' database backend.

Health Warning
==============

If you use this recipe for building a "production" MyTardis instance (i.e. one where the data matters), then you need to be aware of a couple of things:

 1. This recipe does not set up backups of the directory data files are kept.  You need to make your own arrangements.

 1. MyTardis uses South migration for managing database schema changes, and this recipe in its current form will apply any pending South migrations without any warning.  This ''should'' work, but there is always a risk that the migration will go wrong, and that you will be left with a corrupted database.

 1. This recipe works by checking out and building MyTardis from a designated branch of a designated repository.  This can be risky.  For a production MyTardis instance:
  * It is prudent to use a stable branch of MyTardis rather than 'master' some other development branch.  
  * Consider creating your own MyTardis fork and using that so that you don't get surprise redeployments.  (Especially if you are tracking 'master'.)
  * It is prudent to try out redeployments in a Test or UAT instance rather than redeploying straight into production.

Prerequisites
=============

Ports 80 and 443 should be open.

If you deploy using Chef Solo, you need to set `node['postgresql']['password']['postgres']` to a password for the database.  (By default, the "postgres" cookbook wants to persist a randomly generated password in a node attribute ... which only works in Chef Server mode.) 

Attributes
==========

* `node['mytardis']['repo']` - This gives the URL of the MyTardis source Git repository to checkout and build from.  The 
* `node['mytardis']['branch']` - This gives the branch (or tag) of the MyTardis repo to use.  It defaults to 'master'.
* `node['mytardis']['production']` - If true, install MyTardis as a "production" server.  This changes the defaults for certain other settings.  This flag defaults to false.
* `node['mytardis']['backups']` - If true, configure MyTardis backups.  This defaults to true in "production" mode and false otherwise.
* `node['mytardis']['allow_migrations']` - If false, guard against potentially unsafe schema migrations.  This defaults to falsee in "production" mode and true otherwise.

South Migrations
================

The MyTardis recipe blocks potentially dangerous South migrations in "production" mode or if "allow_migrations" is explicitly set to false.  (Potentially dangerous means any set of migrations that does not include the initial "0001" migration.)

If an unsafe migration is detected, the deployment of the new version of MyTardis halts, and "/opt/mytardis/current" is not updated.  When this occurs, the following procedure is recommended.

1. Look at the MyTardis commit and change logs to understand what the change involves, and decide whether you actually want to proceed.

1. Take the MyTardis service offline by running "stop mytardis".

1. Use the backup script to create an up-to-the-minute backup of the database.  (A data store backup is not generally necessary, though this depends on the nature of the migration being performed.)

1. Modify the Chef node descriptor to set "allow_migrations" to true.

1. Rerun the recipe using chef-client or chef-solo.

1. Revert the above change to the Chef node descriptor.

If something goes wrong with the migration, use the backup to restore the database to the pre-migration state.


Backups
=======

When MyTardis backups are enabled, a backup script is run nightly to create a snapshot of the MyTardis database tables.  These snapshots are saved in the "/var/lib/mytardis/backup" directory.

At this time, we do not take backups of the files in the MyTardis data tree, and we do not take steps to copy the database backups to an off-machine location.

What next
=========

This recipe gives you a 'vanilla' MyTardis installation with no accounts.  Read the [MyTardis documentation site][2] for what you need to do next.  (The first thing is to create a "superuser" account ...)

TO-DO List
==========

The main recipe relies on the Chef "deploy" resource.  It may be better to use the new "application" resource ... though that means switching from foreman to gunicorn.


  [1]: http://github.com/mytardis/mytardis
  [2]: http://mytardis.readthedocs.org/en/latest/install.html
