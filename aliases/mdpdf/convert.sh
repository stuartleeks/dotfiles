#!/bin/bash
set -e

script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# check that .venv exists
if [ ! -d "$script_dir/.venv" ]; then
	echo "Creating virtual environment for md to PDF conversion..."
	python3 -m venv $script_dir/.venv
	. $script_dir/.venv/bin/activate
	pip install weasyprint
else 
	. $script_dir/.venv/bin/activate
fi


echo $script_dir
echo "Converting $1 to ${1%.md}.pdf ..."
# use custom template for styling
# disable smart extension for markdown as that converts quotes and inserts non-breaking spaces which messes up the PDF layout
# TODO - update the styling for codeblocks in the template
pandoc -o "${1%.md}.pdf" -i "$1" --pdf-engine=weasyprint -V mainfont="Ubuntu Sans" -V papersize:a4 --template=$script_dir/template.html --metadata title="${1%}" --from markdown-smart
