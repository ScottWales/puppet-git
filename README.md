Manage a Git repository using Puppet
====================================

Extends puppetlabs-vcsrepo by providing the following defines:

    git::bare   {$path:}
    git::mirror {$path: $source}
    git::clone  {$path: $source, $branch='master'}

These create a bare repo, a mirror of an existing repo and a clone of a repo at
a given version respectively.

Also allows for hook management using the define

    git::hook {$path: $hook, $content=undef, $source=undef}

Examples
--------

    git::bare {'/git/repo':}
    git::hook {'/git/repo':
        hook => 'post-commit',
        source => '/git/repo/hooks/post-commit.sample',
    }

    git::clone {'/git/clone':
        source => 'https://github.com/ScottWales/puppet-git',
    }
    git::hook {'/git/clone/.git':
        hook => 'post-commit',
        content => 'echo "Thanks for the commit!"',
    }

Requires:
---------
 * https://github.com/puppetlabs/puppetlabs-vcsrepo
 * https://github.com/puppetlabs/puppetlabs-concat

