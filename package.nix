{
  fetchFromGitHub,
  gdb,
  gh,
  gh-dash,
  inferno,
  jq,
  lazygit,
  lib,
  luau-lsp,
  nixfmt-rfc-style,
  nixvim,
  opencode,
  pkgs,
  shellcheck,
  sscli,
  tofu-ls,
  vimPlugins,
  vimUtils,
  vscode-extensions,
  vscode-js-debug,
}:
let
  js-i18n = vimUtils.buildVimPlugin {
    pname = "js-i18n";
    version = "2024-10-25";
    nvimRequireCheck = "js-i18n.config";
    src = fetchFromGitHub {
      owner = "Naxdy";
      repo = "js-i18n.nvim";
      rev = "2d826baa2b1200eaebf46f138ebd615092d91a78";
      hash = "sha256-RMEKaKQ5jiTnTjpWvMO00CsjxUwb8A+Q7ZgLp0XB4Ho=";
    };
  };

  # profiler
  plenary = vimUtils.buildVimPlugin {
    pname = "plenary";
    version = "2025-03-17";
    nvimSkipModule = [
      "plenary.neorocks.init"
      "plenary._meta._luassert"
    ];
    src = fetchFromGitHub {
      owner = "nvim-lua";
      repo = "plenary.nvim";
      rev = "857c5ac632080dba10aae49dba902ce3abf91b35";
      hash = "sha256-8FV5RjF7QbDmQOQynpK7uRKONKbPRYbOPugf9ZxNvUs=";
    };
  };

  keymaps = {
    "<C-BS>" = {
      val = "<esc>dbi<cr>";
      desc = "Delete word backwards";
      mode = [ "i" ];
    };
    "<C-n>" = {
      val = "<C-Bslash><C-n>";
      desc = "Normal mode";
      mode = [ "t" ];
    };
    "<C-u>" = {
      val = "<C-u>zz";
      desc = "Scroll up";
      mode = [
        "n"
        "v"
        "x"
      ];
    };
    "<C-d>" = {
      val = "<C-d>zz";
      desc = "Scroll down";
      mode = [
        "n"
        "v"
        "x"
      ];
    };
    "<C-1>" = {
      val = "<cmd>lua require 'naxdy.terminal'.opencode_toggle()<cr>";
      desc = "Toggle opencode";
      mode = [
        "n"
        "t"
      ];
    };
    "<C-a>" = {
      val = ''vBot:"fyf:l"lyiwf:l"cyiw<cmd>ToggleTermToggleAll<cr><cmd>lua vim.cmd("e " .. vim.fn.getreg("f"))<cr><cmd>lua vim.cmd("cal cursor(" .. vim.fn.getreg("l") .. ", " .. vim.fn.getreg("c") .. ")")<cr>'';
      desc = "Jump to file under cursor";
      mode = [
        "n"
      ];
    };
    "<M-j>" = {
      val = "4";
      desc = "4";
    };
    "<M-k>" = {
      val = "5";
      desc = "5";
    };
    "<M-l>" = {
      val = "6";
      desc = "6";
    };
    "<M-u>" = {
      val = "7";
      desc = "7";
    };
    "<M-i>" = {
      val = "8";
      desc = "8";
    };
    "<M-o>" = {
      val = "9";
      desc = "9";
    };
    "<M-m>" = {
      val = "1";
      desc = "1";
    };
    "<M-,>" = {
      val = "2";
      desc = "2";
    };
    "<M-.>" = {
      val = "3";
      desc = "3";
    };
    "<M-n>" = {
      val = "0";
      desc = "0";
    };
    "<leader>" = {
      i = {
        group = "i18n";
        e = {
          val = "<cmd>I18nEditTranslation<cr>";
          desc = "Edit Translation";
        };
        t = {
          val = "<cmd>I18nVirtualTextToggle<cr>";
          desc = "Toggle Text";
        };
        d = {
          val = "<cmd>I18nDiagnosticToggle<cr>";
          desc = "Toggle Diagnostics";
        };
        l = {
          val = "<cmd>I18nSetLang<cr>";
          desc = "Set Language";
        };
      };
      t = {
        group = "Goto";
        r = {
          val = "<cmd>Telescope lsp_references<CR>";
          desc = "References";
        };
        i = {
          val = "<cmd>Telescope lsp_implementations<CR>";
          desc = "Implementations";
        };
        t = {
          val = "<cmd>Telescope lsp_type_definitions<CR>";
          desc = "Type Definitions";
        };
        d = {
          val = "<cmd>Telescope lsp_definitions<CR>";
          desc = "Definitions";
        };
      };
      w = {
        val = "<cmd>w<cr>";
        desc = "Save File";
      };
      d = {
        group = "Debug";
        t = {
          val = "<cmd>lua require'dap'.toggle_breakpoint()<cr>";
          desc = "Toggle Breakpoint";
        };
        b = {
          val = "<cmd>lua require'dap'.step_back()<cr>";
          desc = "Step Back";
        };
        C = {
          val = "<cmd>lua require'dap'.run_to_cursor()<cr>";
          desc = "Run To Cursor";
        };
        c = {
          val = "<cmd>Telescope dap commands<cr>";
          desc = "Commands";
        };
        d = {
          val = "<cmd>lua require'dap'.disconnect()<cr>";
          desc = "Disconnect";
        };
        g = {
          val = "<cmd>lua require'dap'.session()<cr>";
          desc = "Get Session";
        };
        i = {
          val = "<cmd>lua require'dap'.step_into()<cr>";
          desc = "Step Into";
        };
        o = {
          val = "<cmd>lua require'dap'.step_over()<cr>";
          desc = "Step Over";
        };
        u = {
          val = "<cmd>lua require'dap'.step_out()<cr>";
          desc = "Step Out";
        };
        p = {
          val = "<cmd>lua require'dap'.pause()<cr>";
          desc = "Pause";
        };
        r = {
          val = "<cmd>lua require'dap'.repl.toggle()<cr>";
          desc = "Toggle Repl";
        };
        s = {
          val = "<cmd>lua require'dap'.continue()<cr>";
          desc = "Start / Continue";
        };
        q = {
          val = "<cmd>lua require'dap'.close()<cr>";
          desc = "Quit";
        };
        U = {
          val = "<cmd>lua require'dapui'.toggle({reset = true})<cr>";
          desc = "Toggle UI";
        };
        l = {
          val = "<cmd>lua require'dap.ext.vscode'.load_launchjs()<cr>";
          desc = "Load launch.json";
        };
      };
      b = {
        group = "Buffers";
        r = {
          val = "<cmd>e!<cr>";
          desc = "Force Reload Current";
        };
        R = {
          val = "<cmd>bufdo! e<cr>";
          desc = "Force Reload All";
        };
        h = {
          val = "<cmd>BufferLineCyclePrev<cr>";
          desc = "Cycle Left";
        };
        l = {
          val = "<cmd>BufferLineCycleNext<cr>";
          desc = "Cycle Right";
        };
        c = {
          val = "<cmd>let @+ = expand('%')<cr>";
          desc = "Copy Current File Name";
        };
        x = {
          group = "Close...";
          c = {
            val = "<cmd>bdelete!<cr>";
            desc = "Current";
          };
          o = {
            val = "<cmd>BufferLineCloseOthers<cr>";
            desc = "Others";
          };
          l = {
            val = "<cmd>BufferLineCloseRight<cr>";
            desc = "Right";
          };
          h = {
            val = "<cmd>BufferLineCloseLeft<cr>";
            desc = "Left";
          };
        };
      };
      e = {
        val = "<cmd>NvimTreeToggle<CR>";
        desc = "File Explorer";
      };
      l = {
        group = "LSP";
        i = {
          val = "<cmd>lua vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())<cr>";
          desc = "Toggle inlay hints";
        };
        k = {
          val = "<cmd>lua vim.diagnostic.open_float()<cr>";
          desc = "Show line diagnostics";
        };
        x = {
          val = "<cmd>LspRestart<cr>";
          desc = "Restart LSP";
        };
        a = {
          val = "<cmd>lua vim.lsp.buf.code_action()<cr>";
          desc = "Code Action";
        };
        r = {
          val = "<cmd>lua vim.lsp.buf.rename()<cr>";
          desc = "Rename";
        };
        d = {
          val = "<cmd>Telescope diagnostics bufnr=0 theme=get_ivy<cr>";
          desc = "Diagnostics";
        };
        w = {
          val = "<cmd>Telescope diagnostics<cr>";
          desc = "Workspace Diagnostics";
        };
        f = {
          val = "<cmd>lua vim.lsp.buf.format()<cr>";
          desc = "Format";
        };
        l = {
          val = "<cmd>lua require 'naxdy.lines'.toggle()<cr>";
          desc = "Toggle lines";
        };
      };
      z = {
        group = "Surround";
        "\"" = {
          val = "c\"\"<Esc>P";
          desc = "Double Quotes";
          mode = [ "v" ];
        };
        "'" = {
          val = "c''<Esc>P";
          desc = "Single Quotes";
          mode = [ "v" ];
        };
        "{" = {
          val = "c{}<Esc>P";
          desc = "Curly Braces";
          mode = [ "v" ];
        };
        "[" = {
          val = "c[]<Esc>P";
          desc = "Brackets";
          mode = [ "v" ];
        };
        "(" = {
          val = "c()<Esc>P";
          desc = "Parentheses";
          mode = [ "v" ];
        };
        "<" = {
          val = "c<lt>><Esc>P";
          desc = "HTML Tags";
          mode = [ "v" ];
        };
        "`" = {
          val = "c``<Esc>P";
          desc = "Backticks";
          mode = [ "v" ];
        };
      };
      g = {
        group = "Git";
        o = {
          val = "<cmd>lua require 'naxdy.terminal'.ghdash_toggle()<cr>";
          desc = "GH Dash";
        };
        h = {
          val = "<cmd>DiffviewFileHistory %<cr>";
          desc = "File History";
        };
        g = {
          val = "<cmd>lua require 'naxdy.terminal'.lazygit_toggle()<cr>";
          desc = "LazyGit";
        };
        b = {
          val = "<cmd>Telescope git_branches<CR>";
          desc = "Branch";
        };
        l = {
          val = "<cmd>Gitsigns toggle_current_line_blame<CR>";
          desc = "Toggle Line Blame";
        };
        L = {
          val = "<cmd>lua require 'gitsigns'.blame_line({full=true})<cr>";
          desc = "Show Full Blame";
        };
        c = {
          val = "\"cyiw<cmd>exe 'DiffviewOpen '.@c.'^!'<cr>";
          desc = "View Commit Under Cursor";
          mode = [ "n" ];
        };
        e = {
          val = "<cmd>Browsher commit<CR>";
          desc = "Copy link to selected lines";
          mode = [ "v" ];
        };
        d = {
          group = "Diff";
          c = {
            val = "2docr>";
            desc = "Accept Current (Local)";
          };
          r = {
            val = "3do<cr>";
            desc = "Accept Remote (Incoming)";
          };
          o = {
            val = "<cmd>DiffviewOpen<cr>";
            desc = "Open Diff View";
          };
          x = {
            val = "<cmd>DiffviewClose<cr>";
            desc = "Close Diff View";
          };
        };
      };
      u = {
        group = "NVIM";
        p = {
          group = "Profile";
          s = {
            val = "<cmd>lua require('plenary.profile').start(\"/tmp/plenary-profile.log\", { flame = true })<cr>";
            desc = "Start";
          };
          e = {
            val = "<cmd>lua require('plenary.profile').stop()<cr><cmd>!${inferno}/bin/inferno-flamegraph /tmp/plenary-profile.log > /tmp/plenary-flame.svg<cr><cmd>e /tmp/plenary-profile.log<cr>";
            desc = "End & View";
          };
        };
      };
      s = {
        group = "Search";
        s = {
          val = "<cmd>lua require('spectre').toggle()<cr>";
          desc = "Toggle Spectre";
        };
        u = {
          val = "<cmd>UndotreeToggle<cr>";
          desc = "Undo Tree";
        };
        e = {
          val = "<cmd>NvimTreeFindFile<cr>";
          desc = "Reveal File in Explorer";
        };
        f = {
          val = "<cmd>Telescope find_files<cr>";
          desc = "All Files";
        };
        t = {
          val = "<cmd>Telescope live_grep<cr>";
          desc = "Text";
        };
        r = {
          val = "<cmd>Telescope oldfiles<cr>";
          desc = "Open Recent File";
        };
        l = {
          val = "<cmd>Telescope resume<cr>";
          desc = "Last Search";
        };
        b = {
          val = "<cmd>Telescope buffers<cr>";
          desc = "Buffers";
        };
      };
    };
  };

  whichKeySpec = lib.flatten (whichKeyInstrsReal "" keymaps);

  whichKeyInstrsReal =
    curr: attr:
    (lib.mapAttrsToList (
      name: value:
      (
        if (value ? group) then
          [
            {
              __unkeyed-1 = curr + name;
              inherit (value) group;
            }
          ]
        else
          [ ]
      )
      ++ (
        if (value ? val) then
          [
            ({
              __unkeyed-1 = (curr + name);
              __unkeyed-2 = value.val;
              inherit (value) desc;
              mode =
                if (value ? mode) then
                  value.mode
                else
                  [
                    "n"
                    "v"
                  ];
            })
          ]
        else
          [ (if builtins.typeOf value == "set" then (whichKeyInstrsReal (curr + name) value) else [ ]) ]
      )
    ) attr);
in
nixvim.makeNixvim {
  nixpkgs = {
    inherit pkgs;
  };

  opts = {
    number = true;
    relativenumber = true;
    tabstop = 2;
    shiftwidth = 2;
    expandtab = true;
    wrap = false;
    autoindent = true;
    smartindent = true;
    cursorline = true;
    title = true;
    showmode = false;
    smartcase = true;
    ignorecase = true;
    splitbelow = true;
    splitright = true;
    swapfile = false;
    foldmethod = "indent";
    # best compatibility with most languages
    foldenable = false;
    foldexpr = "";
    fileencoding = "utf-8";
    backup = false;
    cmdheight = 1;
    termguicolors = true;
    writebackup = false;
    undofile = true;
  };

  globals = {
    mapleader = " ";
    neovide_scroll_animation_length = 0;
    neovide_refresh_rate = 240;
  };

  keymaps = [
    # copy-paste shared with OS-native buffer
    {
      action = ''"+y'';
      key = "<m-c>";
      mode = [
        "n"
        "v"
        "c"
      ];
    }
    {
      action = ''"+p'';
      key = "<m-v>";
      mode = [
        "n"
        "v"
        "c"
      ];
    }
    {
      action = ''<c-bslash><c-n>"+ya'';
      key = "<m-c>";
      mode = [ "t" ];
    }
    {
      action = ''<c-bslash><c-n>"+pa'';
      key = "<m-v>";
      mode = [ "t" ];
    }
    {
      action = ''<c-o>"+p'';
      key = "<m-v>";
      mode = [ "i" ];
    }

    # easier window switch
    {
      action = "<C-w>j";
      key = "<C-j>";
      mode = [ "n" ];
    }
    {
      action = "<C-w>h";
      key = "<C-h>";
      mode = [ "n" ];
    }
    {
      action = "<C-w>k";
      key = "<C-k>";
      mode = [ "n" ];
    }
    {
      action = "<C-w>l";
      key = "<C-l>";
      mode = [ "n" ];
    }

    # window resize
    {
      action = "<cmd>resize +2<cr>";
      key = "<C-Up>";
      mode = [ "n" ];
    }
    {
      action = "<cmd>resize -2<cr>";
      key = "<C-Down>";
      mode = [ "n" ];
    }
    {
      action = "<cmd>vertical resize -2<cr>";
      key = "<C-Left>";
      mode = [ "n" ];
    }
    {
      action = "<cmd>vertical resize +2<cr>";
      key = "<C-Right>";
      mode = [ "n" ];
    }
  ];

  extraConfigLua = builtins.readFile ./config.lua;

  extraPackages = [
    jq # js-i18n needs this
    lazygit
    shellcheck
    gh-dash
    gh
    luau-lsp
    sscli
    opencode
  ];

  # extraFiles = {
  #   "queries/rust/highlights.scm".text = ''
  #     ;; extends

  #     (closure_expression
  #       parameters: (closure_parameters) @closure)

  #     ((type_parameters) @tparams)

  #     ((type_arguments) @tparams)
  #   '';
  # };

  extraFiles =
    {
      "queries/svelte/highlights.scm".text = ''
        ;; extends

        (else_if_block (else_if_start ((block_tag) @keyword.conditional) condition: (svelte_raw_text)))
      '';
    }
    // (builtins.listToAttrs (
      map
        (e: {
          name = "lua/naxdy/${e.name}";
          value = {
            source = ./naxdy/${e.name};
          };
        })
        (
          builtins.filter (e: e.value == "regular") (
            lib.mapAttrsToList (name: value: { inherit name value; }) (builtins.readDir ./naxdy)
          )
        )
    ));

  colorschemes.vscode = {
    enable = true;
    settings = {
      color_overrides = {
        vscDisabledBlue = "#A9B7C6";
        vscPink = "#B392F0";
        vscYellowOrange = "#FFC66D";
        vscCursorDarkDark = "#222222";
        vscPopupBack = "#272727";
        vscPopupHighlightBlue = "#004b72";
      };
    };
    luaConfig.post = builtins.readFile ./highlights.lua;
  };

  extraPlugins = [
    vimPlugins.dropbar-nvim
    js-i18n
    plenary
    vimPlugins.telescope-dap-nvim
    vimPlugins.nvim-scrollbar
    (vimUtils.buildVimPlugin {
      pname = "browsher.nvim";
      version = "master";
      src = fetchFromGitHub {
        owner = "Naxdy";
        repo = "browsher.nvim";
        rev = "e73e96c8a679b6b2028a0d6754add87ad906e850";
        hash = "sha256-qA5XOzSus+0G6VK+1gm4qQI/qTHZFFghwF61XNpwaD4=";
      };
    })
  ];

  plugins = {
    spectre = {
      enable = true;
    };
    leap.enable = true;
    undotree.enable = true;
    auto-session.enable = true;
    treesitter-context = {
      enable = true;
      settings = {
        mode = "topline";
      };
    };
    diffview = {
      enable = true;
      view = {
        mergeTool = {
          layout = "diff4_mixed";
          winbarInfo = true;
        };
      };
      package = vimUtils.buildVimPlugin {
        pname = "diffview.nvim";
        version = "naxdy";
        nvimRequireCheck = "diffview";
        src = fetchFromGitHub {
          owner = "Naxdy";
          repo = "diffview.nvim";
          rev = "47de9ec6f7661c63e0deb1cad2423caa047dc821";
          sha256 = "sha256-ttQu1UUuq6QXJ78+k+Qcsls7lN2gz3xRnz34awAToSo=";
        };
        meta.homepage = "https://github.com/sindrets/diffview.nvim/";
      };
    };
    crates.enable = true;
    intellitab.enable = true;
    treesitter = {
      enable = true;
      settings = {
        indent.enable = lib.mkForce false;
        highlight = {
          enable = true;
          additional_vim_regex_highlighting = true;
        };
        auto_install = true;
        ensure_installed = [
          "git_config"
          "git_rebase"
          "gitattributes"
          "gitcommit"
          "gitignore"
        ];
      };
    };
    indent-blankline = {
      enable = true;
      settings = {
        indent = {
          char = "▏";
        };
      };
    };
    nvim-autopairs.enable = true;
    lualine = {
      enable = true;
      settings = {
        active = true;
        style = "lvim";
        options = {
          disabled_filetypes = {
            statusline = [ "alpha" ];
          };
          globalstatus = true;
        };
      };
    };
    bufferline = {
      enable = true;
      settings = {
        options = {
          themable = true;
          mode = "buffers";
          numbers = "none";
          diagnostics = "nvim_lsp";
          offsets = [
            {
              filetype = "NvimTree";
              text = "Explorer";
              highlight = "PanelHeading";
              padding = 1;
            }
          ];
        };
      };
    };
    auto-save = {
      enable = true;
      settings = {
        debounce_delay = 99999;
      };
    };
    which-key = {
      enable = true;
      settings = {
        delay = 200;
        expand = 1;
        notify = false;
        preset = false;
        replace = {
          desc = [
            [
              "<space>"
              "SPACE"
            ]
            [
              "<leader>"
              "SPACE"
            ]
            [
              "<[cC][rR]>"
              "RETURN"
            ]
            [
              "<[tT][aA][bB]>"
              "TAB"
            ]
            [
              "<[bB][sS]>"
              "BACKSPACE"
            ]
          ];
        };
        spec = whichKeySpec;
      };
    };
    nvim-tree = {
      enable = true;
      git = {
        enable = true;
        ignore = false;
      };
      diagnostics.enable = true;
    };
    gitsigns = {
      enable = true;
      settings = {
        current_line_blame = true;
      };
    };
    luasnip.enable = true;
    cmp = {
      enable = true;
      autoEnableSources = true;
      settings = {
        duplicates = {
          buffer = 1;
          path = 1;
          nvim_lsp = 0;
          luasnip = 1;
        };
        duplicates_default = 0;
        formatting = {
          max_width = 0;
          fields = [
            "kind"
            "abbr"
            "menu"
          ];
          format = ''
            function(entry, vim_item)
              local source_names = {
                nvim_lsp = "(LSP)",
                emoji = "(Emoji)",
                path = "(Path)",
                calc = "(Calc)",
                cmp_tabnine = "(Tabnine)",
                vsnip = "(Snippet)",
                luasnip = "(Snippet)",
                buffer = "(Buffer)",
                tmux = "(TMUX)",
                copilot = "(Copilot)",
                treesitter = "(TreeSitter)",
              }

              local kind_icons = {
                Array = "",
                Boolean = "",
                Class = "",
                Color = "",
                Constant = "",
                Constructor = "",
                Enum = "",
                EnumMember = "",
                Event = "",
                Field = "",
                File = "",
                Folder = "󰉋",
                Function = "",
                Interface = "",
                Key = "",
                Keyword = "",
                Method = "",
                Module = "",
                Namespace = "",
                Null = "󰟢",
                Number = "",
                Object = "",
                Operator = "",
                Package = "",
                Property = "",
                Reference = "",
                Snippet = "",
                String = "",
                Struct = "",
                Text = "",
                TypeParameter = "",
                Unit = "",
                Value = "",
                Variable = "",
              }

              vim_item.kind = kind_icons[vim_item.kind]

              -- vim_item.menu = source_names[entry.source.name]

              if vim.fn.strchars(vim_item.menu) > 50 then
                vim_item.menu = vim.fn.strcharpart(vim_item.menu, 0, 47) .. "..."
              end

              return vim_item
            end
          '';
        };
        mapping = {
          __raw = ''
            cmp.mapping.preset.insert({
              ['<C-b>'] = cmp.mapping.scroll_docs(-4),
              ['<C-f>'] = cmp.mapping.scroll_docs(4),
              ['<C-Space>'] = cmp.mapping.complete(),
              ['<C-e>'] = cmp.mapping.abort(),
              ['<CR>'] = cmp.mapping.confirm({ select = false }),
              ['<c-j>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
              ['<c-k>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
            })
          '';
        };
        snippet = {
          expand = "function(args) require('luasnip').lsp_expand(args.body) end";
        };
        sources = [
          { name = "nvim_lsp"; }
          { name = "path"; }
          { name = "buffer"; }
          { name = "clippy"; }
          { name = "treesitter"; }
          { name = "luasnip"; }
        ];
      };
    };
    # telescope needs this
    web-devicons.enable = true;
    todo-comments = {
      enable = true;
    };
    lsp-signature = {
      enable = true;
    };
    none-ls = {
      enable = true;
      settings.sources = [
        "require('naxdy.format').treefmt"
      ];
    };
    dap = {
      enable = true;
      adapters = {
        executables = {
          gdb = {
            command = "${gdb}/bin/gdb";
            args = [
              "--quiet"
              "--interpreter=dap"
            ];
          };
        };
        servers =
          let
            node = {
              host = "localhost";
              port = ''''${port}'';
              executable = {
                command = "${vscode-js-debug}/bin/js-debug";
                args = [ ''''${port}'' ];
              };
            };
          in
          {
            lldb = {
              host = "127.0.0.1";
              port = ''''${port}'';
              executable = {
                command = "${vscode-extensions.vadimcn.vscode-lldb}/share/vscode/extensions/vadimcn.vscode-lldb/adapter/codelldb";
                args = [
                  "--port"
                  ''''${port}''
                ];
              };
            };
            pwa-node = node;
            node-terminal = node;
            godot = {
              host = "127.0.0.1";
              port = 6006;
            };
          };
      };
      configurations = {
        rust = [
          {
            name = "Debug";
            type = "lldb";
            request = "launch";
            cwd = ''''${workspaceFolder}'';
            stopOnEntry = false;
            program.__raw = ''
              function(selection)
                local sep = package.config:sub(1, 1)
                local function read_target()
                   local cwd = string.format("%s%s", vim.fn.getcwd(), sep)
                   return vim.fn.input("Path to executable: ", cwd, "file")
                end
                local function compiler_error(input)
                   local _, json = pcall(vim.fn.json_decode, input)

                   if type(json) == "table" and json.reason == "compiler-message" then
                      return json.message.rendered
                   end

                   return nil
                end
                local function compiler_target(input)
                   local _, json = pcall(vim.fn.json_decode, input)

                   if
                      type(json) == "table"
                      and json.reason == "compiler-artifact"
                      and json.executable ~= nil
                      and (vim.tbl_contains(json.target.kind, "bin") or json.profile.test)
                   then
                      return json.executable
                   end

                   return nil
                end
                local function list_targets(selection)
                   local arg = string.format("--%s", selection or "bins")
                   local cmd = { "cargo", "build", arg, "--quiet", "--message-format", "json" }
                   local out = vim.fn.systemlist(cmd)

                   if vim.v.shell_error ~= 0 then
                      local errors = vim.tbl_map(compiler_error, out)
                      vim.notify(table.concat(errors, "\n"), vim.log.levels.ERROR)
                      return nil
                   end

                   local function filter(e)
                      return e ~= nil
                   end

                   return vim.tbl_filter(filter, vim.tbl_map(compiler_target, out))
                end

                local targets = list_targets(selection)

                if targets == nil then
                  return nil
                end

                if #targets == 0 then
                  return read_target()
                end

                if #targets == 1 then
                  return targets[1]
                end

                local options = { "Select a target:" }

                for index, target in ipairs(targets) do
                  local parts = vim.split(target, sep, { trimempty = true })
                  local option = string.format("%d. %s", index, parts[#parts])
                  table.insert(options, option)
                end

                local choice = vim.fn.inputlist(options)

                return targets[choice]
              end
            '';
          }
        ];
        gdscript = [
          {
            type = "godot";
            name = "Launch scene";
            request = "launch";
            project = ''''${workspaceFolder}'';
            launch_scene = true;
          }
        ];
        javascript = [
          {
            name = "Launch file";
            type = "pwa-node";
            program = ''''${file}'';
            cwd = ''''${workspaceFolder}'';
            request = "launch";
          }
        ];
      };
    };
    dap-ui = {
      enable = true;
      settings = {
        mappings.expand = [
          "<CR>"
          "x"
          "<2-LeftMouse>"
        ];
      };
    };
    dap-virtual-text = {
      enable = true;
    };
    cmp-dap.enable = true;
    telescope = {
      enable = true;
      extensions.fzf-native = {
        enable = true;
        settings = {
          fuzzy = true;
          override_generic_sorter = true;
          override_file_sorter = true;
          case_mode = "smart_case";
        };
      };
      settings = {
        defaults = {
          path_display = [ "filename_first" ];
          file_ignore_patterns = [ "^.git/" ];
          vimgrep_arguments = [
            "rg"
            "--color=never"
            "--no-heading"
            "--with-filename"
            "--line-number"
            "--column"
            "--smart-case"
            "--hidden"
            "--glob=!**/.git/*"
          ];
        };
        pickers = {
          find_files = {
            hidden = true;
          };
          lsp_references = {
            initial_mode = "normal";
          };
          diagnostics = {
            initial_mode = "normal";
          };
          lsp_implementations = {
            initial_mode = "normal";
          };
          lsp_definitions = {
            initial_mode = "normal";
          };
          lsp_type_definitions = {
            initial_mode = "normal";
          };
          buffers = {
            initial_mode = "normal";
          };
          git_commits = {
            initial_mode = "normal";
          };
          resume = {
            initial_mode = "normal";
          };
        };
      };
      extensions.file-browser.enable = true;
    };
    toggleterm = {
      enable = true;
      settings = {
        open_mapping = "[[<C-Bslash>]]";
      };
    };
    colorizer = {
      enable = true;
      settings = {
        user_default_options = {
          names = false;
          css = true;
          tailwind = "both";
        };
      };
    };
    lsp-lines.enable = true;
    lsp = {
      enable = true;
      inlayHints = true;
      servers = {
        yamlls.enable = true;
        slint_lsp.enable = true;
        terraformls = {
          enable = true;
          package = tofu-ls;
          filetypes = [
            "opentofu"
          ];
          cmd = [
            "tofu-ls"
            "serve"
          ];
        };
        bashls.enable = true;
        gopls = {
          enable = true;
          extraOptions = {
            init_options = {
              semanticTokens = true;
              hints = {
                assignVariableTypes = true;
                constantValues = true;
                functionTypeParameters = true;
                parameterNames = true;
                rangeVariableTypes = true;
              };
            };
          };
        };
        gdscript = {
          enable = true;
          package = null;
          extraOptions = {
            cmd = {
              __raw = ''
                vim.lsp.rpc.connect("127.0.0.1", 6005)
              '';
            };
          };
        };
        texlab.enable = true;
        clangd.enable = true;
        eslint = {
          enable = true;
          filetypes = [
            "js"
            "ts"
            "typescript"
            "javascript"
            "tsx"
            "jsx"
            "typescriptreact"
            "javascriptreact"
            "svelte"
          ];
        };
        tailwindcss.enable = true;
        graphql = {
          filetypes = [
            "ts"
            "gql"
            "graphql"
            "typescript"
            "typescriptreact"
            "javascript"
            "svelte"
          ];
          enable = true;
          package = pkgs.graphql-language-service-cli;
        };
        nil_ls = {
          enable = true;
          settings = {
            formatting.command = [ "${nixfmt-rfc-style}/bin/nixfmt" ];
          };
        };
        ts_ls = {
          enable = true;
          extraOptions = {
            init_options = {
              preferences = {
                includeCompletionsForModuleExports = true;
                includeCompletionsForImportStatements = true;
                importModuleSpecifierPreference = "non-relative";
              };
            };
          };
          settings = {
            init_options = {
              preferences = {
                importModuleSpecifierPreference = "non-relative";
              };
            };
            typescript = {
              preferences = {
                includeCompletionsForModuleExports = true;
                includeCompletionsForImportStatements = true;
                importModuleSpecifier = "non-relative";
              };
              inlayHints = {
                includeInlayParameterNameHints = "all"; # -- 'none' | 'literals' | 'all'
                includeInlayParameterNameHintsWhenArgumentMatchesName = true;
                includeInlayVariableTypeHints = true;
                includeInlayFunctionParameterTypeHints = true;
                includeInlayVariableTypeHintsWhenTypeMatchesName = true;
                includeInlayPropertyDeclarationTypeHints = true;
                includeInlayFunctionLikeReturnTypeHints = true;
                includeInlayEnumMemberValueHints = true;
              };
            };
            javascript = {
              preferences = {
                includeCompletionsForModuleExports = true;
                includeCompletionsForImportStatements = true;
                importModuleSpecifier = "non-relative";
              };
              inlayHints = {
                includeInlayParameterNameHints = "all"; # -- 'none' | 'literals' | 'all'
                includeInlayParameterNameHintsWhenArgumentMatchesName = true;
                includeInlayVariableTypeHints = true;
                includeInlayFunctionParameterTypeHints = true;
                includeInlayVariableTypeHintsWhenTypeMatchesName = true;
                includeInlayPropertyDeclarationTypeHints = true;
                includeInlayFunctionLikeReturnTypeHints = true;
                includeInlayEnumMemberValueHints = true;
              };
            };
          };
        };
        svelte.enable = true;
        rust_analyzer = {
          enable = true;
          installCargo = false;
          installRustc = false;
          settings = {
            check = {
              command = "clippy";
            };
          };
        };
        qmlls = {
          enable = true;
        };
        luau_lsp = {
          enable = true;
          package = pkgs.luau-lsp;
          filetypes = [
            "luau"
          ];
        };
        lua_ls = {
          enable = true;
          filetypes = [
            "lua"
          ];
          onAttach = {
            function = builtins.readFile ./lspconfig.lua;
          };
        };
        pyright.enable = true;
      };
    };
  };
}
