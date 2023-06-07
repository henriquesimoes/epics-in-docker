#!/usr/bin/env bash

set -ex

git clone --depth 1 --branch ${AREA_DETECTOR_VERSION} \
    https://github.com/areaDetector/areaDetector

cd areaDetector

git submodule update --init --depth 1 -j ${JOBS} \
    ADSimDetector \
    ADSupport \
    ADCore

cd configure
cat EXAMPLE_RELEASE.local | \
    sed -e "s|^#ADCORE=|ADCORE=|" \
        -e "s|^#ADSUPPORT=|ADSUPPORT=|" \
        -e "s|^#ADSIMDETECTOR=|ADSIMDETECTOR=|" \
    > RELEASE.local

cat EXAMPLE_RELEASE_LIBS.local | \
    sed -e "s|^SUPPORT=.*$|SUPPORT=${EPICS_MODULES_PATH}|" \
        -e "s|^ASYN=.*$|ASYN=${EPICS_MODULES_PATH}/asyn|" \
        -e "s|^AREA_DETECTOR=.*$|AREA_DETECTOR=${EPICS_MODULES_PATH}/areaDetector|" \
        -e "s|^EPICS_BASE=.*$|EPICS_BASE=${EPICS_BASE_PATH}|" \
    > RELEASE_LIBS.local

cat EXAMPLE_RELEASE_PRODS.local | \
    sed -e "s|^SUPPORT=.*$|SUPPORT=${EPICS_MODULES_PATH}|" \
        -e "s|^ASYN=.*$|ASYN=${EPICS_MODULES_PATH}/asyn|" \
        -e "s|^AREA_DETECTOR=.*$|AREA_DETECTOR=${EPICS_MODULES_PATH}/areaDetector|" \
        -e "s|^AUTOSAVE=.*$|AUTOSAVE=${EPICS_MODULES_PATH}/autosave|" \
        -e "s|^BUSY=.*$|BUSY=${EPICS_MODULES_PATH}/busy|" \
        -e "s|^CALC=.*$|CALC=${EPICS_MODULES_PATH}/calc|" \
        -e "s|^SSCAN=.*$|SSCAN=${EPICS_MODULES_PATH}/sscan|" \
        -e "s|^DEVIOCSTATS=|#DEVIOCSTATS=|" \
        -e "s|^SNCSEQ=|#SNCSEQ=|" \
        -e "s|^EPICS_BASE=.*$|EPICS_BASE=${EPICS_BASE_PATH}|" \
    > RELEASE_PRODS.local

cat EXAMPLE_CONFIG_SITE.local | \
    sed -e "s|^BUILD_IOCS\s*=.*$|BUILD_IOCS=NO|" \
        -e "s|^WITH_GRAPHICSMAGICK\s*=.*$|WITH_GRAPHICSMAGICK=NO|" \
    > CONFIG_SITE.local

cd -

make -j${JOBS}
make clean
