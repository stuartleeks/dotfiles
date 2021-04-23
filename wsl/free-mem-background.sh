#!/bin/bash
interval_between_drops=10m

while true; 
do 
    echo -e "dropping cache ... $(date)\n\nBefore:" > ~/drop_cache_status
    free -h >> ~/drop_cache_status
    echo "" >> ~/drop_cache_status

    wsl.exe --distribution "$WSL_DISTRO_NAME"  --user root bash -c "sync && echo 1 | sudo tee /proc/sys/vm/drop_caches" >> ~/drop_cache_status 2>&1
    
    echo -e "\nAfter:" >> ~/drop_cache_status
    free -h >> ~/drop_cache_status

    echo -e "\n\nSleeping for $interval_between_drops..." >> ~/drop_cache_status
    sleep $interval_between_drops
done