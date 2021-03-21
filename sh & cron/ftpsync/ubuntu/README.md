# Archvsync

This is the central repository for the Debian mirror scripts.  The scripts
in this repository are written for the purposes of maintaining a Debian
archive mirror (and shortly, a Debian bug mirror), but they should be
easily generalizable.


Currently the following scripts are available:

  * ftpsync     - Used to sync an archive using rsync
  * runmirrors  - Used to notify leaf nodes of available updates

## Usage

For impatient people, short usage instruction:

 * Create a dedicated user for the whole mirror.
 * Create a seperate directory for the mirror, writeable by the new user.
 * Place the ftpsync script in the mirror user's $HOME/bin (or just $HOME)
 * Place the ftpsync.conf.sample into $HOME/etc as ftpsync.conf and edit
   it to suit your system.  You should at the very least change the TO=
   and RSYNC_HOST lines.
 * Create $HOME/log (or wherever you point $LOGDIR to)
 * If only you receive an update trigger,
   Setup the .ssh/authorized_keys for the mirror user and place the public key of
   your upstream mirror into it. Preface it with
   `no-port-forwarding,no-X11-forwarding,no-agent-forwarding,no-pty,command="~/bin/ftpsync",from="IPADDRESS"`
   and replace $IPADDRESS with that of your upstream mirror.
 * You are finished

In order to receive different pushes or syncs from different archives,
name the config file ftpsync-$ARCHIVE.conf and call the ftpsync script
with the commandline "sync:archive:$ARCHIVE". Replace $ARCHIVE with a
sensible value. If your upstream mirror pushes you using runmirrors
bundled together with this sync script, you do not need to add the
"sync:archive" parameter to the commandline, the scripts deal with it
automatically.

Common names used in the Debian mirror network are:
* standard debian archive:	default empty $ARCHIVE (ftpsync.conf)
* debian-ports archive:		ARCHIVE=ports (ftpsync-ports.conf)
* debian-security archive:	ARCHIVE=security (ftpsync-security.conf)


## Debian mirror script minimum requirements

As always, you may use whatever scripts you want for your Debian mirror,
but we *STRONGLY* recommend you to not invent your own. However, if you
want to be listed as a mirror it *MUST* support the following minimal
functionality:

*   Must perform a 2-stage sync
    The archive mirroring must be done in 2 stages. The first rsync run
    must ignore the index files.  The correct exclude options for the
    first rsync run are:
    `--exclude Packages* --exclude Sources* --exclude Release* --exclude=InRelease --include=i18n/by-hash/** --exclude=i18n/* --exclude ls-lR*`

    The first stage must not delete any files.

    The second stage should then transfer the above excluded files and
    delete files that no longer belong on the mirror.

    Rationale: If archive mirroring is done in a single stage, there will be
    periods of time during which the index files will reference files not
    yet mirrored.

*   Must not ignore pushes whil(e|st) running.
    If a push is received during a run of the mirror sync, it MUST NOT
    be ignored.  The whole synchronization process must be rerun.

    Rationale: Most implementations of Debian mirror scripts will leave the
    mirror in an inconsistent state in the event of a second push being
    received while the first sync is still running.  It is likely that in
    the near future, the frequency of pushes will increase.

*   Should understand multi-stage pushes.
    The script should parse the arguments it gets via ssh, and if they
    contain a hint to only sync stage1 or stage2, then ONLY those steps
    SHOULD be performed.

    Rationale: This enables us to coordinate the timing of the first
    and second stage pushes and minimize the time during which the
    archive is desynchronized.  This is especially important for mirrors
    that are involved in a round robin or GeoDNS setup.

    The minimum arguments the script has to understand are:
    * `sync:stage1`:  Only sync stage1
    * `sync:stage2`:  Only sync stage2
    * `sync:all`:     Do everything. Default if none of stage1/2 are present.

    There are more possible arguments, for a complete list see the
    ftpsync script in our git repository.

## ftpsync

This script is based on the old anonftpsync script.  It has been rewritten
to add flexibilty and fix a number of outstanding issues.

Some of the advantages of the new version are:
 * Nearly every aspect is configurable
 * Correct support for multiple pushes
 * Support for multi-stage archive synchronisations
 * Support for hook scripts at various points
 * Support for multiple archives, even if they are pushed using one ssh key
 * Support for multi-hop, multi-stage archive synchronisations

### Correct support for multiple pushes
When the script receives a second push while it is running and syncing
the archive it won't ignore it. Instead it will rerun the
synchronisation step to ensure the archive is correctly synchronised.

Scripts that fail to do that risk ending up with an inconsistent archive.

### Can do multi-stage archive synchronisations
The script can be told to only perform the first or second stage of the
archive synchronisation.

This enables us to send all the binary packages and sources to a
number of mirrors, and then tell all of them to sync the
Packages/Release files at once. This will keep the timeframe in which
the mirrors are out of sync very small and will greatly help things like
DNS RR entries or even the planned GeoDNS setup.

### Multi-hop, multi-stage archive synchronisations
The script can be told to perform a multi-hop multi-stage archive
synchronisation.

This is basically the same as the multi-stage synchronisation
explained above, but enables the downstream mirror to push his own
staged/multi-hop downstreams before returning. This has the same
advantage than the multi-stage synchronisation but allows us to do
this over multiple level of mirrors. (Imagine one push going from
Europe to Australia, where then locally 3 others get updated before
stage2 is sent out. Instead of 4times transferring data from Europe to
Australia, just to have them all updated near instantly).


### Can run hook scripts
ftpsync currently allows 5 hook scripts to run at various points of the
mirror sync run.

* Hook1: After lock is acquired, before first rsync
* Hook2: After first rsync, if successful
* Hook3: After second rsync, if successful
* Hook4: Right before leaf mirror triggering
* Hook5: After leaf mirror trigger (only if we have slave mirrors; HUB=true)

Note that Hook3 and Hook4 are likely to be called directly after each other.
The difference is that Hook3 is called *every* time the second rsync
succeeds even if the mirroring needs to re-run due to a second push.
Hook4 is only executed if mirroring is completed.

### Support for multiple archives, even if they are pushed using one ssh key
If you get multiple archives from your upstream mirror (say Debian,
Debian-Backports and Volatile), previously you had to use 3 different ssh
keys to be able to automagically synchronize them.  This script can do it
all with just one key, if your upstream mirror tells you which archive.
See "Commandline/SSH options" below for further details.

For details of all available options, please see the extensive documentation
in the sample configuration file.

### Commandline/SSH options

Script options may be set either on the local command line, or passed by
specifying an ssh "command".  Local commandline options always have
precedence over the SSH_ORIGINAL_COMMAND ones.

Currently this script understands the options listed below. To make them
take effect they MUST be prepended by "sync:".

| Option       | Behaviour |
|--------------|-----------|
| stage1       | Only do stage1 sync |
| stage2       | Only do stage2 sync |
| all          | Do a complete sync (default) |
| mhop         | Do a multi-hop sync |
| archive:foo  | Sync archive foo (if the file $HOME/etc/ftpsync-foo.conf exists and is configured) |
| callback     | Call back when done (needs proper ssh setup for this to work). It will always use the "command" callback:$HOSTNAME where $HOSTNAME is the one defined in config and will happen before slave mirrors are triggered. |

So, to get the script to sync all of the archive behind bpo and call back when
it is complete, use an upstream trigger of
ssh $USER@$HOST sync:all sync:archive:bpo sync:callback


Mirror trace files
==================
Every mirror needs to have a 'trace' file under project/trace.
The filename has to be the full hostname (eg. hostname -f), or in the
case of a mirror participating in RR DNS (where users will never use
the hostname) the name of the DNS RR entry, eg. security.debian.org
for the security rotation.). (Note: ftp.$COUNTRY.debian.org is always
wrong, don't use that).

The contents are defined as:

First line is always the output of "date -u", ideally run with LANG
and LC_ALL set to POSIX.

Lines two to the end of file follow a RFC822 style format, though the
field names can have spaces. Currently the following fields are
defined, listed in the order as output by ftpsync, though the order is
not mandantory:

| Field | Content | Example |
|-------|---------|---------|
| `Date` | Date in RFC822 Format when the tracefile got generated, ie. end of mirror run. | `Sun, 28 Feb 2016 09:40:29 +0000` |
| `Date-Started` | As Date, but the time the mirror run started. | `Sun, 28 Feb 2016 09:33:55 +0000` |
| `Archive Serial` | Archive serial for mirror run, taken from main archives tracefile. | `2016022802` |
| `Creator` | Name and version of used software | `ftpsync 20170204`
| `Running on host` | FQDN of mirror host. This may not match the actual mirror name, its the real hostname. | `klecker.debian.org` |
| `Maintainer` | Groups and people responsible for this mirror. | `Admins <admins@example.com>` |
| `Sponsor` | Organizations sponsoring this mirror. | `Example <https://example.com>` |
| `Country` | The ISO 3361-1 code of the country hosting this mirror. | `DE` |
| `Location` | The location this mirror is hosted in. | `Example` |
| `Throughput` | Available throughput for this mirror per second. | `10Gb` |
| `Trigger` | Trigger used for this run.` | `cron`, `ssh (comment)` |
| `Architectures` | List of architectures included in the mirror. | `all amd64 i386 source` |
| `Architectures-Configuration` | Architecture list as specified in config. | `ALL`, `INCLUDE amd64 i386 source`, `EXCLUDE armel` |
| `Upstream-Mirror` | From where does the mirror get its data. | `ftp-master.debian.org` |
| `Rsync-Transport` | Transport to connect to upstream used by rsync | `plain`
| `Total bytes received in rsync` | rsync --stats output, bytes received | `1109846675` |
| `Total time spent in stage1 rsync` | Seconds of runtime for stage1 | `347` |
| `Total time spent in stage2 rsync` | Seconds of runtime for stage2 | `47` |
| `Total time spent in rsync` | How long in total for rsync | `394` |
| `Average rate` | How fast did the sync go | `2816869 B/s` |

The third line in the legacy format and the hostname for the "Running
on Host" line for the new format MUST NOT be the DNS RR name, even if
the mirror is part of it. It MUST BE the hosts own name. This is in
contrast to the filename, which SHOULD be the DNS RR name.


## runmirrors

This script is used to tell leaf mirrors that it is time to synchronize
their copy of the archive. This is done by parsing a mirror list and
using ssh to "push" the leaf nodes. You can read much more about the
principle behind the
[push](http://blog.ganneff.de/blog/2007/12/29/ssh-triggers.html),
essentially it tells the receiving
end to run a pre-defined script. As the whole setup is extremely limited
and the ssh key is not usable for anything else than the pre-defined
script this is the most secure method for such an action.

This script supports two types of pushes: The normal single stage push,
as well as the newer multi-stage push.

The normal push, as described above, will simply push the leaf node and
then go on with the other nodes.

The multi-staged push first pushes a mirror and tells it to only do a
stage1 sync run. Then it waits for the mirror (and all others being pushed
in the same run) to finish that run, before it tells all of the staged
mirrors to do the stage2 sync.

This way you can do a nearly-simultaneous update of multiple hosts.
This is useful in situations where periods of desynchronization should
be kept as small as possible. Examples of scenarios where this might be
useful include multiple hosts in a DNS Round Robin entry.

For details on the mirror list please see the documented
runmirrors.mirror.sample file.
