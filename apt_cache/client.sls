/etc/apt/apt.conf.d/10proxy:
    file.managed:
      - source: salt://apt_cache/apt.conf
      - template: jinja
      - defaults:
            upstream: support.private.vm.habhub.org
      - mode: 644
      - user: root
      - group: root
      - order: 11
