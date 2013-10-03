# Create a clone of a source repo

define git::clone ($title,
                   $source,
                   $branch = 'master') {
    include git

    $path = $title
    
    vcsrepo {$path:
        ensure => present,
        provider => git,
        source => $source,
        revision => $branch,
    } ->
    file {"$path/.git"}

    git::defhooks::client {$path:}
}
