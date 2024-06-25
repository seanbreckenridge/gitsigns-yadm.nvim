## gitsigns-yadm.nvim

This uses `gitsigns` `_on_attach_pre` function hook to check if the currently attached buffer is file tracked by `yadm`, and if it is, sets the correct `toplevel` and `gitdir` attributes.

## Installation

To use the hook, add this to your `dependencies`, and add a `_on_attach_pre` to your `opts` in `gitsigns`:

```lua
return {
    "lewis6991/gitsigns.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "seanbreckenridge/gitsigns-yadm.nvim",
    },
    opts = {
        ...,
        _on_attach_pre = function(_, callback)
            require("gitsigns-yadm").yadm_signs(callback)
        end,
        on_attach = function(bufnr)
        ...
```

## Configuration

You can modify the global `Config` table to configure:

```lua
local yadm = require('gitsigns-yadm')
yadm.Config.yadm_repo_git = vim.fn.expand("~/.local/somewhere/else/yadm/repo.git")
```

The default values are:

```lua
{
    homedir = os.getenv("HOME"),
    yadm_repo_git = vim.fn.expand("~/.local/share/yadm/repo.git"),
}
```

## Troubleshooting

If things don't seem to be working, try scheduling the `yadm_signs` call so that the `gitsigns` does not suppress the errors:

```lua
_on_attach_pre = function(_, callback)
    vim.schedule(function()
        require("gitsigns-yadm").yadm_signs(callback)
    end)
end,
```
