#!/usr/bin/env bash
# Copyright 2015 Google Inc. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# ==============================================================================

# copied from tensorflow commit 2f97f6aadce66027b04e8de1e1ba744b125dcbb9 March 12, 2016

set -e

export CUDA_HOME=${CUDA_HOME:-/usr/local/cuda}

if [ ! -d ${CUDA_HOME}/lib64 ]; then
  echo "Failed to locate CUDA libs at ${CUDA_HOME}/lib64."
  exit 1
fi

export CUDA_SO=$(\ls /usr/lib/x86_64-linux-gnu/libcuda.* | \
                    xargs -I{} echo '-v {}:{}')
export DEVICES=$(\ls /dev/nvidia* | \
                    xargs -I{} echo '--device {}:{}')

if [[ "${DEVICES}" = "" ]]; then
  echo "Failed to locate NVidia device(s). Did you want the non-GPU container?"
  exit 1
fi

# CHANGED FROM tensorflow version: when running via jenkins we can't use a terminal (-t)
docker run -i $CUDA_SO $DEVICES "$1" "$2" "$3" "$4" "$5"
#docker run -it $CUDA_SO $DEVICES "$@"

