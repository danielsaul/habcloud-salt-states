php5-fpm:
    pkg.installed:
        - names:
            - php5-cli
            - php5-fpm
    service.running:
        - name: php5-fpm
        - reload: true
        - enable: true
        - watch:
            - pkg: php5-fpm
            - file: /etc/php5/conf.d/cgi-fix-pathinfo.conf

/etc/php5/conf.d/cgi-fix-pathinfo.conf:
    file.managed:
        - source: salt://nginx/cgi-fix-pathinfo.conf
        - require:
            - pkg: php5-fpm

/etc/php5/fpm/pool.d/www.conf:
    file.absent