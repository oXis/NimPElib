import wintypes

const
    IMAGE_SIZEOF_SHORT_NAME* = 8

type
    # IMAGE_SECTION_HEADER_Misc* {.pure, union.} = object
    #     PhysicalAddress*: DWORD
    #     VirtualSize*: DWORD
    IMAGE_SECTION_HEADER* {.pure.} = object
        Name*: array[IMAGE_SIZEOF_SHORT_NAME, BYTE]
        VirtualSize*: DWORD
        VirtualAddress*: DWORD
        SizeOfRawData*: DWORD
        PointerToRawData*: DWORD
        PointerToRelocations*: DWORD
        PointerToLinenumbers*: DWORD
        NumberOfRelocations*: WORD
        NumberOfLinenumbers*: WORD
        Characteristics*: DWORD
    PIMAGE_SECTION_HEADER* = ptr IMAGE_SECTION_HEADER