# configures an ubuntu server using puppet as follows:
#	- apt-get update
#	- apt-get install nginx
#	- set X-Served-By -> $HOSTNAME
#	- service restart
exec { 'sudo apt-get update':
  command => 'sudo apt-get update',
  before  => Package['nginx']
}

package { 'nginx':
  ensure => 'installed',
  before => Exec['X-Served-By']
}

exec { 'X-Served-By':
  command => 'sed -i "/server_name _;/ a\\\tadd_header X-Served-By \"\$HOSTNAME\";" /etc/nginx/sites-available/default',
  before  => Exec['restart']
}

exec { 'restart':
  command => 'sudo service nginx restart'
}
