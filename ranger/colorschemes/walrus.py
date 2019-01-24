from ranger.gui.color import *
from ranger.colorschemes.default import Default

class Scheme(Default):
    progress_bar_color = green
    def use(self, context):
        cut, copied = context.cut, context.copied
        context.cut, context.copied = False, False

        fg, bg, attr = super().use(context)

        if not context.selected and (cut or copied):
            bg = 8
            attr |= bold

        return fg, bg, attr
