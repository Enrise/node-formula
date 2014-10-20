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

# Upgrade nodejs to the latest stable release using "n".
upgrade-nodejs:
  cmd.run:
    - name: 'sudo npm install -g n && sudo n stable'
    - require:
      - cmd: set-registry

# And symlink /usr/bin/node to /usr/local/bin/node
fix-node-binary:
  cmd.run:
    - name: 'sudo rm -f /usr/bin/node && sudo ln -s /usr/local/bin/node /usr/bin/node'
    - require:
      - cmd: set-registry

{% if 'install_dirs' in salt['pillar.get']('node:npm', {}) %}
{% for install_dir in salt['pillar.get']('node:npm:install_dirs', {}) %}
node-install-{{ install_dir }}: # This is only here for a unique name.
  cmd.run:
    - name: 'npm install'
    - cwd: {{ install_dir }}
    - unless: test -d {{ install_dir }}/node_modules
{% endfor %}
{% endif %}
