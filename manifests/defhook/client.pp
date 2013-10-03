# Define git hooks for a client

define git::defhook::client {
    $repo = $title

    $hooknames = ['pre-commit']

    $hooks = prefix($hooknames,"$repo/.git/hooks")

    git::defhook::def {$hooks}
}
