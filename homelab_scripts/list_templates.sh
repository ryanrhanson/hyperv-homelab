#!/bin/bash
# List out our templates with any metadata


templates=()
templates+=("Template^DistroVer^Description")
for i in ${LINUX_TEMPLATE_DIR}/*.vhdx;
  do templates+=("$(basename ${i})^$(getfattr --only-values -m user.distrover ${i} 2> /dev/null)^$(getfattr --only-values -m user.description ${i} 2> /dev/null)");
done; 
for templ in "${templates[@]}"; do printf "%-8s\n" "${templ}"; done | column -t -s '^'

