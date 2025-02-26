<?php

define('REL_FILENAME', 'word/_rels/document.xml.rels');

function hellYeah($code, $msg) {
    http_response_code($code);
    die($msg);
}


/* sanity checks */

if ($_SERVER['REQUEST_METHOD'] !== 'POST')
    hellYeah(405, 'Invalid request method.');

if (!isset($_FILES['input']))
    hellYeah(400, 'Please upload a file.');

if (isset($_FILES['input']) && $_FILES['input']['error'] !== UPLOAD_ERR_OK)
    hellYeah(500, 'Upload error.');

if ($_FILES['input']['type'] != 'application/vnd.openxmlformats-officedocument.wordprocessingml.document')
    hellYeah(400, 'Please upload a Word document!');


/* processing uploaded Word - valid document contains relationship table */

$zip = new ZipArchive();
$zipFilename = $_FILES['input']['tmp_name'];
if ($zip->open($zipFilename) !== true || $zip->locateName(REL_FILENAME) === false)
    hellYeah(400, 'File is not a valid Word document.');

$relsDom = simplexml_load_string($zip->getFromName(REL_FILENAME));
if ($relsDom === false)
    hellYeah(400, 'Invalid object relationship table. Document may be corrupted.');


/* extract document's "media" folder into a temporary directory */
$tmpDir = exec("mktemp -d --tmpdir=/tmp/ zipXXXXXXXXX");
shell_exec("unzip $zipFilename \"word/media*\" -d \"$tmpDir\"");
function cleanup($tmpDir) { shell_exec("rm -rf $tmpDir"); }
register_shutdown_function('cleanup', $tmpDir); // cleanup in the end

chdir("$tmpDir/word/media");
ini_set('open_basedir', '.');

$messages = [];
foreach($relsDom->Relationship as $rel) {
    if($rel['Type'] == 'http://schemas.openxmlformats.org/officeDocument/2006/relationships/image') {
        if (!str_starts_with($rel['Target'], 'media/'))
            continue;
        $filename = substr($rel['Target'], 6);

        $file = @file_get_contents($filename);

        if ($file === false) // Object relationship table points to inexistent file. Document may be corrupted
            break;

        $result = @zlib_decode($file); // This will expose them hackers!
        if ($result !== false)
            $messages[] = $result;
    }
}

// cleanup
system("rm -rf $tmpDir");

?>
   <!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>zStego - Results</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    </head>
    <body class="bg-light">
        <div class="container text-center mt-5">
            <h1 class="display-4">Scan Results</h1>
            <?php if (!empty($messages)): ?>
                <div class="alert alert-success mt-4">
                    <h4>Hidden Messages Found:</h4>
                    <ul class="list-group">
                        <?php foreach ($messages as $message): ?>
                            <li class="list-group-item"> <?= htmlspecialchars($message) ?> </li>
                        <?php endforeach; ?>
                    </ul>
                </div>
            <?php else: ?>
                <div class="alert alert-info mt-4">No hidden messages found.</div>
            <?php endif; ?>
            <a href="index.php" class="btn btn-secondary mt-3">Back to Home</a>
        </div>
    </body>
</html>
