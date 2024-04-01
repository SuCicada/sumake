#!/bin/bash

# get rc file
# https://github.com/nvm-sh/nvm/blob/master/install.sh#L76
if [ "${SHELL#*bash}" != "$SHELL" ]; then
  if [ -f "$HOME/.bashrc" ]; then
    DETECTED_PROFILE="$HOME/.bashrc"
  elif [ -f "$HOME/.bash_profile" ]; then
    DETECTED_PROFILE="$HOME/.bash_profile"
  fi
elif [ "${SHELL#*zsh}" != "$SHELL" ]; then
  if [ -f "$HOME/.zshrc" ]; then
    DETECTED_PROFILE="$HOME/.zshrc"
  elif [ -f "$HOME/.zprofile" ]; then
    DETECTED_PROFILE="$HOME/.zprofile"
  fi
fi

rc_file=$DETECTED_PROFILE

# add $SUMAKE_BIN
SUMAKE_BIN_VAR="SUMAKE_BIN"
default_SUMAKE_BIN=$(realpath "$(dirname $0)")/bin
SUMAKE_BIN=${SUMAKE_BIN:-$default_SUMAKE_BIN}

if grep -q "^$SUMAKE_BIN_VAR" "$rc_file"; then
#  sed -i "s/^$SUMAKE_BIN_VAR=/$SUMAKE_BIN_VAR=$SUMAKE_BIN/" "$rc_file"
  sed -i "" -e "s#^$SUMAKE_BIN_VAR=.*#$SUMAKE_BIN_VAR=$SUMAKE_BIN#" "$rc_file"
  echo "SUMAKE_BIN updated in $rc_file"
else
  echo "$SUMAKE_BIN_VAR=$SUMAKE_BIN" >>"$rc_file"
  echo "SUMAKE_BIN added to $rc_file"
fi

# add path
path_to_add="export PATH=\$PATH:\$$SUMAKE_BIN_VAR"

if ! grep -q "$path_to_add" "$rc_file"; then
  echo "$path_to_add" >>"$rc_file"
  echo "Path added to $rc_file"
else
  echo "Path already exists in $rc_file"
fi
