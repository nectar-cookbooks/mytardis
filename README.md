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

 1. This recipe does not set up backups of either the MyTardis database or the data store area weher data files are kept.  You need to make your own arrangements.
 1. MyTardis uses South migration for managing database schema changes, and this recipe in its current form will apply any pending South migrations without any warning.  This ''should'' work, but there is always a risk that the migration will go wrong, and that you will be left with a corrupted database.  It is prudent to ''back up your database and data'' before you attempt to deploy a new version.

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

Schema Migrations
=================

TBD

Backups
=======

TBD

What next
=========

This recipe gives you a 'vanilla' MyTardis installation with no accounts.  Read the [MyTardis documentation site][2] for what you need to do next.  (The first thing is to create a "superuser" account ...)

TO-DO List
==========

The main recipe relies on the Chef "deploy" resource.  It may be better to use the new "application" resource ... though that means switching from foreman to gunicorn.


  [1]: http://github.com/mytardis/mytardis
  [2]: http://mytardis.readthedocs.org/en/latest/install.html
