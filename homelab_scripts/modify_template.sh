#!/bin/bash

if [[ ${SET_DESCRIPTION} == 1 ]]; then
  setfattr -n user.description -v "${TEMPLATE_DESCRIPTION}" "${LINUX_TEMPLATE_DIR}/${TEMPLATE_NAME}"
fi
if [[ ${SET_DISTROVER} == 1 ]]; then
  setfattr -n user.distrover -v "${TEMPLATE_DISTROVER}" "${LINUX_TEMPLATE_DIR}/${TEMPLATE_NAME}"
fi
