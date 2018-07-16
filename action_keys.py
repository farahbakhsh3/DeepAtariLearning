class Action_Keys():
    def __init__(self, game_name):
        self.game_name = game_name

    def action_keys_Convert(self, key):
        if self.game_name == 'Enduro':
            return action_keys_Convert_Enduro(key)
        
        elif self.game_name == 'SpaceInvaders':
            return action_keys_Convert_SpaceInvaders(key)
        
        else:
            return key

    def action_keys_text(self, key):
        if self.game_name == 'Enduro':
            return action_keys_text_Enduro(key)
        
        elif self.game_name == 'SpaceInvaders':
            return action_keys_text_SpaceInvaders(key)
        
        else:
            return action_keys_text(key)


def action_keys_Convert_Enduro(key):
    if key == '0':
        newkey = '0'
    elif key == '1':
        newkey = '1'
    elif key == '2':
        newkey = '1'
    elif key == '3':
        newkey = '2'
    elif key == '4':
        newkey = '3'
    elif key == '5':
        newkey = '4'
    elif key == '6':
        newkey = '2'
    elif key == '7':
        newkey = '3'
    elif key == '8':
        newkey = '5'
    elif key == '9':
        newkey = '6'
    elif key == '10':
        newkey = '1'
    elif key == '11':
        newkey = '7'
    elif key == '12':
        newkey = '8'
    elif key == '13':
        newkey = '4'
    elif key == '14':
        newkey = '7'
    elif key == '14':
        newkey = '8'
    elif key == '16':
        newkey = '5'
    elif key == '17':
        newkey = '6'
    else:
        newkey = '0'

    return newkey


def action_keys_Convert_SpaceInvaders(key):
    if key == '0':
        newkey = '0'
    elif key == '1':
        newkey = '1'
    elif key == '2':
        newkey = '0'
    elif key == '3':
        newkey = '1'
    elif key == '4':
        newkey = '2'
    elif key == '5':
        newkey = '0'
    elif key == '6':
        newkey = '0'
    elif key == '7':
        newkey = '0'
    elif key == '8':
        newkey = '0'
    elif key == '9':
        newkey = '0'
    elif key == '10':
        newkey = '0'
    elif key == '11':
        newkey = '4'
    elif key == '12':
        newkey = '5'
    elif key == '13':
        newkey = '0'
    elif key == '14':
        newkey = '0'
    elif key == '14':
        newkey = '0'
    elif key == '16':
        newkey = '0'
    elif key == '17':
        newkey = '0'
    else:
        newkey = '0'

    return newkey


def action_keys_text(key):
    if key == '0':
        key_text = 'Noop            :'
    elif key == '1':
        key_text = 'Fire            :'
    elif key == '2':
        key_text = 'Up              :'
    elif key == '3':
        key_text = 'Right           :'
    elif key == '4':
        key_text = 'Left            :'
    elif key == '5':
        key_text = 'Down            :'
    elif key == '6':
        key_text = 'Up-Right        :'
    elif key == '7':
        key_text = 'Up-Left         :'
    elif key == '8':
        key_text = 'Down-Right      :'
    elif key == '9':
        key_text = 'Down-Left       :'
    elif key == '10':
        key_text = 'Up-Fire         :'
    elif key == '11':
        key_text = 'Right-Fire      :'
    elif key == '12':
        key_text = 'Left-Fire       :'
    elif key == '13':
        key_text = 'Down-Fire       :'
    elif key == '14':
        key_text = 'Up-Right-Fire   :'
    elif key == '14':
        key_text = 'Up-Left-Fire    :'
    elif key == '16':
        key_text = 'Down-Right-Fire :'
    elif key == '17':
        key_text = 'Down-Left-Fire  :'
    else:
        key_text = 'Unknown          '

    return key + ': ' + key_text


def action_keys_text_Enduro(key):
    if key == '0':
        key_text = 'Noop       :'
    elif key == '1':
        key_text = 'Fire       :'
    elif key == '2':
        key_text = 'Right      :'
    elif key == '3':
        key_text = 'Left       :'
    elif key == '4':
        key_text = 'Down       :'
    elif key == '5':
        key_text = 'Down-Right :'
    elif key == '6':
        key_text = 'Down-Left  :'
    elif key == '7':
        key_text = 'Right-Fire :'
    elif key == '8':
        key_text = 'Left-Fire  :'
    else:
        key_text = 'Unknown    :'

    return key + ': ' + key_text


def action_keys_text_SpaceInvaders(key):
    if key == '0':
        key_text = 'Noop       :'
    elif key == '1':
        key_text = 'Fire       :'
    elif key == '2':
        key_text = 'Right      :'
    elif key == '3':
        key_text = 'Left       :'
    elif key == '4':
        key_text = 'Right-Fire :'
    elif key == '5':
        key_text = 'Left-Fire  :'
    else:
        key_text = 'Unknown    :'

    return key + ': ' + key_text
