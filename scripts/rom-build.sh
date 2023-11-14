#!/usr/bin/env bash
#
# balgxmr's build script
# 
# Copyright (C) 2022 balgxmr ( José M. ) 
# 
# Rom path is set to ~/

clear && printf '\e[3J'

ROM_NAME='pixelos'

cd ~/$ROM_NAME || exit 1

echo "===================== Build setup ====================="
echo "1) Build ROM"
echo "2) Build kernel"
echo "3) Sync ROM"
echo "======================================================="
echo
read -p "Selección: " seleccion
echo

android_version='fourteen'
device_codename='cepheus'

case $seleccion in 
    1|2|3) 
esac

if [ $seleccion = '1' ] # Build ROM 
then
    echo "Building rom..."
    . build/envsetup.sh
    export CCACHE_DIR=~/ccache
    mkdir -p ~/ccache 
    lunch aosp_${device_codename}-user
    make installclean
    mka bacon

elif [ $seleccion = '2' ] # Build kernel
then
    if [ -f ~/$ROM_NAME/kernel/xiaomi/${device_codename}/build.sh ]
    then
        echo "Building kernel..."
        cd kernel/xiaomi/${device_codename}
        ./build.sh
    else
        echo "Kernel build script not found, aborting..."
        exit 1
    fi

elif [ $seleccion = '3' ] # Sync ROM 
then
    echo "Are you sure you wanna sync the rom...? "
    echo "(y/n):"
    read seguridad
    if [ $seguridad = 'y' ]
    then
        echo

        echo "Force sync only or clean?"
        echo "'f' for force sync, 'c' for clean"
        echo "(f/c): "
        read selection2
        if [ $selection2 = 'f' ]
        then
            echo "Force sync selected!"
            # echo "Cleaning some repos first - I don't see the point to clean these.
            # rm -rf packages/resources/devicesettings
            # rm -rf hardware/xiaomi
            echo "Force syncing ROM..."
            repo sync -c --force-sync --optimized-fetch --no-tags --no-clone-bundle --prune -j$(nproc --all)

        elif [ $selection2 = 'c' ]
        then
            echo "Clean sync selected!"
            echo "Deleting $ROM_NAME directory"
            rm -rf ~/$ROM_NAME && mkdir ~/$ROM_NAME
            cd ~/$ROM_NAME

            echo "Syncing ROM"
            repo init -u https://github.com/PixelOS-AOSP/manifest.git -b $android_version
            repo sync -c --force-sync --optimized-fetch --no-tags --no-clone-bundle --prune -j$(nproc --all)

        else 
            echo "Invalid input!"
        fi

    elif [ $seguridad = 'n' ]
    then
        echo "No selected. Aborting."

    else 
        echo "Invalid input, aborting!"
    fi
else 
    echo "Invalid input, aborting!"
fi
