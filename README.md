## gitsigns-yadm.nvim

This uses [`gitsigns`](https://github.com/lewis6991/gitsigns.nvim) `_on_attach_pre` function to check if the currently attached buffer is file tracked by [`yadm`](https://yadm.io/), and if it is, sets the correct `toplevel` and `gitdir` attributes.

## Installation

Using [`lazy.nvim`](https://github.com/folke/lazy.nvim); add this to your `dependencies` for `gitsigns`, add a `_on_attach_pre` function to your gitsigns configuration, passing the callback to the `yadm_signs` function:

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
}
```

Since this doesn't require calling `setup`, in accordance with [`lazy`s best practices](https://lazy.folke.io/developers#best-practices) you could also do the following:

```lua
return {
    {
        "seanbreckenridge/gitsigns-yadm.nvim",
        lazy = true,
    },
    {
        "nvim-lua/plenary.nvim",
        lazy = true,
    },
    {
        "lewis6991/gitsigns.nvim",
        opts = {
            ...
            _on_attach_pre = function(_, callback)
                require("gitsigns-yadm").yadm_signs(callback)
            end,
            ...
        }
    }
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

If you want to disable this when `yadm` is not installed, you can use `vim.fn.executable`:

```lua
_on_attach_pre = function(_, callback)
    if vim.fn.executable("yadm") == 1 then
        require("gitsigns-yadm").yadm_signs(callback)
    else
        callback()
    end
end,
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

and then check `:messages`.
