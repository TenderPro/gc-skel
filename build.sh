#
# Build all gitbook items
#

CMD=$1
shift

PROJECT=$1
shift

# setup perms
#. /init.sh echo --

# setup bin path
export PATH=$PATH:/home/app/web_loaders/.bin

if [[ $CMD == "init" ]] ; then
  gosu $APPUSER gitbook init
  exit
elif [[ $CMD == "serve" ]] ; then
  gosu $APPUSER gitbook serve
  exit
elif [[ $CMD == "install" ]] || [[ $CMD == "all" ]] ; then
  chown $APPUSER /home/app
  gosu $APPUSER gitbook install
  [[ $CMD == "install" ]] && exit
fi

[ -d _book ] || { mkdir _book ; chown $APPUSER _book ; }

# build failed if bad link exists
[ -L html ] && rm html

# build

if [[ $CMD == "all" ]] || [[ "$CMD" == "html" ]] ; then gosu $APPUSER gitbook build ./ ; fi
if [[ $CMD == "all" ]] || [[ "$CMD" == "pdf" ]]  ; then gosu $APPUSER gitbook pdf  ./ _book/${PROJECT}.pdf ; fi
if [[ $CMD == "all" ]] || [[ "$CMD" == "epub" ]] ; then gosu $APPUSER gitbook epub ./ _book/${PROJECT}.epub ; fi
