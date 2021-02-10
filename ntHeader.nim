import wintypes

type
    IMAGE_FILE_HEADER* {.pure.} = object
        Machine*: WORD
        NumberOfSections*: WORD
        TimeDateStamp*: DWORD
        PointerToSymbolTable*: DWORD
        NumberOfSymbols*: DWORD
        SizeOfOptionalHeader*: WORD
        Characteristics*: WORD
    PIMAGE_FILE_HEADER* = ptr IMAGE_FILE_HEADER

type
    IMAGE_DATA_DIRECTORY* {.pure.} = object
        VirtualAddress*: DWORD
        Size*: DWORD
    PIMAGE_DATA_DIRECTORY* = ptr IMAGE_DATA_DIRECTORY

const
    IMAGE_NUMBEROF_DIRECTORY_ENTRIES* = 16

type
    IMAGE_OPTIONAL_HEADER64* {.pure.} = object
        Magic*: WORD
        MajorLinkerVersion*: BYTE
        MinorLinkerVersion*: BYTE
        SizeOfCode*: DWORD
        SizeOfInitializedData*: DWORD
        SizeOfUninitializedData*: DWORD
        AddressOfEntryPoint*: DWORD
        BaseOfCode*: DWORD
        ImageBase*: ULONGLONG
        SectionAlignment*: DWORD
        FileAlignment*: DWORD
        MajorOperatingSystemVersion*: WORD
        MinorOperatingSystemVersion*: WORD
        MajorImageVersion*: WORD
        MinorImageVersion*: WORD
        MajorSubsystemVersion*: WORD
        MinorSubsystemVersion*: WORD
        Win32VersionValue*: DWORD
        SizeOfImage*: DWORD
        SizeOfHeaders*: DWORD
        CheckSum*: DWORD
        Subsystem*: WORD
        DllCharacteristics*: WORD
        SizeOfStackReserve*: ULONGLONG
        SizeOfStackCommit*: ULONGLONG
        SizeOfHeapReserve*: ULONGLONG
        SizeOfHeapCommit*: ULONGLONG
        LoaderFlags*: DWORD
        NumberOfRvaAndSizes*: DWORD
        DataDirectory*: array[IMAGE_NUMBEROF_DIRECTORY_ENTRIES, IMAGE_DATA_DIRECTORY]
    PIMAGE_OPTIONAL_HEADER64* = ptr IMAGE_OPTIONAL_HEADER64

type
    IMAGE_NT_HEADERS64* {.pure.} = object
        Signature*: DWORD
        FileHeader*: IMAGE_FILE_HEADER
        OptionalHeader*: IMAGE_OPTIONAL_HEADER64
    PIMAGE_NT_HEADERS64* = ptr IMAGE_NT_HEADERS64


type 
    NTHeader* = object
        header: PIMAGE_NT_HEADERS64

proc `header=`*(s: var NTHeader, value: PIMAGE_NT_HEADERS64) {.inline.} =
  ## setter of host address
  s.header = value

proc header*(s: NTHeader): PIMAGE_NT_HEADERS64 {.inline.} =
  ## getter of host address
  s.header

proc size*(s: NTHeader): int {.inline.} =
    s.header[].sizeof