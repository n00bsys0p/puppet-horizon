# horizon

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with horizon](#setup)
    * [What horizon affects](#what-horizon-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with horizon](#beginning-with-horizon)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Overview

The Horizon module provides a way to easily manage a production instance of the
[Horizon cryptocurrency client.](https://horizonplatform.io). It handles
uptime assurance and security via user and process management.

## Setup

### What horizon affects

* Installs:
  * unzip
  * pip
  * supervisord
  * Java Runtime Environment
* Creates:
  * Data directory /var/lib/horizon (or the service user's name)
  * Supervisord program called "horizon" (or the selected service name)

### Beginning with horizon

To get started, install this module with:

```bash
puppet module install n00bsys0p-horizon
```

Once you've got it installed, you can just use include ::horizon to use the
default settings, or use the class syntax to specify changes like so:

```puppet
class { 'horizon':
  $client_version => '3.9.2',
  $user           => 'hz'
  $group          => 'hz',
  $service_name   => 'hzclient'
  $server_opts    => {
    'nhz.peerServerPort' => '7879',
    'nhz.myHallmark'     => 'deadbeefcafe'
  }
}
```

## Reference

### Classes

#### horizon

This is the class you will most likely be using to implement the module.

It takes the following parameters:

* $client_version
  * The version of the Horizon client to install and run. Defaults to 4.0e.
* $user
  * The user under which to install the Horizon node.
* $group
  * The group under which to install the Horizon node.
* $service_name
  * The name of the supervisord 'program' to configure.
* $server_opts
  * A hash of options to write to the Horizon configuration file.

#### horizon::configure

Installs prerequisites - Java JRE, unzip; sets up the service user's home
folder and software deployment folders under /var/lib.

No parameters.

#### horizon::service

Installs supervisord, pip and the Horizon supervisord program.

No parameters.

### Defined Types

#### horizon::client

Downloads and installs a copy of the Horizon client you want to run.

The client software is installed under /var/lib/$::horizon::user/releases.

The one you've set to $current => true will be symlinked to
/var/lib/$::horizon::user/current

The horizon::client's $title should be set to the version of the Horizon client
you want to install. The version should not include the 'v' prefix.

Takes the following parameters:

* $ensure
  * 'absent' will delete the stated version's data directory. Defaults to
    'installed'.
* $user
  * The system user's name. Defaults to 'horizon'.
* $package_suffix
  * The Horizon package suffix defines the type of wallet you want to download.
    Defaults to '-node', as 99% or more of the time that's the one you're
    looking for in a remote server context.
* $current
  * Whether this client is the currently enabled one. If true, this creates a
    symlink from /var/lib/releases/$::horizon::user to
    /var/lib/$::horizon::user/current. Defaults to true.
* $server_opts
  * A hash of the options to set in the Horizon node configuration file.

## Limitations

Currently tested on CentOS 6

If you set multiple client versions as current, the results may be
unpredictable, as whichever client gets handled last will be the one that ends
up running.

## Development

Developers work in their own trees, then submit pull requests when they think
their feature or bug fix is ready.
