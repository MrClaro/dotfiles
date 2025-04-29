return {
  {
    "javiorfo/nvim-springtime",
    lazy = true,
    cmd = { "Springtime", "SpringtimeUpdate" },
    dependencies = {
      "javiorfo/nvim-popcorn",
      "javiorfo/nvim-spinetta",
      "hrsh7th/nvim-cmp",
    },
    build = function()
      require("springtime.core").update()
    end,
    opts = {
      -- This section is optional
      -- If you want to change default configurations
      -- In packer.nvim use require'springtime'.setup { ... }

      -- Springtime popup section
      spring = {
        -- Project: Gradle, Gradle Kotlin and Maven (Gradle default)
        project = {
          selected = 1,
        },
        -- Language: Java, Kotlin and Groovy (Java default)
        language = {
          selected = 1,
        },
        -- Packaging: Jar and War (Jar default)
        packaging = {
          selected = 1,
        },
        -- Project Metadata defaults:
        -- Change the default values as you like
        -- This can also be edited in the popup
        project_metadata = {
          group = "com.example",
          artifact = "demo",
          name = "demo",
          package_name = "com.example.demo",
          version = "0.0.1-SNAPSHOT",
        },
      },

      -- Some popup options
      dialog = {
        -- The keymap used to select radio buttons (normal mode)
        selection_keymap = "<C-Space>",

        -- The keymap used to generate the Spring project (normal mode)
        generate_keymap = "<C-CR>",

        -- If you want confirmation before generate the Spring project
        confirmation = true,

        -- Highlight links to Title and sections for changing colors
        style = {
          title_link = "Boolean",
          section_link = "Type",
        },
      },

      -- Workspace is where the generated Spring project will be saved
      workspace = {
        -- Default where Neovim is open
        path = vim.fn.expand("%:p:h"),

        -- Spring Initializr generates a zip file
        -- Decompress the file by default
        decompress = true,

        -- If after generation you want to open the folder
        -- Opens the generated project in Neovim by default
        open_auto = true,
      },

      -- This could be enabled for debugging purposes
      -- Generates a springtime.log with debug and errors.
      internal = {
        log_debug = false,
      },
    },
  },
  {
    "elmcgill/springboot-nvim",
    depedencies = {
      "neovim/nvim-lspconfig",
      "mfussenegger/nvim-jdtls",
    },
    config = function()
      local springboot_nvim = require("springboot-nvim")
      vim.keymap.set("n", "<leader>Jr", springboot_nvim.boot_run, { desc = "Spring Boot Run Project" })
      vim.keymap.set("n", "<leader>Jc", springboot_nvim.generate_class, { desc = "Java Create Class" })
      vim.keymap.set("n", "<leader>Ji", springboot_nvim.generate_interface, { desc = "Java Create Interface" })
      vim.keymap.set("n", "<leader>Je", springboot_nvim.generate_enum, { desc = "Java Create Enum" })
      springboot_nvim.setup({})
    end,
  },
  {
    "JavaHello/java-deps.nvim",
    lazy = true,
    ft = "java",
    dependencies = "mfussenegger/nvim-jdtls",
    config = function()
      require("java-deps").setup({})
    end,
  },
}
