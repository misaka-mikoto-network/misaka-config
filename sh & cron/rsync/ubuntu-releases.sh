#/bin/dash

fatal() {
  echo "$1"
  exit 1
}

warn() {
  echo "$1"
}

RSYNCSOURCE=rsync://archive.releases.ubuntu.com/releases/
BASEDIR=/HDD/ubuntu-releases

if [ ! -d ${BASEDIR} ]; then
  warn "${BASEDIR} does not exist yet, trying to create it..."
  mkdir -p ${BASEDIR} || fatal "Creation of ${BASEDIR} failed."
fi

touch ${BASEDIR}/Archive-Update-in-Progress-mirror.misakamikoto.network

rsync --verbose --recursive --times --links --safe-links --hard-links \
  --stats --delete-after \
  ${RSYNCSOURCE} ${BASEDIR} || warn "Failed to rsync from ${RSYNCSOURCE}."

rm ${BASEDIR}/Archive-Update-*