# NPM acties
{% for install_dir in salt['pillar.get']('node:npm:install_dirs', {}) %}
npm_install_{{ install_dir }}:
  cmd.run:
    - name: 'npm install'
    - cwd: {{ install_dir }}
    - unless: test -d {{ install_dir }}/node_modules
{% endfor %}
