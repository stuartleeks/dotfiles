from ..gh_auth import parse_org_settings


def test_org_settings_empty_input():
    assert parse_org_settings("") == {}


def test_org_settings_single_item():
    assert parse_org_settings("org1|user1") == {"org1": "user1"}

def test_org_settings_single_item_with_traling_separator():
    assert parse_org_settings("org1|user1;") == {"org1": "user1"}

def test_org_settings_multiple_items():
    assert parse_org_settings("org1|user1;org2|user2") == {"org1": "user1", "org2": "user2"}