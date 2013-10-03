Manage a Git repository using Puppet
====================================

Extends puppetlabs-vcsrepo by providing the following defines:

    git::bare
    git::mirror
    git::clone

These create a bare repo, a mirror of an existing repo and a clone of a repo at
a given version respectively.

Also allows for hook management using the define

    git::hook

Requires:
 * https://github.com/puppetlabs/puppetlabs-vcsrepo
 * https://github.com/puppetlabs/puppetlabs-concat

