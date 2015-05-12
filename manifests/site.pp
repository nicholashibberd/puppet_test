import 'user'

class { user::accounts:
  sudo_users => ['nicholashibberd'],
  admin_users => ['daniellehibberd'],
  non_admin_users => ['peterhibberd']
}
