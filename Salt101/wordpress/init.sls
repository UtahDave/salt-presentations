apache2:
  pkg:
    - installed
  service:
    - running
    - enable: True
    - watch:
      - pkg: wp-pkgs

wp-pkgs:
  pkg.installed:
    - pkgs:
      - php5 
      - php5-mysql
      - python-mysqldb
    - require:
      - pkg: mysqlserver
      - pkg: apache2

mysqlserver:
  pkg.installed:
    - pkgs:
      - mysql-server
      - mysql-client
      - python-mysqldb

wordpressuser:
  mysql_user.present:
    - host: localhost
    - password: crappypassword
    - require:
      - pkg: mysqlserver

wordpress:
  mysql_database.present:
    - require:
      - pkg: mysqlserver

wordpress_db:
  mysql_grants.present:
    - grant: all privileges
    - database: wordpress.*
    - user: wordpressuser
    - require:
      - mysql_database: wordpress
      - mysql_user: wordpressuser

/var/www:
  file.recurse:
    - source: salt://wordpress/wordpress
    - clean: True
    - user: www-data
    - group: www-data
    - dir_mode: 755
    - file_mod: 644
    - include_empty: True
