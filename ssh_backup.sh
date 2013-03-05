
# login and moutn sshfs
sshfs specter@erebus.feralhosting.com:/media/sdp1/home/specter/vania-backup /mnt/vania-backup/sshfs/ -o workaround=rename



#decrypt data
encfs /mnt/vania-backup/sshfs /mnt/vania-backup/encfs



# backup
# rdiff-backup --no-hard-links /important/research/ /mnt/encfsmount/
