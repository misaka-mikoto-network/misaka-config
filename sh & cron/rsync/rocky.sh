#/bin/dash

fatal() {
  echo "$1"
  exit 1
}

warn() {
  echo "$1"
}

RSYNCSOURCE=rsync://msync.rockylinux.org/rocky
BASEDIR=/HDD_6TB/rocky

if [ ! -d ${BASEDIR} ]; then
  warn "${BASEDIR} does not exist yet, trying to create it..."
  mkdir -p ${BASEDIR} || fatal "Creation of ${BASEDIR} failed."
fi

touch ${BASEDIR}/mirror/pub/rocky/Archive-Update-in-Progress-mirror.misakamikoto.network

rsync -rlptv --delete-delay \
  ${RSYNCSOURCE} ${BASEDIR} || warn "Failed to rsync from ${RSYNCSOURCE}."
