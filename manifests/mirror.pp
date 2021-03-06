# Mirror a git repository, keeping it up to date
#
# This uses two repositories in order for hooks to work, since git can't hook
# on a remote update. 'fetcher' pulls from the remote repo and then pushes to
# the true mirror repo. (of course the mirror can't reject commits, else things
# get weird)

define git::mirror (
  $source,
  $fetcher = "${title}-fetcher",
  $user    = 'root',
  $group   = 'root',
) {
    include git

    $mirror = $title

    vcsrepo {$fetcher:
        ensure   => bare,
        provider => git,
        owner    => $user,
        group    => $group,
    }

    # Need to add to $repo/config:
    # [remote "origin"]
    #   fetch = +refs/*:refs/*
    #   mirror = true
    #   url = $source
    # [remote "mirror"]
    #   mirror = true
    #   url = $mirror
    augeas {$fetcher:
        context => "/files${fetcher}/config",
        lens    => 'Puppet.lns',
        incl    => "${fetcher}/config",
        changes => ["set 'remote \"origin\"/fetch' '+refs/*:refs/*'",
                    "set 'remote \"origin\"/mirror' 'true'",
                    "set 'remote \"origin\"/url' '${source}'",
                    "set 'remote \"mirror\"/mirror' 'true'",
                    "set 'remote \"mirror\"/url' '${mirror}'"],
        require => Vcsrepo[$fetcher],
    }

    vcsrepo {$mirror:
        ensure   => bare,
        provider => git,
        owner    => $user,
        group    => $group,
    }

    # Update every 10 min
    cron {"update-${mirror}":
        command => "cd ${fetcher} && git remote update origin &>/dev/null && git push mirror &>/dev/null",
        user    => $user,
        minute  => '*/10',
        require => Vcsrepo[$mirror, $fetcher],
    }

    git::defhook::mirror {$mirror:}
}
