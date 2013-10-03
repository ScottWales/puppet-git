# Define git hooks for a mirror - only post hooks

define git::defhook::mirror {
    $repo = $title

    $hooknames = ['post-receive', 'post-update']

    $hooks = prefix($hooknames,"$repo/hooks/")

    git::defhook::def {$hooks:}
}
