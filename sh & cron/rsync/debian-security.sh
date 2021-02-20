#/bin/dash

fatal() {
  echo "$1"
  exit 1
}

warn() {
  echo "$1"
}

RSYNCSOURCE=rsync://rsync.security.debian.org/debian-security/
BASEDIR=/HDD/debian-security

if [ ! -d ${BASEDIR} ]; then
  warn "${BASEDIR} does not exist yet, trying to create it..."
  mkdir -p ${BASEDIR} || fatal "Creation of ${BASEDIR} failed."
fi

touch ${BASEDIR}/Archive-Update-in-Progress-mirror.misakamikoto.network

rsync --verbose --recursive --times --links --safe-links --hard-links \
  --stats \
  --exclude "Packages*" --exclude "Sources*" \
  --exclude "Release*" --exclude "InRelease" \
  ${RSYNCSOURCE} ${BASEDIR} || warn "First stage of sync failed. (Debian-Security)"

rsync --verbose --recursive --times --links --safe-links --hard-links \
  --stats --delete --delete-after \
  ${RSYNCSOURCE} ${BASEDIR} || warn "Second stage of sync failed. (Debian-Security)"

rm ${BASEDIR}/Archive-Update-*
printf "$(date -u)\nMaintainer: Kwabang <kwabang2827@gmail.com>\nUpstream-mirror: rsync.security.debian.org\n" > ${BASEDIR}/project/trace/mirror.misakamikoto.network