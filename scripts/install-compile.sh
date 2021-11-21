#!/usr/bin/env bash
set -e

if [[ -z "${PIP_INSTALL}" ]]; then
    PIP_INSTALL='install'
fi

# Directory of *this* script
this_dir="$( cd "$( dirname "$0" )" && pwd )"
src_dir="$(realpath "${this_dir}/..")"

: "${PYTHON=python3}"

python_version="$(${PYTHON} --version)"

# Install Python dependencies
echo 'Installing Python dependencies'
pip3 ${PIP_INSTALL} --upgrade pip
pip3 ${PIP_INSTALL} --upgrade wheel setuptools

if [[ -f requirements.txt ]]; then
    pip3 ${PIP_INSTALL} -r requirements.txt
fi


echo 'Compiling monotonic_align extension'
pushd "${src_dir}"
python3 glow_tts_train/monotonic_align/setup.py build_ext --inplace
popd

# Development dependencies
if [[ -f requirements_dev.txt ]]; then
    pip3 ${PIP_INSTALL} -r requirements_dev.txt || echo "Failed to install development dependencies" >&2
fi

# -----------------------------------------------------------------------------

echo "OK"
