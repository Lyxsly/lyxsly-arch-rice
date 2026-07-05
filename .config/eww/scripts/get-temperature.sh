#!/bin/bash

temp=$(sensors | awk '
  /^Tctl:/ && tctl == "" { tctl = $2 }
  /^edge:/ && edge == "" { edge = $2 }
  /^temp1:/ && temp1 == "" { temp1 = $2 }
  END {
    if (tctl != "") print tctl
    else if (edge != "") print edge
    else if (temp1 != "") print temp1
  }
' | tr -d '+°C' | cut -d'.' -f1)

echo "${temp:-0}"
