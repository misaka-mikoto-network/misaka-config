% FTPSYNC(1)
% Debian mirror team
% ftpsync Manual

# NAME
ftpsync - Mirror Debian and Debian-like repositories of packages

# SYNOPSIS
**ftpsync** [_OPTION_]... [_SYNC-FLAG_]...

# DESCRIPTION

**ftpsync** is part of the ftpsync suite for mirroring Debian and Debian-like
repositories of packages.  As there are way too many mirrors of Debian to populate
them all from the machine that generates the archive ("ftp-master"), mirrors are
organized in a tree-shaped hierarchy.  Thus, every mirror has exactly one upstream
from which it syncs, and each mirror can have any number of downstreams which in
turn sync from it.

# SYNC FLAGS

Sync flags can be specified on the command-line or via a ssh forced command from the remote side.

**sync:archive:_foo_**
: Select archive _foo_ for syncing.  A config needs to be available.

**sync:all**
: Do a complete sync.

**sync:stage1**
: Only do a stage 1 sync.

**sync:stage2**
: Only do a stage 2 sync.

**sync:mhop**
: Do a special multi-hop sync, usually additionally to stage 1.

**sync:callback**
: Call back when done.

# OPTIONS

**-T**
:   Information about the used trigger.

    If undefined the following values are automatically set:

    - **ssh** if called from a ssh forced command.
    - **cron** if called via **ftpsyn-cron**(1).

# SEE ALSO
**ftpsync.conf**(5) +
