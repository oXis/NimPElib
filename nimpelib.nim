import streams
import memfiles
import utils

import wintypes
import dosheader
import ntheader
import datadirectory

# proc `+`(a:pointer,p:int): pointer =
#   result = cast[pointer](cast[int](a) + p)

type
    PE = object
        dosHeader: IMAGE_DOS_HEADER
        ntheader: IMAGE_NT_HEADERS64

proc newPE(binPath: string): PE =

    let stream = newFileStream(binPath, mode = fmRead)
    defer: stream.close()

    result = PE()

    stream.read(result.dosheader)

    stream.setPosition(result.dosheader.e_lfanew)
    stream.read(result.ntheader)

when isMainModule:

    let fileName: string = "./nimpelib.exe"

    var pe = newPE(fileName)

    echo pe.dosHeader.e_magic.hexDump
    pe.dosHeader.e_magic = 0x0000
    echo pe.dosHeader.e_magic.hexDump

    echo pe.ntheader.OptionalHeader.Magic.hexDump
    pe.ntheader.OptionalHeader.Magic = 0x0000
    echo pe.ntheader.OptionalHeader.Magic.hexDump

    echo pe.ntheader.OptionalHeader.DataDirectory[IMAGE_DIRECTORY_ENTRY_IMPORT].Size.hexDump
