include:
  - .common

/etc/exim4/exim4.conf:
    file.managed:
      - source: salt://exim/satellite.conf
      - template: jinja
      - defaults:
            upstream: support.private.vm.habhub.org
      - mode: 644 
      - user: root
      - group: root
      - require:
          - pkg: exim4-daemon-light

/etc/aliases:
    file.absent
