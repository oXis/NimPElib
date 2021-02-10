# import streams
import memfiles
import utils

# import wintypes
import dosHeader
import ntHeader

proc `+`(a:pointer,p:int): pointer =
  result = cast[pointer](cast[int](a) + p)

type
    PE = object
        dosHeader: DOSHeaderType
        ntheader: NTHeader

proc newPE(buffer: pointer): PE =

    var dosheader: DOSHeaderType
    dosheader.header = cast[PIMAGE_DOS_HEADER](buffer)

    var ntheader: NTHeader
    ntheader.header = cast[PIMAGE_NT_HEADERS64](buffer + dosheader.header.e_lfanew)

    PE(dosHeader: dosheader, ntheader: ntheader)

proc mapBin(binPath: string): pointer =
    var inp = memfiles.open(binPath)

    return inp.mem

# proc read_bin(binPath: string): array[64, byte] =

#     let stream = newFileStream(binPath, mode = fmRead)
#     defer: stream.close()

#     var buffer: array[64, byte]
#     discard stream.readData(addr buffer, 64)

#     return buffer

when isMainModule:

    let fileName: string = "./nimpelib.exe"

    var file = mapBin(fileName)

    # var buffer = read_bin(fileName)

    var pefile: PE = newPE(file)

    # e_magic
    echo pefile.dosHeader.header.e_magic.charDump
    echo pefile.ntheader.header.Signature.charDump
    echo pefile.ntheader.header.OptionalHeader.Magic.hexDump