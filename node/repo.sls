{%- set lsb_codename = salt['grains.get']('lsb_distrib_codename') %}
{%- set os = salt['grains.get']('os') %}
{%- set os_family = salt['grains.get']('os_family') %}

# Install Node repository
nodejs_repo:
  pkgrepo.managed:
    - humanname: Node.js Repo
    - key_url: https://deb.nodesource.com/gpgkey/nodesource.gpg.key
    - name: deb https://deb.nodesource.com/node {{ lsb_codename }} main
    - dist: {{ lsb_codename }}
    - file: /etc/apt/sources.list.d/nodesource.list
    - refresh: True
    - require_in:
      - pkg: nodejs


# todo: Deal with RPM repo's
