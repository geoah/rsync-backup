cp -v website_bak.sh /etc/cron.daily/

# keep separate scripts for all rotations - based on cron
0 */4 * * * /usr/local/bin/make_snapshot.sh
0 13 * * *  /usr/local/bin/daily_snapshot_rotate.sh
