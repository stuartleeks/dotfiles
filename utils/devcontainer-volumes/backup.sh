#!/bin/bash
set -e

script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# docker volume ls --format "{{.Name}}" | grep 'bashhistory'

mkdir -p volume_bak
echo '*' > volume_bak/.gitignore


# while read -r volume_name
# do
# 	docker volume ls --format "{{.Name}}" | grep 'bashhistory' 
# 	volume_name="tre-bashhistory"
# 	docker run --rm -v $script_dir/volume_bak:/backup -v $volume_name:/bhvolume ubuntu bash -c "cd /bhvolume && tar cvf /backup/$volume_name.tar ."
# done < <(docker volume ls --format "{{.Name}}" | grep 'bashhistory')



docker volume ls --format "{{.Name}}" | grep '.*-azure$' | while read volume_name
do
	echo "Backing up $volume_name"
	docker run --rm -v $script_dir/volume_bak:/backup -v $volume_name:/bhvolume ubuntu bash -c "cd /bhvolume && tar cvf /backup/$volume_name.tar . > /dev/null"
done

docker volume ls --format "{{.Name}}" | grep '.*-shellhistory$' | while read volume_name
do
	echo "Backing up $volume_name"
	docker run --rm -v $script_dir/volume_bak:/backup -v $volume_name:/bhvolume ubuntu bash -c "cd /bhvolume && tar cvf /backup/$volume_name.tar . > /dev/null"
done
