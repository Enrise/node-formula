{%- set os = salt['grains.get']('os') %}
{% if os == 'Ubuntu' %}
# Configure PPA (if on Ubuntu) to provide a more up-to-date release of Node and NPM
nodejs_ppa:
  pkgrepo.managed:
    - ppa: chris-lea/node.js
    - refresh: True
    - require_in:
      - pkg: install-nodejs
      - pkg: install-npm
{% endif %}

# Install node base package.
install-nodejs:
  pkg.installed:
    - name: nodejs

# Install npm as well.
install-npm:
  pkg.installed:
    - name: npm
  require:
    - pkg: install-nodejs

# Set a registry for npm.
set-registry:
  cmd.run:
    - name: 'sudo npm config set registry http://registry.npmjs.org'
    - unless: 'sudo npm config get registry | grep registry.npmjs.org'

{% if os != 'Ubuntu' %}
# Upgrade nodejs to the latest stable release using "n".
upgrade-nodejs:
  cmd.run:
    - name: 'sudo npm install -g n && sudo n stable'
    - require:
      - cmd: set-registry
{% endif %}

# Install alternative to provide Node at a more logical location
alternative-nodejs:
  alternatives.install:
    - name: /usr/bin/node
    - link: /usr/local/bin/node
    - priority: 1
    - require:
      - pkg: install-nodejs

{% if 'install_dirs' in salt['pillar.get']('node:npm', {}) %}
{% for install_dir in salt['pillar.get']('node:npm:install_dirs', {}) %}
node-install-{{ install_dir }}: # This is only here for a unique name.
  cmd.run:
    - name: 'npm install'
    - cwd: {{ install_dir }}
    - unless: test -d {{ install_dir }}/node_modules
{% endfor %}
{% endif %}
