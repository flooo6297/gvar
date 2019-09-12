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
        if [ "$nameGot" = false ];
        then
          awaitValue=false
          name="$arg"
          nameGot=true
          type=""
          madeChange=true
        else
          throwError
        fi
        ;;
      "r")
        if [ "$nameGot" = false ];
        then
          awaitValue=false
          name="$arg"
          remove=true
          nameGot=true
          type=""
          madeChange=true
        else
          throwError
        fi
        ;;
      "v")
        if [ "$valueGot" = false ];
        then
          awaitValue=false
          value="$arg"
          valueGot=true
          type=""
          madeChange=true
        else
          throwError
        fi
        ;;
      "c")
        if [ "$configGot" = false ];
        then
          awaitValue=false
          configGot=true
          config="$arg"
          type=""
          madeChange=true
        else
          throwError
        fi
        ;;
      "e")
        if [ "$nameGot" = false ];
        then
          awaitValue=false
          check=true
          nameGot=true
          name="$arg"
          type=""
          madeChange=true
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

if [ "$nameGot" = true ];
then
  contents="{}"
  if [ ! -f "$config" ];
  then
    touch "$config"
  else
    contents=$(<"$config")
    if [ ${#contents} -eq 0 ];
    then
      contents="{}"
    fi
  fi



if [ "$removeAll" = true ];
then
  contents="{}"
else
  if [ "$check" = true ];
  then
    echo ${contents} | jq "(.| has(\"$name\"))"
  else
    exists=$(echo ${contents} | jq "(.| has(\"$name\"))")
    if [ "$exists" = true ];
    then
      if [ "$remove" = true ];
      then
        contents=$(echo "$contents" | jq "del(.\"$name\") ")
      else
        if [ "$valueGot" = false ];
        then
          echo "$contents" | jq ."$name"
        else
          contents=$(echo "$contents" | jq ". + {\"$name\": \"$value\"}")
        fi
      fi
    else
      if [ "$valueGot" = true ];
      then
        contents=$(echo "$contents" | jq ". + {\"$name\": \"$value\"}")
      else
        throwError
      fi
    fi
  fi
fi

echo "$contents" > "$config"

else
  throwError
fi
