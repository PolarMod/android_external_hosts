INFILE="$LOCAL_PATH/src/hosts.base"
OUTFILE_REAL="$BASEDIR/system/core/rootdir/etc/hosts"

if ndef WGET_OPTIONS; then
  WGET_OPTIONS="-q"
fi

dl_hosts(){
  info "Downloading and extracting $2 hosts..."
  exec rm -rf /tmp/hosts
  exec wget $WGET_OPTIONS -O /tmp/hosts $1
  exec "cat /tmp/hosts >> $OUTFILE"
  success "Downloaded and extracted $2 hosts"
}

target_cat2(){
  info "Building CAT-II hosts"
  OUTFILE="/tmp/hosts_cat2"
  exec rm -rf $OUTFILE
  exec cp $INFILE $OUTFILE
  dl_hosts "https://raw.githubusercontent.com/StevenBlack/hosts/master/data/StevenBlack/hosts" "StevenBlack's"
  dl_hosts "https://raw.githubusercontent.com/FadeMind/hosts.extras/master/add.2o7Net/hosts" "FadeMind's"
  dl_hosts "https://raw.githubusercontent.com/FadeMind/hosts.extras/master/add.Risk/hosts" "add.Risk"
  dl_hosts "https://raw.githubusercontent.com/FadeMind/hosts.extras/master/add.Spam/hosts" "add.Spam"
  dl_hosts "https://raw.githubusercontent.com/shreyasminocha/shady-hosts/main/hosts" 'shady_hosts'
  dl_hosts "https://raw.githubusercontent.com/tiuxo/hosts/master/ads" "tiuxo's ads"
  dl_hosts "https://www.github.developerdan.com/hosts/lists/ads-and-tracking-extended.txt" "Ads extended"
  dl_hosts "https://www.github.developerdan.com/hosts/lists/dating-services-extended.txt" "Dating extended"
  dl_hosts "https://raw.githubusercontent.com/daylamtayari/Pi-Hole-Blocklist/master/Mirrors/Snapchat-Blocklist--d43m0nhLInt3r.txt" "Snapchat"
  exec cp $OUTFILE $OUTFILE_REAL
}

target_cat1(){
  target_cat2
  exec cp $OUTFILE $OUTFILE_REAL
  OUTFILE=$OUTFILE_REAL
  dl_hosts "https://www.github.developerdan.com/hosts/lists/facebook-extended.txt" "FaceBook extended"
  dl_hosts "https://www.github.developerdan.com/hosts/lists/amp-hosts-extended.txt" "AMP Hosts"
  dl_hosts "https://www.github.developerdan.com/hosts/lists/hate-and-junk-extended.txt" "Hate&Junk"
  dl_hosts "https://www.github.developerdan.com/hosts/lists/tracking-aggressive-extended.txt" "Tracking agressive"
  exec "cat $LOCAL_PATH/src/hosts_cat1.base >> $OUTFILE"
}

target_cat3(){
  info "Building CAT-III hosts"
  OUTFILE="/tmp/hosts_cat3"
  exec "rm -f $OUTFILE"
  exec cp "$INFILE $OUTFILE"
  exec cp "$OUTFILE" "$OUTFILE_REAL"
}


droidbuild_module(){
  info "Cleaning hosts"
  exec rm $OUTFILE_REAL
  if ndef TARGET_HOSTS_CAT; then
    warn "TARGET_HOSTS_CAT is undefined. Defining it as 1."
    TARGET_HOSTS_CAT=1
  fi
  require_command wget
  if [ $TARGET_HOSTS_CAT -eq 1 ]; then
    target_cat1
  elif [ $TARGET_HOSTS_CAT -eq 2 ]; then
    target_cat2
  elif [ $TARGET_HOSTS_CAT -eq 3 ]; then
    target_cat3
  else
    error "Unknown hosts category: $TARGET_HOSTS_CAT"
    error "Aborting build"
    exit 255
  fi
}
