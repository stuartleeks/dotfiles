#!/usr/bin/env python3
import sys

# https://docs.dapr.io/operations/monitoring/logging/logs/


def parse_line(line):
	# Split the following line into fields
	# time="2023-03-24T09:57:11.991301683Z" level=info msg="HTTP API Called" app_id=subscriber-dapr instance=subscriber-dapr-69bb66fcb-gzxqz method="GET /v1.0/healthz" scope=dapr.runtime.http-info type=log useragent=kube-probe/1.24 ver=edge

	context = 'field_name'
	field_name = ''
	field_value = ''
	field_value_quoted = False
	result = {
		'fields': {},
		'field_order': []
	}
	index = 0
	while index < len(line):
		char = line[index]
		if context == 'field_name':
			if char == '=':
				context = 'field_value'
				if line[index+1] == '"':
					field_value_quoted = True
					index += 1
			else:
				field_name += char
		elif context == 'field_value':
			if field_value_quoted:
				if char == '"':
					index += 1
					result['fields'][field_name] = '"' + field_value + '"'
					result['field_order'].append(field_name)
					context = 'field_name'
					field_value_quoted = False
					field_name = ''
					field_value = ''
				else:
					field_value += char
			else:
				if char == ' ':
					result['fields'][field_name] = field_value
					result['field_order'].append(field_name)
					
					context = 'field_name'
					field_name = ''
					field_value = ''
				else:
					field_value += char
		index += 1
	return result

COLOR_RED = "\033[0;31m"
COLOR_GRAY = "\033[1;30m"
COLOR_YELLOW = "\033[1;33m"
COLOR_WHITE = "\033[1;37m"
COLOR_RESET = "\033[0m"

# read lines from stdin
for line in sys.stdin:

	parsed_line = parse_line(line)
	# print(parsed_line)
	level = parsed_line['fields'].get('level')
	
	# Levels are error, warn, info, debug
	# Docs: https://docs.dapr.io/operations/troubleshooting/logs-troubleshooting/
	color = COLOR_WHITE # info/default
	if level == 'error':
		color = COLOR_RED
	if level == 'warn':
		color = COLOR_YELLOW
	elif level == 'debug':
		color = COLOR_GRAY
	print(color + line + COLOR_RESET, end='')
