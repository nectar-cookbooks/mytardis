Overview
========
*This cookbook is derived from Steve Androlakis's mytardis/mytardis-chef cookbook which is in turn based on Tim Dettrick's original work for UQ.*

This version has been refactored to be Berkshelf-ready, and modified to:
* remove some dubious fiddling with 'iptables'.

(Future versions will include stuff to implement database backups and guard against damage caused by buggy South migrations.)

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

Attributes
==========

* `node['mytardis']['repo']` - This gives the URL of the MyTardis source Git repository to checkout and build from.  The 
* `node['mytardis']['branch']` - This gives the branch (or tag) of the MyTardis repo to use.  It defaults to 'master'.

If you deploy using Chef Solo, you also need to set `node['postgresql']['password']['postgres']` to a password for the database.

What next
=========

This recipe gives you a 'vanilla' MyTardis installation with no accounts.  Read the [MyTardis documentation site][2] for what you need to do next.  (The first thing is to create a "superuser" account ...)


  [1]: http://github.com/mytardis/mytardis
  [2]: http://mytardis.readthedocs.org/en/latest/install.html
