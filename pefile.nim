import dosheader
import ntheader
import sectionheader
import tlsdirectory

import wintypes

type
    PE64* = object
        dosHeader*: IMAGE_DOS_HEADER
        ntHeader*: IMAGE_NT_HEADERS64
        sectionHeader*: seq[IMAGE_SECTION_HEADER]
        sectionData*: seq[seq[byte]]

        tlsDirectory*: IMAGE_TLS_DIRECTORY64
    
    
    # PE32* = object
    #     dosHeader: IMAGE_DOS_HEADER
    #     ntHeader: IMAGE_NT_HEADERS32
    #     sectionHeader: seq[IMAGE_SECTION_HEADER]
    #     sectionData: seq[seq[byte]]

proc getSectionWithRva*(p: PE64, rva: DWORD): int =
    
    var m: DWORD

    for i in 0..(p.sectionHeader.len - 1):

        m = max(p.sectionHeader[i].VirtualSize, p.sectionHeader[i].SizeOfRawData)

        if p.sectionHeader[i].VirtualAddress <= rva and p.sectionHeader[i].VirtualAddress + m > rva:
            return i
    
    return -1

proc rvaToSectionOffset*(p: PE64, rva: DWORD): DWORD =
    
    # ??
    if rva < 0x1000:
        return rva

    var s = p.getSectionWithRva(rva)

    if s == 0xFFFF or rva > (p.sectionHeader[s].VirtualAddress + p.sectionHeader[s].SizeOfRawData):
        return DWORD.high

    return rva - p.sectionHeader[s].VirtualAddress

proc rvaToOffset*(p: PE64, rva: DWORD): DWORD =
    
    # ??
    if rva < 0x1000:
        return rva

    var s = p.getSectionWithRva(rva)

    if s == 0xFFFF or rva > (p.sectionHeader[s].VirtualAddress + p.sectionHeader[s].SizeOfRawData):
        return DWORD.high

    return p.sectionHeader[s].PointerToRawData + rva - p.sectionHeader[s].VirtualAddress

proc directorySectionOffetToRawData*(p: PE64, d: int): ptr byte =

    var s = p.getSectionWithRva(p.ntHeader.OptionalHeader.DataDirectory[d].VirtualAddress)
    var t = p.rvaToSectionOffset(p.ntHeader.OptionalHeader.DataDirectory[d].VirtualAddress)

    return p.sectionData[s][t].unsafeAddr
