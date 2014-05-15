#!/bin/bash

additionsjar='additions-4.1.jar'

aki=$PWD

pushd dspace/modules/additions
mvn package
popd

if test -f "dspace/modules/additions/target/$additionsjar"
then if test -d "$BDPIINSTALLDIR/webapps"
     then pushd $BDPIINSTALLDIR/webapps
          for f in $(find * -type 'f' -name "$additionsjar")
          do if cp "$aki/dspace/modules/additions/target/$additionsjar" "$f"
	    then echo "additions successfully replaced in $f"
	    else echo "error when replacing additions in $f"
	    fi
          done
          popd
	  /etc/init.d/tomcat7 restart
	  sudo tail -f /var/log/tomcat7/catalina.out
          exit 0
     else echo "folder $BDPIINSTALLDIR/webbapps does not exist, did you run install.sh ?"
          exit 1
     fi
else echo "file dspace/modules/additions/target/$additionsjar does not exist, did you run install.sh ?"
  exit 1
fi
