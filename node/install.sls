{%- set node_version = salt['pillar.get']('node:version', 'latest') %}

nodejs:
  pkg.installed

npm:
  pkg.installed

{%- if node_version != 'latest' %}
# Downgrade versie waar nodig
change_nodejs_version:
  cmd.run:
    - name: 'sudo n {{ node_version }}'
    - unless: "node --version | grep ^v{{ node_version }}$"
    - require:
      - pkg: npm
{%- endif %}
