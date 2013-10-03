# Mirror a git repository, keeping it up to date
define git::mirror ($source) {
    include git

    $path = $title
    
    vcsrepo {$path:
        ensure => bare,
        provider => git,
    } ->

    # Need to add to $repo/config:
    # [remote "origin"]
    #   fetch = +refs/*:refs/*
    #   mirror = true
    augeas {$path:
        context => "/files$path/config",
        lens => "Puppet.lns",
        incl => "$path/config",
        changes => ["set 'remote \"origin\"/fetch' '+refs/*:refs/*'",
                    "set 'remote \"origin\"/mirror' 'true'",
                    "set 'remote \"origin\"/url' '$source'"],
    }
    
    # Update every 10 min
    # Also adds a post-fetch hook for updating trac etc.
    cron {"update-$path":
        command => "cd $path && git fetch | [ -f $path/hooks/post-fetch] && grep '->' | $path/hooks/post-fetch",
        user => root,
        minute => '*/10',
        require => Vcsrepo[$path],
    }

    git::defhook::server {$path:}
}
