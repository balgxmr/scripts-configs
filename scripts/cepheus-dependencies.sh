#! /bin/sh
#
# balgxmr's cepheus dependencies script
#
# Copyright (C) 2022 balgxmr ( José M. ) 
#
# ROM path is set to ~/

rom_name='pixelos'
buildScript='rom-build.sh'
if [ -d ~/$rom_name ]
then
    echo "Directory $rom_name found!"
    cd ~/$rom_name || exit 1
else
    echo "ROM directory $rom_name not found!\nDo you want to create a new one?"
    read -p "(y/n): " x
    if [ $x = 'y' ]
    then
        echo "Creating directory for ROM..."
        mkdir ~/$rom_name && cd ~/$rom_name
    elif [ $x = 'n' ]
    then
        echo "Aborting..."
        exit 1
    else
        echo "Invalid input, aborting..."
        exit 1
    fi
fi

cd ~/$rom_name || exit 1
echo
echo "What do you want to do?\n1) Clone all the dependencies. (This will remove all current dependencies for cepheus and clone newer ones)"
echo "2) Clone specific dependency"
read -p "Your selection: " y
if [ $y = '1' ]
then
    echo "===================== Cleaning Up ====================="
    rm -rf device/xiaomi/cepheus
    rm -rf kernel/xiaomi/cepheus
    rm -rf vendor/xiaomi/cepheus
    rm -rf hardware/xiaomi
    # rm -rf prebuilts/clang/host/linux-x86/clang-azure
    rm -rf hardware/qcom-caf/sm8150
    rm -rf packages/resources/devicesettings
    rm -rf vendor/xiaomi/cepheus-miuicamera

    echo "================  Cleaning Up finished ================"
    echo "============ Starting cloning device repos ============"

    echo ">> Cloning Device tree"
    # git clone https://github.com/balgxmr/device_xiaomi_cepheus/ -b thirteen device/xiaomi/cepheus
    git clone https://github.com/PixelOS-Devices/device_xiaomi_cepheus/ -b thirteen device/xiaomi/cepheus

    echo ">> Cloning Kernel tree"
    git clone https://github.com/balgxmr/kernel_xiaomi_cepheus/ -b thirteen kernel/xiaomi/cepheus

    echo ">> Cloning Vendor tree"
    git clone https://github.com/PixelOS-Devices/vendor_xiaomi_cepheus -b thirteen vendor/xiaomi/cepheus

    echo ">> Cloning Hw/xiaomi"
    git clone https://github.com/balgxmr/android_hardware_xiaomi -b lineage-20 hardware/xiaomi

    echo ">> Cloning Clang"
    git clone https://gitlab.com/Panchajanya1999/azure-clang -b main prebuilts/clang/host/linux-x86/clang-azure --depth=1

    echo ">> Cloning Hals"
    git clone https://github.com/balgxmr/hardware_qcom-caf_sm8150_audio.git -b thirteen hardware/qcom-caf/sm8150/audio
    git clone https://github.com/balgxmr/hardware_qcom-caf_sm8150_media.git -b thirteen hardware/qcom-caf/sm8150/media
    git clone https://github.com/balgxmr/hardware_qcom-caf_sm8150_display.git -b thirteen hardware/qcom-caf/sm8150/display

    echo ">> Cloning Devicesettings"
    git clone https://github.com/xiaomi-cepheus/packages_resources_devicesettings -b twelve packages/resources/devicesettings

    echo ">> Cloning Miui Camera"
    git clone https://gitlab.com/baalgx/vendor_xiaomi_cepheus-miuicamera -b master vendor/xiaomi/cepheus-miuicamera

elif [ $y = '2' ]
then
    echo "Which dependency do you want to clone?"
    echo "1. Device tree\n2. Kernel tree\n3. Vendor tree\n4. Hardware/Xiaomi"
    echo "5. Clang\n6. Hals\n7. Device Settings\n8. MIUI Camera vendor"
    read -p "Your selection: " dependency
    echo

    case "$dependency" in
        "1")
        echo ">> Cloning Device tree"
        rm -rf device/xiaomi/cepheus
        # git clone https://github.com/balgxmr/device_xiaomi_cepheus/ -b thirteen device/xiaomi/cepheus
        git clone https://github.com/PixelOS-Devices/device_xiaomi_cepheus/ -b thirteen device/xiaomi/cepheus
        ;;

        "2")
        rm -rf device/xiaomi/cepheus
        echo ">> Cloning Kernel tree"
        git clone https://github.com/balgxmr/kernel_xiaomi_cepheus/ -b thirteen kernel/xiaomi/cepheus
        ;;

        "3")
        rm -rf device/xiaomi/cepheus
        echo ">> Cloning Vendor tree"
        git clone https://github.com/PixelOS-Devices/vendor_xiaomi_cepheus -b thirteen vendor/xiaomi/cepheus
        ;;
        
        "4")
        rm -rf device/xiaomi/cepheus
        echo ">> Cloning Hw/xiaomi"
        git clone https://github.com/balgxmr/android_hardware_xiaomi -b lineage-20 hardware/xiaomi
        ;;

        "5")
        rm -rf device/xiaomi/cepheus
        echo ">> Cloning Clang"
        git clone https://gitlab.com/Panchajanya1999/azure-clang -b main prebuilts/clang/host/linux-x86/clang-azure --depth=1
        ;;

        "6")
        rm -rf device/xiaomi/cepheus
        echo ">> Cloning Hals"
        git clone https://github.com/balgxmr/hardware_qcom-caf_sm8150_audio.git -b thirteen hardware/qcom-caf/sm8150/audio
        git clone https://github.com/balgxmr/hardware_qcom-caf_sm8150_media.git -b thirteen hardware/qcom-caf/sm8150/media
        git clone https://github.com/balgxmr/hardware_qcom-caf_sm8150_display.git -b thirteen hardware/qcom-caf/sm8150/display
        ;;

        "7")
        rm -rf device/xiaomi/cepheus
        echo ">> Cloning Devicesettings"
        git clone https://github.com/xiaomi-cepheus/packages_resources_devicesettings -b twelve packages/resources/devicesettings
        ;;

        "8")
        rm -rf device/xiaomi/cepheus
        echo ">> Cloning Miui Camera"
        git clone https://gitlab.com/baalgx/vendor_xiaomi_cepheus-miuicamera -b master vendor/xiaomi/cepheus-miuicamera
        ;;
    esac
else
    echo "Invalid input, aborting..."
    exit 1
fi

echo
echo "============ Finished ============"
echo

echo "Wanna execute rom build script? It must be in ~/$rom_name path."
read -p "(y/n) " selection

if [ $selection = 'y' ]
then
    if [ -f ~/$rom_name/$buildScript ]
    then
        cd ~/$rom_name
        /bin/dash $buildScript
    else
        echo "Build script not found, aborting..."
    fi
elif [ $selection = 'n' ]
then 
    echo "Selection was NO. Aborting."
else
    echo "Invalid input, aborting."
fi