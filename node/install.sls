{%- set node_version = salt['pillar.get']('node:version', 'latest') %}

nodejs:
  pkg.installed

{%- if node_version != 'latest' %}
# We'll need the "n" package for this
install_node_n:
  cmd.run:
    - name: npm install -g n
    - unless: hash n 2>/dev/null
    - require:
      - pkg: nodejs

# Downgrade to given version
change_nodejs_version:
  cmd.run:
    - name: 'sudo n {{ node_version }}'
    - unless: "node --version | grep ^v{{ node_version }}$"
    - require:
      - cmd: install_node_n
{%- endif %}
