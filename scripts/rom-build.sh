#! /bin/sh
#
# balgxmr's build script
# 
# Copyright (C) 2022 balgxmr ( José M. ) 
# 
# Rom path is set to ~/

clear && printf '\e[3J'

rom_name='pixelos'

cd ~/$rom_name || exit 1

echo "===================== Build setup ====================="
echo "1) Build ROM"
echo "2) Build kernel"
echo "3) Sync ROM"
echo "======================================================="
echo
echo "Selección: " 
read seleccion
echo

android_version='thirteen'
device_codename='cepheus'

case $seleccion in 
    1|2|3) 
esac

if [ $seleccion = '1' ] # Build ROM 
then
    echo "Building rom..."
    /bin/dash build/envsetup.sh
    export CCACHE_DIR=~/ccache
    mkdir -p ~/ccache 
    lunch aosp_${device_codename}-user
    make installclean
    mka bacon

elif [ $seleccion = '2' ] # Build kernel
then
    if [ -f ~/$rom_name/build.sh ]
    then
        echo "Building kernel..."
        cd kernel/xiaomi/${device_codename}
        /bin/dash build.sh
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
            echo "Cleaning some repos first..."
            rm -rf hardware/qcom-caf/sm8150
            rm -rf packages/resources/devicesettings
            rm -rf hardware/xiaomi
            echo "Force syncing ROM..."
            repo sync -c --force-sync --optimized-fetch --no-tags --no-clone-bundle --prune -j$(nproc --all)

        elif [ $selection2 = 'c' ]
        then
            echo "Clean sync selected!"
            echo "Deleting $rom_name directory"
            rm -rf ~/$rom_name && mkdir ~/$rom_name
            cd ~/$rom_name

            echo "Syncing ROM"
            repo init -u https://github.com/PixelOS-AOSP/manifest.git -b $android_version
            repo sync -c --force-sync --optimized-fetch --no-tags --no-clone-bundle --prune -j$(nproc --all)

        else 
            echo "Ah? Invalid input, aborting!"
        fi

    elif [ $seguridad = 'n' ]
    then
        echo "So you don't want to sync the rom, aborting!"

    else 
        echo "Invalid input, aborting!"
    fi
else 
    echo "Invalid input, aborting!"
fi
