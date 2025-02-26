import sys
import pefile

key = [0x66,0x6f,0x72,0x67,0x69,0x76,0x65,0x6d,0x65,0x66,0x61,0x74,0x68,0x65,0x72]
def invert_nibbles(b):
    return (b & 0xf0) >> 4 | (b & 0x0f) << 4 

def main():
    if len(sys.argv) != 2:
        sys.exit(1)

    pe_path = sys.argv[1]

    try:
        pe = pefile.PE(pe_path)
    except Exception as e:
        sys.exit(1)

    text_section = None
    for section in pe.sections:
        if b'.text' in section.Name:
            text_section = section
            break

    if text_section is None:
        sys.exit(2)

    data = bytearray(text_section.get_data())
    pages = text_section.SizeOfRawData // 0x1000
   
    for i in range(pages):
        offset = i * 0x1000
        for j in range(0x1000):
            data[offset + j] = invert_nibbles(data[offset + j])
            data[offset + j] ^= key[j % len(key)]

    pe.set_bytes_at_offset(text_section.PointerToRawData, bytes(data))
    pe.write('molly_dec.exe')
    
if __name__ == "__main__":
    main()