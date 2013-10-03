# Define git hooks for a server

define git::defhook::server {
    $repo = $title

    $hooknames = ['pre-receive','post-receive','update','post-fetch']

    $hooks = prefix($hooknames,"$repo/hooks/")

    git::defhook::def {$hooks:}
}
