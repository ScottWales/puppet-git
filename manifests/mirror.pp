# Mirror a git repository, keeping it up to date
#
# This uses two repositories in order for hooks to work, since git can't hook
# on a remote update. 'fetcher' pulls from the remote repo and then pushes to
# the true mirror repo. (of course the mirror can't reject commits, else things
# get weird)

define git::mirror ($source, $fetcher = "${title}-fetcher") {
    include git

    $mirror = $title

    vcsrepo {$fetcher:
        ensure => bare,
        provider => git,
    } ->

    # Need to add to $repo/config:
    # [remote "origin"]
    #   fetch = +refs/*:refs/*
    #   mirror = true
    #   url = $source
    # [remote "mirror"]
    #   mirror = true
    #   url = $mirror
    augeas {$fetcher:
        context => "/files$fetcher/config",
        lens => "Puppet.lns",
        incl => "$fetcher/config",
        changes => ["set 'remote \"origin\"/fetch' '+refs/*:refs/*'",
                    "set 'remote \"origin\"/mirror' 'true'",
                    "set 'remote \"origin\"/url' '$source'",
                    "set 'remote \"mirror\"/mirror' 'true'",
                    "set 'remote \"mirror\"/url' '$mirror'"],
    }

    vcsrepo {$mirror:
        ensure => bare,
        provider => git,
    }

    # Update every 10 min
    cron {"update-$mirror":
        command => "cd $fetcher && cronic git remote update && cronic git push mirror",
        user    => root,
        minute  => '*/10',
        require => Vcsrepo[$mirror, $fetcher],
    }

    git::defhook::mirror {$mirror:}
}
