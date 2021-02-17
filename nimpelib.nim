import streams
import strutils

import utils
import pefile
import wintypes
import dosheader
import ntheader
import sectionheader
import datadirectory
import tlsdirectory

# proc `+`(a:pointer,p:int): pointer =
#   result = cast[pointer](cast[int](a) + p)

proc newPE(binPath: string): PE64 =

    let stream = newFileStream(binPath, mode = fmRead)
    defer: stream.close()

    result = PE64()

    stream.read(result.dosheader)

    stream.setPosition(result.dosheader.e_lfanew)
    stream.read(result.ntHeader)

    result.sectionHeader.setLen(result.ntHeader.FileHeader.NumberOfSections)
    result.sectionData.setLen(result.ntHeader.FileHeader.NumberOfSections)

    for i in 0..result.sectionHeader.len - 1:
        stream.read(result.sectionHeader[i])

    for i, s in result.sectionHeader:

        if s.SizeOfRawData == 0:
            continue

        stream.setPosition(s.PointerToRawData)
        result.sectionData[i].setLen(s.SizeOfRawData)

        discard stream.readData(addr result.sectionData[i][0], s.SizeOfRawData)

    stream.setPosition(result.rvaToOffset(result.ntHeader.OptionalHeader.DataDirectory[IMAGE_DIRECTORY_ENTRY_TLS].VirtualAddress))
    stream.read(result.tlsDirectory)

    # echo stream.readUint16().hexDump << SECTION HEADER starts

when isMainModule:

    let fileName: string = "./PE-bear.exe"

    var pe = newPE(fileName)

    echo "PE Header: ", pe.dosHeader.e_magic.toHex

    echo "NT Header: ", pe.ntHeader.OptionalHeader.Magic.toHex

    echo "SectionAlignment: ", pe.ntHeader.OptionalHeader.SectionAlignment.toHex
    var offset: int = pe.dosheader.sizeof + pe.ntHeader.sizeof + pe.sectionHeader[0].sizeof * pe.ntHeader.FileHeader.NumberOfSections.int

    for i in 0..pe.ntHeader.FileHeader.NumberOfSections.int - 1:
        echo "Name: ", pe.sectionHeader[i].Name.charDump
        echo "\tVirtualAddress: ", pe.sectionHeader[i].VirtualAddress.toHex

        echo "\tAligned Raw Size: ", pe.sectionHeader[i].SizeOfRawData.toHex
        echo "\tAligned Raw Address: ", alignOffset(offset, pe.ntHeader.OptionalHeader.FileAlignment).toHex
        
        try:
            echo "\tFirst 10 bytes: ", pe.sectionData[i][0..10].hexDump
        except IndexDefect:
            discard

        offset += pe.sectionHeader[i].SizeOfRawData

    echo "IMAGE_DIRECTORY_ENTRY_IMPORT: ", pe.ntHeader.OptionalHeader.DataDirectory[IMAGE_DIRECTORY_ENTRY_TLS].VirtualAddress.toHex

    echo pe.tlsDirectory.StartAddressOfRawData.toHex