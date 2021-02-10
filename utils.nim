import strutils

proc hexDump*[T](v: T): string =
    template read_u8(p: ByteAddress): untyped =
        (cast[ptr uint8](p)[])
  
    var p = cast[ByteAddress](v.unsafeAddr)
    let e = p + v.sizeof
    result = ""
    while p < e:
        result.add(read_u8(p).toHex)
        p.inc
    
    return result

proc charDump*[T](v: T): string =
    template read_u8(p: ByteAddress): char =
        cast[ptr char](p)[]
  
    var p = cast[ByteAddress](v.unsafeAddr)
    let e = p + v.sizeof
    result = ""
    while p < e:
        result.add(read_u8(p))
        p.inc
    
    return result