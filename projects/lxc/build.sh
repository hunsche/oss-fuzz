#!/bin/bash -e
# Copyright 2021 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
################################################################################

export CFLAGS="${CFLAGS} -Wno-error=backend-plugin"
if [ "$SANITIZER" = "memory" ]; then
  MESON_BACKUP="$(mktemp /tmp/lxc_meson.XXXXXX)"
  cp meson.build "$MESON_BACKUP"
  trap 'mv -f "$MESON_BACKUP" meson.build' EXIT
  sed -i "s/have = cc.has_function(ident\[0\], prefix: ident\[1\], args: '-D_GNU_SOURCE')/have = ident[0] in ['strlcpy', 'strlcat'] ? false : cc.has_function(ident[0], prefix: ident[1], args: '-D_GNU_SOURCE')/" meson.build
fi
src/tests/oss-fuzz.sh
