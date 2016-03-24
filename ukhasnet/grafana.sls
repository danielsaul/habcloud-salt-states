include:
  - backups

grafana:
  pkgrepo.managed:
    - name: deb https://packagecloud.io/grafana/stable/debian/ wheezy main
    - file: /etc/apt/sources.list.d/grafana.list
    - key_url: https://packagecloud.io/gpg.key
  pkg.installed: []
  service.running:
    - name: grafana-server
    - reload: true
    - enable: true
    - watch:
      - file: /etc/grafana/grafana.ini

/etc/grafana/grafana.ini:
  file.managed:
    - source: salt://ukhasnet/grafana.ini
    - user: root
    - group: grafana
    - mode: 640
    - template: jinja
    - show_diff: false

# TODO: Add Grafana database backups
# {% from "backups/macros.jinja" import backup %}
# {{ backup("ukhasnet-grafana", "username", "cmd") }}
