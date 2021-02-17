import wintypes

type 
    IMAGE_DOS_HEADER* {.pure.} = object
        e_magic*: WORD
        e_cblp*: WORD
        e_cp*: WORD
        e_crlc*: WORD
        e_cparhdr*: WORD
        e_minalloc*: WORD
        e_maxalloc*: WORD
        e_ss*: WORD
        e_sp*: WORD
        e_csum*: WORD
        e_ip*: WORD
        e_cs*: WORD
        e_lfarlc*: WORD
        e_ovno*: WORD
        e_res*: array[4, WORD]
        e_oemid*: WORD
        e_oeminfo*: WORD
        e_res2*: array[10, WORD]
        e_lfanew*: LONG
    PIMAGE_DOS_HEADER* = ptr IMAGE_DOS_HEADER
    