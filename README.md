####Table of Contents

1. [Overview](#overview)
2. [Setup - The basics of getting started with robottelo slave](#setup)
    * [What robottelo slave affects](#what-robottelo_slave-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with robottelo slave](#beginning-with-robottelo_slave)
    * [Installing for Satellite builds](#installing-for-Satellite-builds)
3. [Usage - Configuration options and additional functionality](#usage)
4. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

##Overview

This module is designed to setup a Jenkins slave configured to run jobs provided through the
robottelo-ci repository. This relies on puppet modules from [foreman-infra](https://github.com/theforeman/foreman-infra.git) 
to properly configure a slave with the main entry point from the foreman-infra repository
being the `slave` module located at `puppet/modules/slave`.

##Setup

###What robottelo slave affects

* Installs and configures a slave for use in Jenkins

###Beginning with robottelo slave

On a box that you intend to use as a slave for running robottelo-ci jobs, first configure
the slave following the normal Jenkins steps. After the box has been registered in Jenkins
as a slave, copy the git repository containg robottelo slave and run the `apply.sh` script.
This script will handle acquiring all the dependencies and then applying the puppet configuration.

```
git clone https://github.com/SatelliteQE/puppet-robottelo_slave.git
cd puppet-robottelo_slave
./apply.sh
```

###Installing for Satellite builds

To enable the slave box to be configured to perforem Satellite 6 builds (Which
require connectivity to Brew) you can run the `apply.sh` script as follows:

```
./apply.sh --satellite6
```

##Development

See the CONTRIBUTING guide for steps on how to make a change and get it accepted upstream.
