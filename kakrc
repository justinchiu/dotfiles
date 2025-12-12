add-highlighter global/ number-lines -hlcursor
add-highlighter global/ show-matching

# indentation
set-option global tabstop     4
set-option global indentwidth 4
map global insert <tab> '<a-;><a-gt>'
map global insert <s-tab> '<a-;><a-lt>'

# Display the status bar on top
set-option global ui_options ncurses_status_on_top=true

# Highlight trailing whitespace
add-highlighter global/ regex \h+$ 0:Error

# Softwrap long lines
add-highlighter global/ wrap -word -indent

# Haskell-specific settings
hook global WinSetOption filetype=haskell %{
    set-option window indentwidth 2
}
