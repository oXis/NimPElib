import wintypes

type
    IMAGE_TLS_DIRECTORY64* {.pure.} = object
        StartAddressOfRawData*: ULONGLONG
        EndAddressOfRawData*: ULONGLONG
        AddressOfIndex*: ULONGLONG
        AddressOfCallBacks*: ULONGLONG
        SizeOfZeroFill*: DWORD
        Characteristics*: DWORD
    PIMAGE_TLS_DIRECTORY64* = ptr IMAGE_TLS_DIRECTORY64
    
    IMAGE_TLS_DIRECTORY32* {.pure.} = object
        StartAddressOfRawData*: DWORD
        EndAddressOfRawData*: DWORD
        AddressOfIndex*: DWORD
        AddressOfCallBacks*: DWORD
        SizeOfZeroFill*: DWORD
        Characteristics*: DWORD
    PIMAGE_TLS_DIRECTORY32* = ptr IMAGE_TLS_DIRECTORY32