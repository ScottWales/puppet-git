# Create a bare git repo

define git::bare ($title) {
    include git

    $path = $title
    
    vcsrepo {$path:
        ensure => bare,
        provider => git,
    }

    git::defhooks::server {$path:}
}
