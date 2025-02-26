import sys
import pefile
from Crypto.Cipher import ChaCha20

chacha_key = bytes([
    81, 90, 238, 246,
    49, 96, 101, 57,
    154, 226, 109, 170,
    143, 34, 55, 109,
    174, 11, 21, 112,
    250, 101, 27, 136,
    129, 218, 111, 100,
    38, 121, 11, 3
])
chacha_nonce = bytes([0xd0, 0, 0, 0, 0, 0, 0, 0])

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
        cipher = ChaCha20.new(key=chacha_key, nonce=chacha_nonce)
        data[offset:offset + 0x1000] = bytearray(cipher.decrypt(data[offset:offset + 0x1000]))
    

    pe.set_bytes_at_offset(text_section.PointerToRawData, bytes(data))
    pe.write('molly_revenge_dec.exe')
    
if __name__ == "__main__":
    main()