% FTPSYNC-CRON(1)
% Debian mirror team
% ftpsync Manual

# NAME
ftpsync-cron - Wrapper around ftpsync for use in cron(8)

# SYNOPSIS
**ftpsync-cron** [_ARCHIVE_]

# DESCRIPTION

**ftpsync-cron** is part of the ftpsync suite for mirroring Debian and Debian-like
repositories of packages.  As there are way too many mirrors of Debian to populate
them all from the machine that generates the archive ("ftp-master"), mirrors are
organized in a tree-shaped hierarchy.  Thus, every mirror has exactly one upstream
from which it syncs, and each mirror can have any number of downstreams which in
turn sync from it.

**ftpsync-cron** is a wrapper around **ftpsync** itself, intended to be run out
of cron at regular, frequent intervals, such as hourly.  When started, it reads
the corresponding **ftpsync.conf** configuration file for the archive in
question and determines this mirror's upstream.  It then fetches the upstream's
trace file via HTTP and compares it to the version on disk from the last mirror
run, thus learning whether the upstream mirror has updated.  If it has,
**ftpsync** is triggered.

# EXAMPLE

Example use in a user crontab:

  SHELL=/bin/bash
  31 * * * * sleep $(( RANDOM %% 1800 )) && ./bin/ftpsync-cron

# SEE ALSO
**ftpsync**(1) +
