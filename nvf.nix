{
  config,
  pkgs,
  inputs,
  lib,
}:
{
  programs.nvf = {
    enable = true;
    enableManpages = true;
    settings = {
      vim = {
        theme.name = "oxocarbon";
        options = {
          shiftwidth = 2;
          tabstop = 2;
          expandtab = true;
          relativenumber = true;
        };
        keymaps =
          let
            inherit (inputs.nvf.lib.nvim.binds) mkKeymap;
          in
          [
            (mkKeymap "n" "H" "^" { })
            (mkKeymap "n" "L" "$" { })

            (mkKeymap "n" "<esc>" ":noh<CR>" { silent = true; })
            (mkKeymap "n" "<M-j>" ":move+<CR>" { silent = true; })
            (mkKeymap "n" "<M-k>" ":move-2<CR>" { silent = true; })

            (mkKeymap "v" ">" ">gv" { silent = true; })
            (mkKeymap "v" "<" "<gv" { silent = true; })
            (mkKeymap "v" "J" ":m '>+1<CR>gv=gv" { silent = true; })
            (mkKeymap "v" "K" ":m '<-2<CR>gv=gv" { silent = true; })

            # Buffer-related keymaps
            (mkKeymap "" "<C-b>" "" { desc = "+buffer"; })
            (mkKeymap "" "<C-b>q" ":bd<CR>" { desc = "Quit a buffer"; })
            (mkKeymap "" "<C-b>h" ":bp<CR>" { desc = "Go to the previous buffer"; })
            (mkKeymap "" "<C-b>l" ":bn<CR>" { desc = "Go to the next buffer"; })
          ];
        lsp =
          let
            inherit (lib) mkForce;
            inherit (lib.generators) mkLuaInline;
          in
          {
            enable = true;
            formatOnSave = true;
            inlayHints.enable = true;
            lightbulb.enable = true;
            servers = {
              clangd.cmd = mkForce [ "clangd" ];
              basedpyright.cmd = mkForce [
                "basedpyright-langserver"
                "--stdio"
              ];
              nil.cmd = mkForce [ "nil" ];
              lua-language-server.cmd = mkForce [ "lua-language-server" ];
              powershell_es = {
                filetypes = [ "ps1" ];
                cmd = [ "powershell-editor-services" ];
              };
              gdscript = {
                filetypse = [
                  "gd"
                  "gdscript"
                  "gdscript3"
                ];
                root_markers = [
                  "project.godot"
                  "git"
                ];
                cmd = mkLuaInline ''vim.lsp.rpc.connect('127.0.0.1', tonumber(os.getenv 'GDScript_Port' or '6005'))'';
              };
            };
          };
        languages = {
          enableTreesitter = true;
          clang = {
            enable = true;
          };
          python = {
            enable = true;
          };
          nix = {
            enable = true;
          };
          rust = {
            enable = true;
            lsp.package = [ "rust-analyzer" ];
          };
          lua = {
            enable = true;
          };
        };
        treesitter = {
          enable = true;
          autotagHtml = true;
          context.enable = true;
          fold = true;
          textobjects.enable = true;
          grammars = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
            powershell
          ];
        };
        autocomplete = {
          blink-cmp = {
            enable = true;
            friendly-snippets.enable = true;
            sourcePlugins = {
              emoji.enable = true;
              spell.enable = true;
            };
            setupOpts.signature.enable = true;
          };
        };
        snippets = {
          luasnip = {
            enable = true;
            setupOpts.enable_autosnippets = true;
          };
        };
        comments.comment-nvim.enable = true;
        notes.todo-comments.enable = true;
        binds.cheatsheet.enable = true;
        binds.whichKey.enable = true;
        git.enable = true;
        clipboard = {
          enable = true;
          providers.wl-copy.enable = true;
          providers.wl-copy.package = null;
        };
        utility = {
          oil-nvim.enable = true;
          motion = {
            flash-nvim.enable = true;
            precognition.enable = true;
          };
        };
        visuals = {
          nvim-web-devicons.enable = true;
          highlight-undo.enable = true;
          indent-blankline.enable = true;
        };
        statusline.lualine.enable = true;
        tabline.nvimBufferline.enable = true;
        telescope.enable = true;
        lazy.plugins = {
          "jupytext.nvim" = {
            package = pkgs.vimPlugins.jupytext-nvim;
          };
        };
        # luaConfigRC = ''
        #   if vim.g.neovide then
        #     vim.g.neovide_scale_factor = 0.8
        #     local change_scale_factor = function(delta)
        #       vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * delta
        #     end
        #     vim.keymap.set("n", "<C-=>", function()
        #       change_scale_factor(1.25)
        #     end)
        #     vim.keymap.set("n", "<C-->", function()
        #       change_scale_factor(1/1.25)
        #     end)
        #     vim.g.neovide_remember_window_size = true
        #     vim.g.neovide_fullscreen = true
        #     vim.g.neovide_cursor_vfx_mode = "pixiedust"
        # '';
      };
    };
  };
}
