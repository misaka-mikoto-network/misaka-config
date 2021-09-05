#/bin/dash

fatal() {
  echo "$1"
  exit 1
}

warn() {
  echo "$1"
}

RSYNCSOURCE=rsync://mirrors.kernel.org/mirrors/oracle/
BASEDIR=/HDD_6TB/oracle-linux

if [ ! -d ${BASEDIR} ]; then
  warn "${BASEDIR} does not exist yet, trying to create it..."
  mkdir -p ${BASEDIR} || fatal "Creation of ${BASEDIR} failed."
fi

touch ${BASEDIR}/Archive-Update-in-Progress-mirror.misakamikoto.network

rsync -rlptv --delete-delay \
  ${RSYNCSOURCE} ${BASEDIR} || warn "Failed to rsync from ${RSYNCSOURCE}."
