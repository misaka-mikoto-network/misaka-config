% FTPSYNC.CONF(5)
% Debian mirror team
% ftpsync Manual

# NAME
ftpsync.conf - Configuration for ftpsync

# DESCRIPTION

**ftpsync** is part of the ftpsync suite for mirroring Debian and Debian-like
repositories of packages.  As there are way too many mirrors of Debian to populate
them all from the machine that generates the archive ("ftp-master"), mirrors are
organized in a tree-shaped hierarchy.  Thus, every mirror has exactly one upstream
from which it syncs, and each mirror can have any number of downstreams which in
turn sync from it.

# OPTIONS

**MIRRORNAME**
:   Mirrorname. This is used for things like the trace file name and should
    always be the full hostname of the mirror.

    Default: **$(hostname -f)**

**TO**
:   Destination of the mirrored files. Should be an empty directory.  CAREFUL,
    this directory will contain the mirror. Everything else that might have
    happened to be in there WILL BE GONE after the mirror sync!

    Default: **/srv/mirrors/debian/**

**MAILTO**
:    The script can send logs (or error messages) to a mail address.
     If this is unset it will default to the current user.

     Default: **$LOGNAME**

**HUB**
:    Do we have leaf mirror to signal we are done and they should sync?
     If so set it to true and make sure you configure runmirrors.mirrors
     and runmirrors.conf for your need.

     Default: **false**

## Connection options

**RSYNC_HOST**
:   The host we mirror from.

**RSYNC_PATH**
:   The upstream name of the rsync share.

    You can find out what share names your upstream mirror supports by running
    rsync YOURUPSTREAMSERVER::
    (You might have to export RSYNC_USER/RSYNC_PASSWORD for this to work)

    Default: **debian**

**RSYNC_USER**
:   In case we need a user to access the rsync share at our upstream host

**RSYNC_PASSWORD**
:   If we need a user we also need a password

**RSYNC_TRANSPORT**
:   Set to select the transport used for rsync.

    **ssh**
    :   Use rsync daemon over SSH.
        This requires a **rsyncd.conf** on the server.
        Additional options for the ssh client should be configured in **ssh_config**.

    **ssl**
    :   Use rsync daemon over SSL.
        This requires a SSL wrapper (e.g. stunnel) for the rsync daemon on the server.
        See the other **RSYNC_SSL** options below.

**RSYNC_SSL_PORT**
:   Default: **1873**

**RSYNC_SSL_CAPATH**
:   Default: **/etc/ssl/certs**

**RSYNC_SSL_METHOD**
:    ftpsync can use either stunnel, stunnel-old, or socat to set up the
     encrypted tunnel.

     **stunnel**
     :   requires at least stunnel version 5.15 built aginst openssl
         1.0.2 or later such that the stunnel build supports the checkHost
         service-level option.  This will cause stunnel to verify both the
         peer certificate's validity and that it's actually for the host we wish
         to connect to.

      **stunnel-old**
      :   will skip the checkHost check.  As such it will connect
          to any peer that is able to present a valid certificate, regardless of
          which name it is made out to.

      **socat**
      :    will verify the peer certificate name only starting with version
           1.7.3 (Debian 9.0).

    To test if things work, you can run:

    **rsync -e 'bin/rsync-ssl-tunnel -m socat -p 1873 -C /etc/ssl/certs' SERVER::**

    Default: stunnel

**RSYNC_PROXY**
:   You may establish the connection via a web proxy by setting the environment
    variable **RSYNC_PROXY** to a hostname:port pair pointing to your web proxy.  Note
    that your web proxy's configuration must support proxy connections to port 873.

## Mirror information options

These options add informations about the mirror to a publicly accessible file.

**INFO_MAINTAINER**
:   Groups and people responsible for this mirror.  These contacts are
    used to report irregularities and problems with the mirror.  They
    must actually accept mail.

    Example: **INFO_MAINTAINER="Admins <admins@example.com>, Person <person@example.com>"**

**INFO_SPONSOR**
:   Organizations sponsoring this mirror.

    Example: **INFO_SPONSOR="Example <https://example.com>"**

**INFO_COUNTRY**
:   The ISO 3361-1 code of the country hosting this mirror.

    Example: **INFO_COUNTRY=DE**

**INFO_LOCATION**
:   The location this mirror is hosted in.

    Example: **INFO_LOCATION="Example"**

**INFO_THROUGHPUT**
:   Available throughput for this mirror per second.

    Example: **INFO_THROUGHPUT=10Gb**

## Include and exclude options

These options can be used to include or exclude specified architectures or other files from the mirror.

**Notice: the source architecture needs to be included on an official/public mirror!**

**ARCH_INCLUDE**
:   If you want to include only a subset of architectures, this is for you.
    Use as space seperated list of architectures in the archive you are
    mirroring from, "source" counts as architecture.

    Architecture "all" will be included automatically if one binary
    architecture is included.

    Mutually exclusive with **ARCH_EXCLUDE**.

    Example: **ARCH_INCLUDE="amd64 i386 source"**

**ARCH_EXCLUDE**
:   If you want to exclude an architecture, this is for you.
    Use as space seperated list of architectures in the archive you are
    mirroring from, "source" counts as architecture.

    Mutually exclusive with **ARCH_INCLUDE**.

    Example: **ARCH_EXCLUDE="alpha arm arm64 armel mipsel mips s390 sparc"**

**EXCLUDE**
:   If you do want to exclude files from the mirror run, put --exclude statements here.
    See rsync(1) for the exact syntax, these are passed to rsync as written here.
    DO NOT TRY TO EXCLUDE ARCHITECTURES OR SUITES WITH THIS, IT WILL NOT WORK!

## Log option

**LOGDIR**
:   In which directory should logfiles end up.

    Default: **~/.local/log/ftpsync** in the package, **${BASEDIR}/log** otherwise

**LOG**
:   Name of our own logfile.

    Note that ${NAME} is set by the ftpsync script depending on the way it
    is called. See README for a description of the multi-archive capability
    and better always include ${NAME} in this path.

    Default: **${LOGDIR}/${NAME}.log**

**ERRORSONLY**
:   If you do want a mail about every single sync, set this to false
    Everything else will only send mails if a mirror sync fails.

    Default: **true**

**FULLLOGS**
:   If you want the logs to also include output of rsync, set this to true.
    Careful, the logs can get pretty big, especially if it is the first mirror run.

    Default: **false**

**LOGROTATE**
:   We do create three logfiles for every run. To save space we rotate them, this
    defines how many we keep

    Default: **14**

## Other options

**LOCKTIMEOUT**
:   Timeout for the lockfile, in case we have bash older than v4 (and no /proc)

    Default: **3600**

**UIPSLEEP**
:   Number of seconds to sleep before retrying to sync whenever upstream
    is found to be updating while our update is running

    Default: **1200**

**UIPRETRIES**
:   Number of times the update operation will be retried when upstream
    is found to be updating while our update is running.
    Note that these are retries, so: 1st attempt + retries = total attempts

    Default: **3**

**TRACEHOST**
:   The local hostname to be written to the trace file.

    Default: **$(hostname -f)**

**RSYNC**
:   The rsync program

**RSYNC_EXTRA**
:   Extra rsync options as defined by the local admin.
    There is no default by ftpsync.

    Please note that these options are added to EVERY rsync call.
    Also note that these are added at the beginning of the rsync call, as
    the very first set of options.
    Please ensure you do not add a conflict with the usual rsync options as
    shown below.

**RSYNC_BW**
:   limit I/O bandwidth. Value is KBytes per second, unset or 0 means unlimited


**RSYNC_OPTIONS**
:   Default rsync options every rsync invocation sees.

    BE VERY CAREFUL WHEN YOU CHANGE THIS OPTION, BETTER DON'T!

    Default: See ftpsync script

**RSYNC_OPTIONS1**
:   Options the first pass gets. We do not want the Packages/Source indices
    here, and we also do not want to delete any files yet.

    BE VERY CAREFUL WHEN YOU CHANGE THIS OPTION, BETTER DON'T!

    Default: See ftpsync script

**RSYNC_OPTIONS2**
:   Options the second pass gets. Now we want the Packages/Source indices too
    and we also want to delete files. We also want to delete files that are
    excluded.

    BE VERY CAREFUL WHEN YOU CHANGE THIS OPTION, BETTER DON'T!

    Default: See ftpsync script

**CALLBACKUSER**, **CALLBACKHOST**, **CALLBACKKEY**
:   The following three options are used in case we want to "callback" the host
    we got pushed from.

## Hooks

Hook scripts can be run at various places during the sync.

**HOOK1**
:   After lock is acquired, before first rsync.

**HOOK2**
:   After first rsync, if successful.

**HOOK3**
:   After second rsync, if successful.

**HOOK4**
:   Right before leaf mirror triggering.

    Note that Hook3 and Hook4 are likely to be called directly after each other.
    Difference is: Hook3 is called *every* time the second rsync was successful,
    but even if the mirroring needs to re-run thanks to a second push.
    Hook4 is only effective if we are done with mirroring.

**HOOK5**
:   After leaf mirror trigger, only if we have slave mirrors (**HUB=true**).

# SEE ALSO
**ftpsync**(1)
