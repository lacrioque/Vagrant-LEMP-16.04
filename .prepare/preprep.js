const fs = require('fs');
const path = require('path');
const currentDir = process.cwd();
const { execSync } = require('child_process');

let  webrootDirStat = false;
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
try{ 
    execSync("cp -R .provision /webroot/");
} catch(e){}
