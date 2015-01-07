{% set users = pillar["auth"]["users"] %}
{% set groups = pillar["auth"]["groups"][grains.id] %}
{% set sudoers = groups["sudo"] %}
{% set normal_users = groups["users"] %}

{% for user, data in users.items() if user in sudoers + normal_users %}
user-{{ user }}:
    group.present:
      - name: {{ user }}
      - gid: {{ data.uid }}
      - system: False
    user.present:
      - name: {{ user }}
      - password: "!"
      - home: /home/{{ user }}
      - shell: /bin/bash
      - uid: {{ data.uid }}
      - gid_from_name: True
      - fullname: {{ data.fullname }}
      - remove_groups: False
      - require:
          - group: {{ user }}
    file.managed:
      - name: /home/{{ user }}/.ssh/authorized_keys
      - mode: 600
      - user: {{ user }}
      - group: {{ user }}
      - contents_pillar: auth:users:{{ user }}:ssh_keys
      - makedirs: true
      - dir_mode: 700
      - require:
          - user: {{ user }}
{% endfor %}

{% for user in users.keys() if user not in sudoers + normal_users %}
remove-user-{{ user }}:
    user.absent:
        - name: {{ user }}
        - force: true
        - purge: false
{% endfor %}

{% for group, members in groups.items() %}
group-{{ group }}:
    group.present:
        - name: {{ group }}
        - system: {{ "true" if group in ("sudo", "users") else "false" }}
        - members:
          {% for member in members %}
            - {{ member }}
          {% endfor %}
          {% if group == "users" %}
          {% for member in sudoers %}
            - {{ member }}
          {% endfor %}
          {% endif %}
{% endfor %}

root:
    user.present:
      - password: "!"

sudo:
    pkg:
      - installed

/etc/sudoers:
    file.managed:
      - source: salt://auth/sudoers
      - mode: 440
      - user: root
      - group: root
      - require:
          - pkg: sudo
