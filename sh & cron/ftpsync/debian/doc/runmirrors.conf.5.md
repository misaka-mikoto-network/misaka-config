% RUNMIRRORS.CONF(5)
% Debian mirror team
% ftpsync Manual

# NAME
runmirrors.conf - Configuration for runmirrors

# DESCRIPTION

**ftpsync** is part of the ftpsync suite for mirroring Debian and Debian-like
repositories of packages.  As there are way too many mirrors of Debian to populate
them all from the machine that generates the archive ("ftp-master"), mirrors are
organized in a tree-shaped hierarchy.  Thus, every mirror has exactly one upstream
from which it syncs, and each mirror can have any number of downstreams which in
turn sync from it.

# OPTIONS

**MAILTO**
:    The script can send logs (or error messages) to a mail address.
     If this is unset it will default to the current user.

     Default: **$LOGNAME**

**KEYFILE**
:   Which ssh key to use?

    Default: **~/.ssh/pushmirror**

## Log options

**LOGDIR**
:   In which directory should logfiles end up.

    Default: **~/.local/log/ftpsync** in the package, **${BASEDIR}/log** otherwise

**LOG**
:   Name of our own logfile.

    Note that ${NAME} is set by the ftpsync script depending on the way it
    is called. See README for a description of the multi-archive capability
    and better always include ${NAME} in this path.

    Default: **${LOGDIR}/${NAME}.log**

**LOGROTATE**
:   We do create a logfile for every run. To save space we rotate them, this
    defines how many we keep

    Default: **14**

## Other options

**LOCKDIR**
:   Our lockfile directory.

    Default: **~/.local/lock/ftpsync** in the package, **${BASEDIR}/locks** otherwise

**MIRRORS**
:   Our mirrorfile

    Default: **${CONFDIR}/${NAME}.mirror**

**SSH_OPTS**
:   Extra ssh options we might want. *hostwide*.
    By default, ignore ssh key change of leafs

    Default **"-o StrictHostKeyChecking=no"**

**PUSHARCHIVE**
:   Whats our archive name? We will also tell our leafs about it
    This is usually empty, but if we are called as "runmirrors bpo"
    it will default to bpo. This way one runmirrors script can serve
    multiple archives, similar to what ftpsync does.

**PUSHDELAY**
:   How long to wait for mirrors to do stage1 if we have multi-stage syncing

    Default: **600**

## Hooks

Hook scripts can be run at various places.

**HOOK1**
:   After reading config, before doing the first real action.

**HOOK2**
:   Between two hosts to push.

**HOOK3**
:   When everything is done.

# SEE ALSO
**runmirrors**(1)
