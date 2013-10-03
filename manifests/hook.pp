# Add a hook to a git repo

define git::hook ($repo,
                  $hook,
                  $content=undef,
                  $source=undef) {

    concat::fragment {$title:
        target => "$repo/hooks/$hook",
        content => $content,
        source => $source,
        order => 10,
    }

}
