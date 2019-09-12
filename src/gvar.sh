#!/bin/sh

awaitValue=false
type=""
name=""
nameGot=false
config="$HOME/.config/gvar/var.conf"
value=""
valueGot=false
remove=false
check=false
removeAll=false

throwError() {
  echo "error"
  exit
}

for arg in "$@"
do
  if [ "$awaitValue" = true ];
  then
    madeChange=false
    case "$type" in
      "n")
        if  [ "$nameGot" = false ];
        then
          awaitValue=false
          name="$arg"
          nameGot=true
          type=""
        else
          throwError
        fi
        ;;
    esac
    if [ "$madeChange" = false ];
    then
      throwError
    fi
  else
    madeChange=false
    case "$arg" in
      "-n")
        awaitValue=true
        type="n"
        madeChange=true
        ;;
      "-v")
        awaitValue=true
        type="v"
        madeChange=true
        ;;
      "-c")
        awaitValue=true
        type="c"
        madeChange=true
        ;;
      "-r")
        awaitValue=true
        type="r"
        madeChange=true
        ;;
      "-e")
        awaitValue=true
        type="e"
        madeChange=true
        ;;
      "-rA")
        removeAll=true
        nameGot=true
        type="rA"
        madeChange=true
        ;;
    esac
    if [ "$madeChange" = false ];
    then
      throwError
    fi
  fi
done