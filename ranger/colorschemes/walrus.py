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

        if fg > 8 and fg < 15:
            fg -= 8

        if bg > 8 and bg < 15:
            bg -= 8

        return fg, bg, attr
