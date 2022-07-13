from thefuck.types import Command

RE_AUTH_TEXT = "To re-authenticate, please run:\n"


def match(command: Command):
    return RE_AUTH_TEXT in command.output


def get_new_command(command: Command):
    re_auth_index = command.output.find(RE_AUTH_TEXT)
    command_start_index = re_auth_index + len(RE_AUTH_TEXT)
    command_end_index = command.output.find("\n", command_start_index)
    re_auth_command = command.output[command_start_index:command_end_index]
    return re_auth_command
