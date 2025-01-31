{ config, pkgs, inputs, lib }: {
  programs.nixvim = {
    enable = true;
    # copied from github:GaetanLepage/dotfiles
    globals = {
      mapleader = " ";
      maplocalleader = " ";
    };

    keymaps = let
      normal =
        lib.mapAttrsToList
        (key: action: {
          mode = "n";
          inherit action key;
        })
        {
          # "<Space>" = "<NOP>";

          # Esc to clear search results
          "<esc>" = ":noh<CR>";

          # fix Y behaviour
          # Y = "y$";

          # back and fourth between the two most recent files
          "<C-c>" = ":b#<CR>";

          # close by Ctrl+x
          # "<C-x>" = ":close<CR>";

          # save by Space+s or Ctrl+s
          "<leader>s" = ":w<CR>";
          "<C-s>" = ":w<CR>";

          # navigate to left/right window
          "<leader>h" = "<C-w>h";
          "<leader>l" = "<C-w>l";

          # navigate to left/right buffer
          "<leader>bh" = ":bprev<CR>";
          "<leader>bl" = ":bnext<CR>";
          "<leader>bx" = ":bdelete<CR>";

          # lspsaga keymaps
          "<leader>ca" = ":Lspsaga code_action<CR>";
          "<leader>cr" = ":Lspsaga rename<CR>";
          "<leader>co" = ":Lspsaga outline<CR>";
          "<leader>cK" = ":Lspsaga hover_doc<CR>";

          # Press 'H', 'L' to jump to start/end of a line (first/last character)
          L = "$";
          H = "^";

          # resize with arrows
          "<C-Up>" = ":resize -2<CR>";
          "<C-Down>" = ":resize +2<CR>";
          "<C-Left>" = ":vertical resize +2<CR>";
          "<C-Right>" = ":vertical resize -2<CR>";

          # move current line up/down
          # M = Alt key
          "<M-k>" = ":move-2<CR>";
          "<M-j>" = ":move+<CR>";
        };
      visual =
        lib.mapAttrsToList
        (key: action: {
          mode = "v";
          inherit action key;
        })
        {
          # better indenting
          ">" = ">gv";
          "<" = "<gv";
          "<TAB>" = ">gv";
          "<S-TAB>" = "<gv";

          # move selected line / block of text in visual mode
          "K" = ":m '<-2<CR>gv=gv";
          "J" = ":m '>+1<CR>gv=gv";
        };
    in
      config.nixvim.helpers.keymaps.mkKeymaps
      {options.silent = true;}
      (normal ++ visual);
    # --| from github:GaetanLepage
    colorschemes.oxocarbon.enable = true;
    clipboard.providers.xsel.enable = true;
    plugins = {
      # Treesitter
      treesitter = {
        enable = true;
        folding = true;
        settings = {
          highlight.enable = true;
          incremental_selection.enable = true;
          indent.enable = true;
        }; 
      };
      treesitter-context.enable = true;
      treesitter-context.settings.line_numbers = true;
      treesitter-refactor.enable = true;
      treesitter-textobjects.enable = true;
      # UI + Conveniences
      # Nice completions
      coq-nvim.enable = true;
      coq-nvim.installArtifacts = true;
      coq-nvim.settings.auto_start = "shut-up";
      nvim-autopairs.enable = true;
      luasnip.enable = true;
      friendly-snippets.enable = true;
      indent-blankline.enable = true;
      comment.enable = true;
      wrapping.enable = true;
      neoconf.enable = true;
      # Other niceties
      web-devicons.enable = true;
      todo-comments.enable = true;
      trouble.enable = true;
      oil.enable = true;
      gitsigns.enable = true;
      flash.enable = true;
      lualine.enable = true;
      bufferline.enable = true;
      which-key.enable = true;
      precognition.enable = true;
      wilder.enable = true;
      jupytext.enable = true;
      lspsaga.enable = true;
      lspsaga.lightbulb.debounce = 250;
      # Telescope
      telescope = {
        enable = true;
        keymaps = {
          "<leader>gg" = "live_grep";
          "<leader>gt" = "treesitter";
          "<leader>gG" = "grep_string";
          "<leader>gf" = "find_files";
        };
        extensions = {
          fzf-native.enable = true;
        };
      };
      # Linters
      lint = {
        enable = true;
      };
      # Languages
      lsp = {
        enable = true;
      	keymaps = {
          silent = true;
          diagnostic = {
            # Navigate in diagnostics
            "<leader>ck" = "goto_prev";
            "<leader>cj" = "goto_next";
            "<leader>cc" = "open_float";
            "<leader>K" = "show";
          };

          lspBuf = {
            gd = "definition";
            gD = "references";
            gt = "type_definition";
            gi = "implementation";
            K = "hover";
            "<F2>" = "rename";
          };
        };
        servers = {
          # Nix
          nil_ls = {
            enable = true;
            package = null;
          };
          # Rust
          rust_analyzer = {
            enable = true;
            installCargo = false;
            installRustc = false;
          };
          # Python
          pyright.enable = true;
          # HTML
          superhtml.enable = true;
          superhtml.package = pkgs.superhtml;
          # CSS
          cssls.enable = true;
          # TS/JS
          ts_ls.enable = true;
          # Deno
          denols.enable = true;
          denols.package = null;
          # Tailwind
          tailwindcss.enable = true;
          # C
          clangd.enable = true;
          # Lua
          lua_ls.enable = true;
          # OCaml
          ocamllsp.enable = true;
          ocamllsp.package = null;
          # Dart
          dartls.enable = true;
          # PHP
          phpactor.enable = true;
          phpactor.package = null;
          # Ada
          ada_ls.enable = true;
          ada_ls.package = null;
        };
      };
      # Additional Rust stuff
      crates-nvim.enable = true;
      # rustaceanvim.enable = true;
      # HTML Templating
      ts-autotag = {
        enable = true;
      };
    };
    extraConfigVim = ''
      set shiftwidth=2 softtabstop=2 expandtab relativenumber
    '';
    extraConfigLua = ''
      if vim.g.neovide then
        vim.g.neovide_scale_factor = 0.8
        local change_scale_factor = function(delta)
          vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * delta
        end
        vim.keymap.set("n", "<C-=>", function()
          change_scale_factor(1.25)
        end)
        vim.keymap.set("n", "<C-->", function()
          change_scale_factor(1/1.25)
        end)
        vim.g.neovide_remember_window_size = true
        vim.g.neovide_fullscreen = true
        vim.g.neovide_cursor_vfx_mode = "pixiedust"
      end
    '';
  };
}
