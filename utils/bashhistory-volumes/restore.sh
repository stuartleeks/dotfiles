#!/bin/bash
set -e

script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"


ls volume_bak | while read backup_filename
do
	base_filename=$(basename --suffix .tar $backup_filename)
	echo "Restoring $base_filename"
	docker run --rm -v $script_dir/volume_bak:/backup -v ${base_filename}:/bhvolume ubuntu bash -c "cd /bhvolume && tar xvf /backup/$base_filename.tar > /dev/null"
done
