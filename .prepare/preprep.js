const fs = require('fs');
const path = require('path');
const currentDir = process.cwd();
const { execSync } = require('child_process');

let  webrootDirStat = false;

const copyFolderRecursiveSync = function( source, target ) {
    var files = [];

    //check if folder needs to be created or integrated
    var targetFolder = path.join( target, path.basename( source ) );
    if ( !fs.existsSync( target ) ) {
        fs.mkdirSync( target );
    }

    //copy
    if ( fs.lstatSync( source ).isDirectory() ) {
        files = fs.readdirSync( source );
        files.forEach( function ( file ) {
            var curSource = path.join( source, file );
            if ( fs.lstatSync( curSource ).isDirectory() ) {
                copyFolderRecursiveSync( curSource, targetFolder );
            } else {
                fs.copyFileSync( curSource, path.join(targetFolder,file) );
            }
        } );
    }
}


try{
    webrootDirStat = fs.statSync(path.join(currentDir, 'webroot'));
} catch(e) {}


if(webrootDirStat === false) {
    console.log("(Creating the limesurvey repository and checking it out in develop...)");

    execSync("git clone https://github.com/LimeSurvey/LimeSurvey.git ./webroot", {stdio: [process.stdin, process.stdout, process.stdout ]});

    execSync("git checkout develop", {cwd: path.join(currentDir,'webroot')});

    fs.copyFileSync(path.join(currentDir,'.prepare', 'config.php'), path.join(currentDir, 'webroot','application','config','config.php'));
} else {
    // update the repository
    console.log("(Updating limsurvey ...)");
    execSync("git pull", {cwd: path.join(currentDir,'webroot')});
}

//# copiyng necessary files and folders

console.log("(Copying files and folders ...)");
fs.copyFileSync(path.join(currentDir,'.prepare', 'config.php'), path.join(currentDir, 'webroot','application','config','config.php'));
copyFolderRecursiveSync(path.join(currentDir,'.provision'), path.join(currentDir,"/webroot/"));
