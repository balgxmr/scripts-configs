#! /bin/sh
#
# balgxmr's cepheus dependencies script
#
# Copyright (C) 2022 balgxmr ( José M. ) 
#
# ROM path is set to ~/

ROM_NAME='pixelos'
BUILD_SCRIPT='rom-build.sh'
android_version='fourteen'

if [ -d ~/$ROM_NAME ]
then
    echo "Directory $ROM_NAME found!"
    cd ~/$ROM_NAME || exit 1
else
    echo "ROM directory $ROM_NAME not found!\nDo you want to create a new one?"
    read -p "(y/n): " x
    if [ $x = 'y' ]
    then
        echo "Creating directory for ROM..."
        mkdir ~/$ROM_NAME && cd ~/$ROM_NAME
    elif [ $x = 'n' ]
    then
        echo "Aborting..."
        exit 1
    else
        echo "Invalid input, aborting..."
        exit 1
    fi
fi

cd ~/$ROM_NAME || exit 1
echo
echo "What do you want to do?\n1) Clone all the dependencies. (This will remove all current dependencies for cepheus and clone newer ones)"
echo "2) Clone specific dependency"
read -p "Your selection: " y
echo

if [ $y = '1' ]
then
    echo "===================== Cleaning Up ====================="
    rm -rf device/xiaomi/cepheus
    rm -rf kernel/xiaomi/cepheus
    rm -rf vendor/xiaomi/cepheus
    rm -rf hardware/xiaomi
    # rm -rf prebuilts/clang/host/linux-x86/clang-azure
    rm -rf packages/resources/devicesettings
    # rm -rf vendor/xiaomi/cepheus-miuicamera

    echo "================  Cleaning Up finished ================"
    echo
    echo "============ Starting cloning device repos ============"
    echo

    echo ">> Cloning Device tree"
    # git clone https://github.com/balgxmr/device_xiaomi_cepheus/ -b $android_version device/xiaomi/cepheus
    git clone https://github.com/PixelOS-Devices/device_xiaomi_cepheus/ -b $android_version device/xiaomi/cepheus
    echo

    echo ">> Cloning Kernel tree"
    git clone https://github.com/balgxmr/kernel_xiaomi_cepheus/ -b $android_version kernel/xiaomi/cepheus
    echo

    echo ">> Cloning Vendor tree"
    git clone https://github.com/PixelOS-Devices/vendor_xiaomi_cepheus -b $android_version vendor/xiaomi/cepheus
    echo

    echo ">> Cloning Hw/xiaomi"
    git clone https://github.com/balgxmr/hardware_xiaomi -b lineage-20 hardware/xiaomi
    echo

    echo ">> Cloning Clang"
    git clone https://gitlab.com/PixelOS-Devices/playgroundtc.git -b 17 prebuilts/clang/host/linux-x86/clang-playground
    echo

    # echo ">> Cloning Hals"
    # I'm now using these audio, media & display hals from LineageOS 
    # git clone https://github.com/balgxmr/hardware_qcom-caf_sm8150_{audio, media, display} 

    echo ">> Cloning Devicesettings"
    git clone https://github.com/LineageOS/android_packages_resources_devicesettings -b lineage-20.0 packages/resources/devicesettings
    echo

    # echo ">> Cloning Miui Camera"
    # git clone https://gitlab.com/baalgx/vendor_xiaomi_cepheus-miuicamera -b master vendor/xiaomi/cepheus-miuicamera

elif [ $y = '2' ]
then
    loop=1
    while [ $loop = '1' ]
    do
        echo "Which dependency do you want to clone?"
        echo "1. Device tree\n2. Kernel tree\n3. Vendor tree\n4. Hardware/Xiaomi"
        echo "5. Clang\n6. Device Settings"
        read -p "Your selection: " dependency
        echo

        case "$dependency" in
            "1")
            echo ">> Cloning Device tree"
            rm -rf device/xiaomi/cepheus
            # git clone https://github.com/balgxmr/device_xiaomi_cepheus/ -b $android_version device/xiaomi/cepheus
            git clone https://github.com/PixelOS-Devices/device_xiaomi_cepheus/ -b $android_version device/xiaomi/cepheus
            echo
            ;;

            "2")
            rm -rf kernel/xiaomi/cepheus
            echo ">> Cloning Kernel tree"
            git clone https://github.com/balgxmr/kernel_xiaomi_cepheus/ -b $android_version kernel/xiaomi/cepheus
            echo
            ;;

            "3")
            rm -rf vendor/xiaomi/cepheus
            echo ">> Cloning Vendor tree"
            git clone https://github.com/PixelOS-Devices/vendor_xiaomi_cepheus -b $android_version vendor/xiaomi/cepheus
            echo
            ;;
            
            "4")
            rm -rf hardware/xiaomi
            echo ">> Cloning Hw/xiaomi"
            git clone https://github.com/balgxmr/hardware_xiaomi -b lineage-20 hardware/xiaomi
            echo
            ;;

            "5")
            rm -rf prebuilts/clang/host/linux-x86/clang-playground
            echo ">> Cloning Clang"
            git clone https://gitlab.com/PixelOS-Devices/playgroundtc.git -b 17 prebuilts/clang/host/linux-x86/clang-playground
            echo
            ;;

            "6")
            rm -rf packages/resources/devicesettings
            echo ">> Cloning Devicesettings"
            git clone https://github.com/LineageOS/android_packages_resources_devicesettings -b lineage-20.0 packages/resources/devicesettings
            echo
            ;;

            # "7")
            # echo "MIUI camera isn't stable right now, do you still want to clone it?"
            # read -p "(y/n): " miuielection
            # if [ $miuielection = 'y' ]
            # then
            #    rm -rf vendor/xiaomi/cepheus-miuicamera
            #    echo ">> Cloning Miui Camera"
            #    git clone https://gitlab.com/baalgx/vendor_xiaomi_cepheus-miuicamera -b master vendor/xiaomi/cepheus-miuicamera
            #    echo
            # else
            #     echo Continuing...
            # fi
            # ;;
        esac
    echo "Do you want to clone another dependency?"
    read -p "(y/n): " z
    if [ $z = 'y' ]
    then
        loop=1
    elif [ $z = 'n' ]
    then
        loop=0
    else
    	loop=0
    	echo "Invalid input. Aborting and continuing."
    fi
    done
else
    echo "Invalid input, aborting..."
    exit 1
fi

echo
echo "============ Finished ============"
echo

echo "Wanna execute rom build script? It must be in ~/$ROM_NAME path."
read -p "(y/n) " selection

if [ $selection = 'y' ]
then
    if [ -f ~/$ROM_NAME/$BUILD_SCRIPT ]
    then
        cd ~/$ROM_NAME
        /bin/dash $BUILD_SCRIPT
    else
        echo "Build script not found, aborting..."
    fi
elif [ $selection = 'n' ]
then 
    echo "Selection was NO. Aborting."
else
    echo "Invalid input, aborting."
fi
