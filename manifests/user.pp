require 'stdlib'

class user {
  $user_data = {
    "nicholashibberd" => {
      "ssh_key"       => "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEApfXe2KSym90GVu3hSES+9bZMLAMIgDtJGtzc0LlF4ZdLhE8l9n3x0iloJToVpeb4NQmb+qzyaWQUfkLHvk0189P1ZfJgkkFjkmh50yjeKnbSaKjI1xjqxxNebgsWsJfRbEWPZPKK/3qYkl0Z/mQiBnMwS1/BOUaZJhSoOt906D5q1k0bHQi+F/c46NP4nyyD16/dkdpG3HT3KeM6FSqS897D1ORMyK6ksuJm1p1HECzGCpGAQnx9GM3meXeWvp95VMmYBLOnPXeskHB7rlPyhMHtuE0AwYTNzNOm23dg6TfnxzSoM656DM8/sD8e+79mpotsLPz6VriAS0hsPGP4Sw== nicholashibberd@gmail.com"
    },
    "peterhibberd" => {
      "ssh_key"       => "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCmrPZKe6lLmf1R0m+L8n5TJMcPVbapjetjxKiBAnDBB1m+wATGg2/wxPaB222ZuqeultUWHR5ZP3OznAVZiBpkm1axu5PU8QvUr+nV+XwFCyj/3O5WdKcTg84sRfIIcBUw7AKss6AzoNUGSVfQH4xLESPjAciJ0NBBrGs1IDwLbmy5ZalVZ/9CkUH4jd5lfE/g1x35HHn2N54mivgatkEpLieunBqYFDg4uiE1huNCSPj4WaPcJd2Evu1ix1NzHnizoWf8mvdO7QF/4AYQVd1izbaUPfgWZgkcLNP/nzpGFGM/nFoVqZXBPL5O5cKJGijHUkJRdijAl6m+k7nWfckh peterhibberd"
    },
    "daniellehibberd" => {
      "ssh_key"       => "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDDrO+0WBMFoFlGzm7L5ipP4s+CrO/VipYPHx2yfUpZdjXuhQ5/AopzG/OypuD3YqBWqvoOT+zpLTziDI4+pePOB+5e95K732HmAV5gFYwrhJWUo4qfTE/5qK4lIk5o0K1ypdnMeybJ8xvrjLAORydKJ7xVeNEVOtXFcPROtdGfXzM3PnmmeLGNar2wtKLcDSdFdu6pBle6K+oyy4kMLaJgbwGb92HFmKrIjkmOW+YGDfFSP1RnNKZtzr0HlJnyPNhtKQr0rk6h+hWzu2w85jr1bT9N10O4r7q2GoqQtIk2SC9E0c8yDSwymulClcMwD2lbxh230V6YXvSUjmy8GvnX daniellehibberd"
    }
  }

  $usernames = keys($user_data)
}

class user::accounts ($sudo_users, $admin_users, $non_admin_users) {
  user::account{ $sudo_users: sudo => true }
  user::account{ $admin_users: admin => true }
  user::account{ $non_admin_users }
}

define user::account ($sudo, $admin) {
  include user

  $ssh_key = $user::user_data[$name][ssh_key]

  if $sudo {
    $groups = ['sudo', 'adm']
  }
  elsif $admin {
    $groups = ['admin']
  } else {
    $groups = []
  }
  user { $name:
    home       => /home/$name,
    groups     => $groups,
    managehome => true,
    managehome => true,
    ensure     => present
  }

  file { "/home/${name}/.ssh/":
    ensure  => present,
    owner   => $name,
    group   => $name,
    require => User[$name]
  }

  file { "/home/${name}/.ssh/authorized_keys":
    ensure  => present,
    owner   => $name,
    group   => $name,
    mode    => 600,
    content => "${ssh_key}\n",
    require => File["/home/${name}.ssh/"]
  }
}
