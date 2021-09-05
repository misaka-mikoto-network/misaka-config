#/bin/dash

fatal() {
  echo "$1"
  exit 1
}

warn() {
  echo "$1"
}

RSYNCSOURCE=rsync://cdimage.debian.org/debian-cd/
BASEDIR=/HDD_6TB/debian-cd

if [ ! -d ${BASEDIR} ]; then
  warn "${BASEDIR} does not exist yet, trying to create it..."
  mkdir -p ${BASEDIR} || fatal "Creation of ${BASEDIR} failed."
fi

touch ${BASEDIR}/Archive-Update-in-Progress-mirror.misakamikoto.network

rsync --verbose --recursive --times --links --safe-links --hard-links \
  --stats --delete-after \
  ${RSYNCSOURCE} ${BASEDIR} || warn "Failed to rsync from ${RSYNCSOURCE}."
