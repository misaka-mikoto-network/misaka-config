#/bin/dash

fatal() {
  echo "$1"
  exit 1
}

warn() {
  echo "$1"
}

RSYNCSOURCE=rsync://ftp.iij.ad.jp/pub/linux/almalinux/
BASEDIR=/HDD_6TB/almalinux

if [ ! -d ${BASEDIR} ]; then
  warn "${BASEDIR} does not exist yet, trying to create it..."
  mkdir -p ${BASEDIR} || fatal "Creation of ${BASEDIR} failed."
fi

touch ${BASEDIR}/Archive-Update-in-Progress-mirror.misakamikoto.network

rsync -rlptv -f 'R .~tmp~' --delete-delay \
  ${RSYNCSOURCE} ${BASEDIR} || warn "Failed to rsync from ${RSYNCSOURCE}."
