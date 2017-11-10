# only do a clone if the directory does not exist
CURRENT_PATH=$(pwd)
if [ ! -d $CURRENT_PATH"/webroot" ]; then
    echo  "(Creating the limesurvey repository and checking it out in develop...)"
    git clone https://github.com/LimeSurvey/LimeSurvey.git ./webroot
    ( cd webroot && git checkout develop && cd .. )
    cp $CURRENT_PATH/.prepare/config.php $CURRENT_PATH/webroot/application/config/config.php
fi
# update the repository
echo  "(Updating limsurvey ...)"
( cd webroot && git pull --force && cd .. )

#copiyng necessary files and folders
echo  "(Copying files and folders ...)"
 cp -R $CURRENT_PATH/.provision $CURRENT_PATH/webroot/ 