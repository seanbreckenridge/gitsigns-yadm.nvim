## gitsigns-yadm.nvim

This uses [`gitsigns`](https://github.com/lewis6991/gitsigns.nvim) `_on_attach_pre` function to check if the currently attached buffer is file tracked by [`yadm`](https://yadm.io/), and if it is, sets the correct `toplevel` and `gitdir` attributes.

## Installation

Add this to your `dependencies` for `gitsigns`, add a `_on_attach_pre` function to your configuration, passing the callback to the `yadm_signs` function:

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
    }
```

## Configuration

If using a standard `yadm` setup, you likely won't need to configure anything.

The default computed values are:

```lua
{
    homedir = os.getenv("HOME"),
    yadm_repo_git = vim.fn.expand("~/.local/share/yadm/repo.git"),
}
```

You can pass those options to the `setup` function to configure:

```lua
return {
    "lewis6991/gitsigns.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        {
            "seanbreckenridge/gitsigns-yadm.nvim",
            config = function ()
                require("gitsigns-yadm").setup({ yadm_repo_git = "~/.config/yadm/repo.git "})
            end
        },
    },

```

If using [`lazy`](https://github.com/folke/lazy.nvim), you can pass pass `opts`:

```lua
return {
    "lewis6991/gitsigns.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        {
            "seanbreckenridge/gitsigns-yadm.nvim",
            opts = {
                yadm_repo_git = "~/.config/yadm/repo.git"
            },
        },
    },
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
