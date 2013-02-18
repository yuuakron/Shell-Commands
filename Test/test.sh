#!/bin/bash

cat geekresult-2.4.0.html | tr -d '\n' | sed 's/<td/\
<td/g' | sed 's/<\/td>/<\/td>\
/g' | grep td
