# Create a clone of a source repo

define git::clone ($source,
                   $branch = 'master') {
    include git

    $path = $title
    
    vcsrepo {$path:
        ensure => present,
        provider => git,
        source => $source,
        revision => $branch,
    } ->
    file {"$path/.git":}

    git::defhook::client {$path:}
}
