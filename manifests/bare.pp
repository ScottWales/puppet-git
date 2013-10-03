# Create a bare git repo

define git::bare {
    include git

    $path = $title
    
    vcsrepo {$path:
        ensure => bare,
        provider => git,
    }

    git::defhook::server {$path:}
}
