# snacks.win.Config: vim.api.keyset.win_config

* style?       string merges with config from `Snacks.config.styles[style]`
* show?        boolean Show the window immediately (default: true)
* footer_keys? boolean|string[] Show keys footer. When string[], only show those keys with lhs (default: false)
* height?      number|fun(self:snacks.win):number Height of the window. Use <1 for relative height. 0 means full height. (default: 0.9)
* width?       number|fun(self:snacks.win):number Width of the window. Use <1 for relative width. 0 means full width. (default: 0.9)
* min_height?  number Minimum height of the window
* max_height?  number Maximum height of the window
* min_width?   number Minimum width of the window
* max_width?   number Maximum width of the window
* col?         number|fun(self:snacks.win):number Column of the window. Use <1 for relative column. (default: center)
* row?         number|fun(self:snacks.win):number Row of the window. Use <1 for relative row. (default: center)
* minimal?     boolean Disable a bunch of options to make the window minimal (default: true)
* position?    "float"|"bottom"|"top"|"left"|"right"|"current"
* border?      "none"|"top"|"right"|"bottom"|"left"|"top_bottom"|"hpad"|"vpad"|"rounded"|"single"|"double"|"solid"|"shadow"|"bold"|string[]|false|true
* buf?         number If set, use this buffer instead of creating a new one
* file?        string If set, use this file instead of creating a new buffer
* enter?       boolean Enter the window after opening (default: false)
* backdrop?    number|false|snacks.win.Backdrop Opacity of the backdrop (default: 60)
* wo?          vim.wo|{} window options
* bo?          vim.bo|{} buffer options
* b?           table<string, any> buffer local variables
* w?           table<string, any> window local variables
* ft?          string filetype to use for treesitter/syntax highlighting. Won't override existing filetype
* scratch_ft?  string filetype to use for scratch buffers
* keys?        table<string, false|string|fun(self: snacks.win)|snacks.win.Keys> Key mappings
* on_buf?      fun(self: snacks.win) Callback after opening the buffer
* on_win?      fun(self: snacks.win) Callback after opening the window
* on_close?    fun(self: snacks.win) Callback after closing the window
* fixbuf?      boolean don't allow other buffers to be opened in this window
* text?        string|string[]|fun():(string[]|string) Initial lines to set in the buffer
* actions?     table<string, snacks.win.Action.spec> Actions that can be used in key mappings
* resize?      boolean Automatically resize the window when the editor is resized
* stack?       boolean When enabled, multiple split windows with the same position will be stacked together (useful for terminals)
