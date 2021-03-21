% RUNMIRRORS(1)
% Debian mirror team
% ftpsync Manual

# NAME
runmirrors - Trigger downstream mirrors

# SYNOPSIS
**runmirrors**

# DESCRIPTION

**runmirrors** is part of the ftpsync suite for mirroring Debian and Debian-like
repositories of packages.  As there are way too many mirrors of Debian to populate
them all from the machine that generates the archive ("ftp-master"), mirrors are
organized in a tree-shaped hierarchy.  Thus, every mirror has exactly one upstream
from which it syncs, and each mirror can have any number of downstreams which in
turn sync from it.

# SEE ALSO
**ftpsync**(1), **runmirrors.conf**(5), **runmirrors.mirror**(5)
