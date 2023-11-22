"""
Configuration example for ``ptpython``.

Copy this file to $XDG_CONFIG_HOME/ptpython/config.py
On Linux, this is: ~/.config/ptpython/config.py
On macOS, this is: ~/Library/Application Support/ptpython/config.py
"""
from typing import TYPE_CHECKING
from prompt_toolkit.output import ColorDepth

from ptpython.layout import CompletionVisualisation

if TYPE_CHECKING:
    from ptpython.repl import PythonRepl

__all__ = ["configure"]


def configure(repl: PythonRepl):
    """\
    Configuration method.

    This is called during the start-up of ptpython.
    """
    # Show function signature (bool).
    repl.show_signature = True

    # Show docstring (bool).
    repl.show_docstring = True

    # Show completions. (NONE, POP_UP, MULTI_COLUMN or TOOLBAR)
    repl.completion_visualisation = CompletionVisualisation.POP_UP

    # When CompletionVisualisation.POP_UP has been chosen, use this scroll_offset in the completion menu.
    repl.completion_menu_scroll_offset = 0

    # Show line numbers (when the input contains multiple lines.)
    repl.show_line_numbers = True

    # Swap light/dark colors on or off
    repl.swap_light_and_dark = True

    # Highlight matching parentheses.
    repl.highlight_matching_parenthesis = True

    # Mouse support.
    repl.enable_mouse_support = True

    # Complete while typing. (Don't require tab before the completion menu is shown.)
    repl.complete_while_typing = True

    # Fuzzy and dictionary completion.
    repl.enable_fuzzy_completion = True

    # Use the ipython prompt. (Display 'In [1]' instead of '>>>'.)
    repl.prompt_style = "ipython"

    # History Search.
    # When True, going back in history will filter the history on the records
    # starting with the current input. (Like readline.)
    # Note: When enable, please disable the `complete_while_typing` option. otherwise, when there is a completion
    #       available, the arrows will browse through the available completions instead of the history.
    repl.enable_history_search = True

    # Enable auto suggestions. (Pressing right arrow will complete the input, based on the history.)
    repl.enable_auto_suggest = True

    # Ask for confirmation on exit.
    repl.confirm_exit = False

    # Enable input validation. (Don't try to execute when the input contains syntax errors.)
    repl.enable_input_validation = True

    # Use this colorscheme for the code.
    # Ptpython uses Pygments for code styling, so you can choose from Pygments' color schemes. See:
    # - https://pygments.org/docs/styles/
    # - https://pygments.org/demo/
    # A colorscheme that looks good on dark backgrounds is 'native':
    repl.use_code_colorscheme("native")

    # Set color depth (keep in mind that not all terminals support true color).
    repl.color_depth = ColorDepth.DEPTH_24_BIT  # True color.

    # Enable output formatting (using black)
    repl.enable_output_formatting = True

    # Enable pager for output
    repl.enable_pager = True
