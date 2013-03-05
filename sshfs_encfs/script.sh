#!/bin/bash

# decalre variables
REMOTEHOST=specter@erebus.feralhosting.com
REMOTEPATH=:/media/sdp1/home/specter/vania-backup
LOCALPATH=/mnt/vania-backup/sshfs/ # notice trailing slash
CLEANPATH=/mnt/vania-backup/encfs
# 0. Check if root
if [ `id -u` != 0 ]; then { echo "Sorry, must be root.  Exiting..."; exit; } fi

# mount remote folder
#sshfs $REMOTEHOST$REMOTEPATH $LOCALPATH -o workaround=rename #,uid=1000 # optional workarounf if non-root

# check for successful mount

# decrypt encfs
#encfs $LOCALPATH $CLEANPATH

echo "$CLEANPATH is mounted and ready, start rsync."

## Rsync Part ##
# temporarily copy pasted in
MOUNT_POINT=$CLEANPATH
SRCPATH=/home/vania/Downloads # what you are backing up - DO NOT INCLUDE TRAILING SLASH

RSYNC_OPT="-ah --delete"

# date variables
LAST_MONTH_NAME=`date +'%B' -d "1 week ago"` # month name of one week ago
THIS_MONTH_NAME=`date +'%B'` # month name of current month
LAST_MONDAY=`date -I -d "1 week ago"` # last monday in iso format
TWO_MONDAYS_AGO=`date -I -d "2 week ago"` # 2 mondays ago in iso format
TWO_MONTHS_AGO_NAME=`date +%B -d "2 months ago"`
TODAY=`date -I` # today's date in iso format'
YESTERDAY=`date -I -d "1 day ago"`
WEEKDAY=`date +'%w'`


# 0.5 WELCOME
echo "Welcome! Today is $TODAY"


# 3. Copy data for weekly and monthly purposes
if [ "$WEEKDAY" == 1 ] # if today is a monday, copy last monday to weekly
then 
    # if linkdest DNE, just copy files. else use rsync
    if [ ! -d "$MOUNT_POINT/Weekly/$TWO_MONDAYS_AGO" ]
    then
        echo "No backup for 2 weeks ago, copying last monday to weekly w/o rsync"
        rsync -ah $MOUNT_POINT/Daily/$LAST_MONDAY/ $MOUNT_POINT/Weekly/$LAST_MONDAY
        echo "copied Daily/$LAST_MONDAY to Weekly/$LAST_MONDAY"
        
    else # linkdest exists, copy using rsync
        echo "2 week backup exists, copying using rsync"
        rsync -ah --delete --link-dest=$MOUNT_POINT/Weekly/$TWO_MONDAYS_AGO $SRCPATH/ $MOUNT_POINT/Weekly/$LAST_MONDAY
        echo "copied Daily/$LAST_MONDAY to Weekly/$LAST_MONDAY"
    fi # end weekly linkdest check
    
    
    ## start monthly work
    if [ $THIS_MONTH_NAME != $LAST_MONTH_NAME ]
    then
        echo "Last week was in a different month, so copying to monthly"
        
        # check for monthly linkdest
        if [ ! -d "$MOUNT_POINT/Monthly/$TWO_MONTHS_AGO_NAME" ]
        then
            echo "No linkdest exists for 2 months ago, copying w/o rsync"
            rsync -ah $MOUNT_POINT/Daily/$LAST_MONDAY/ $MOUNT_POINT/Monthly/$LAST_MONTH_NAME
            echo "copied Daily/$LAST_MONDAY to Monthly/$LAST_MONTH_NAME"
        
        # link dest exists, copy with rsync
        else
            rsync -ah --delete --link-dest=$MOUNT_POINT/Monthly/$TWO_MONTHS_AGO_NAME $SRCPATH/ $MOUNT_POINT/Monthly/$LAST_MONTH_NAME
            echo "copied Daily/$LAST_MONDAY to Monthly/$LAST_MONTH_NAME"
        fi # end monthly linkdest test
    fi #end monthly check
    
fi # end all weekly and monthly checks

# 4 backup today's data to Daily
# check for yesterday's linkdest
if [ ! -d "$MOUNT_POINT/Daily/$YESTERDAY" ]
    then
    echo "No linkdest exists for yesterday, copying w/o rsync"
    rsync -ah $SRCPATH/ $MOUNT_POINT/Daily/$TODAY
    echo "copied $SRCPATH to Daily/$TODAY"

# link dest exists, copy with rsync
else
    rsync -ah --delete --link-dest=$MOUNT_POINT/Daily/$YESTERDAY $SRCPATH/ $MOUNT_POINT/Daily/$TODAY
    echo "copied $SRCPATH to Daily/$TODAY"
fi # end monthly linkdest test



