# `trombik.portshaker`

`ansible` role for `portshaker`.

# Requirements

None

# Role Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `portshaker_user` | user name of owner of ports trees | `""` |
| `portshaker_group` | group name of `portshaker_user` | `""` |
| `portshaker_package` | package name of `portshaker` | `portshaker` |
| `portshaker_conf_dir` | basedir of `portshaker_conf_file` | `/usr/local/etc` |
| `portshaker_conf_file` | path to `portshaker.conf` | `{{ portshaker_conf_dir }}/portshaker.conf` |
| `portshaker_conf_d_dir` | path to `portshaker.d` | `/usr/local/etc/portshaker.d` |
| `portshaker_mirror_base_dir` | path to `mirror_base_dir` | `/var/cache/portshaker` |
| `portshaker_portsnap_dir` | path to `portsnap` cache directory | `/var/db/portsnap` |
| `portshaker_ports_trees` | see below | `[]` |
| `portshaker_config` | content of `portshaker.conf` | `""` |
| `portshaker_extra_packages` | list of extra packages to install | `["ports-mgmt/portshaker-config", "git"]` |

## `portshaker_ports_trees`

This is a list of dict.

| Key | Description | Mandatory? |
|-----|-------------|------------|
| `name` | name of the ports tree | no |
| `file` | a dict of arguments for `file` `ansible` module | yes |

`file` key must have `path` that points to the path of the ports tree.

# Dependencies

None

# Example Playbook

```yaml
---
- hosts: localhost
  roles:
    - role: ansible-role-portshaker
  pre_tasks:
    - name: Create portshaker group
      group:
        name: portshaker
        state: present

    - name: Create portshaker user
      user:
        name: portshaker
        comment: portshaker user
        create_home: no
        group: portshaker
        home: /var/empty
        shell: /usr/sbin/nologin
        state: present
  vars:
    portshaker_user: portshaker
    portshaker_group: portshaker

    portshaker_ports_trees:
      - name: default
        file:
          path: /usr/local/poudriere/ports/default
          state: directory
          owner: "{{ portshaker_user }}"
          group: "{{ portshaker_group }}"

    portshaker_config: |
      mirror_base_dir="{{ portshaker_mirror_base_dir }}"
      ports_trees="default"
      default_ports_tree="{{ portshaker_ports_trees[0].file.path }}"
      default_merge_from="ports github:trombik:freebsd-ports-sensu-go:devel"
```

# License

```
Copyright (c) 2020 Tomoyuki Sakurai <y@trombik.org>

Permission to use, copy, modify, and distribute this software for any
purpose with or without fee is hereby granted, provided that the above
copyright notice and this permission notice appear in all copies.

THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
```

# Author Information

Tomoyuki Sakurai <y@trombik.org>

This README was created by [qansible](https://github.com/trombik/qansible)
