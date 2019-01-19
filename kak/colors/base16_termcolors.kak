evaluate-commands %sh{
    base00='black'
    base01='bright-green'
    base02='bright-yellow'
    base03='bright-black'
    base04='bright-blue'
    base05='white'
    base06='bright-magenta'
    base07='bright-white'
    base08='red'
    base09='bright-red'
    base0A='yellow'
    base0B='green'
    base0C='cyan'
    base0D='blue'
    base0E='magenta'
    base0F='bright-cyan'

    ## code
    echo "
        face global value ${base09}
        face global type ${base0A}
        face global variable ${base08}
        face global module ${base0D}
        face global function ${base0D}
        face global string ${base0B}
        face global keyword ${base0E}
        face global operator default
        face global attribute ${base0E}
        face global comment ${base03}
        face global meta ${base08}
        face global builtin default
    "

    ## markup
    echo "
        face global title ${base0D}
        face global header ${base0D}
        face global bold ${base0A}
        face global italic ${base0E}
        face global mono ${base0B}
        face global block ${base0C}
        face global link ${base09}
        face global bullet ${base08}
        face global list default
    "

    ## builtin
    echo "
        face global Default ${base05}
        face global PrimarySelection ${base05},${base02}
        face global SecondarySelection ${base04},${base01}
        face global PrimaryCursor ${base00},${base05}+fg
        face global SecondaryCursor ${base00},${base04}+fg
        face global PrimaryCursorEol ${base00},${base04}+fg
        face global SecondaryCursorEol ${base00},${base03}+fg
        face global MenuForeground ${base01},${base05}
        face global MenuBackground ${base04},${base01}
        face global MenuInfo default
        face global Information ${base04},${base01}
        face global Error ${base01},${base08}
        face global StatusLine ${base04},${base01}
        face global StatusLineMode ${base0A}
        face global StatusLineInfo default
        face global StatusLineValue ${base0D}
        face global StatusCursor ${base01},${base04}
        face global Prompt ${base01},${base04}
        face global BufferPadding ${base03}
        face global LineNumbers ${base03},${base01}
        face global LineNumberCursor ${base01},${base04}
        face global LineNumbersWrapped ${base01},${base01}
        face global MatchingChar ${base00},${base04}+fg
        face global Whitespace ${base03}+f
    "

    ## extras
    echo "
    	face global GitDiffFlags default,${base01}
    	face global LineFlagErrors ${base08},${base01}
    "
}
