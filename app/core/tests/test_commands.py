from unittest.mock import patch

from django.core.management import call_command
from django.db.utils import OperationalError
from django.test import TestCase

# Testing a custom command that waits for db:
# https://stackoverflow.com/questions/52621819/django-unit-test-wait-for-database
# Django source code:
# https://github.com/django/django/blob/11b8c30b9e02ef6ecb996ad3280979dfeab700fa/django/db/utils.py#L195
# call_command:
# https://docs.djangoproject.com/en/3.1/ref/django-admin/#django.core.management.call_command


GET_ITEM_QUALIFIED_NAME = 'django.db.utils.ConnectionHandler.__getitem__'


class CommandTests(TestCase):

    def test_wait_for_db_ready(self):
        """Test waiting for db when db is available"""
        with patch(GET_ITEM_QUALIFIED_NAME) as gi:
            gi.return_value = True
            call_command('wait_for_db')
            self.assertEqual(gi.call_count, 1)

    # simulate w/o actually sleeping
    @patch('time.sleep', return_value=True)
    def test_wait_for_db(self, ts):
        """Test waiting for db"""
        with patch(GET_ITEM_QUALIFIED_NAME) as gi:
            gi.side_effect = [OperationalError] * 5 + [True]
            call_command('wait_for_db')
            self.assertEqual(gi.call_count, 6)
