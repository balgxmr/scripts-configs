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
    echo "(y/n)"
    read x
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

echo "Cloning Device tree"
# git clone https://github.com/balgxmr/device_xiaomi_cepheus/ -b thirteen device/xiaomi/cepheus
git clone https://github.com/PixelOS-Devices/device_xiaomi_cepheus/ -b thirteen device/xiaomi/cepheus

echo "Cloning Kernel tree"
git clone https://github.com/balgxmr/kernel_xiaomi_cepheus/ -b thirteen kernel/xiaomi/cepheus

echo "Cloning Vendor tree"
git clone https://github.com/PixelOS-Devices/vendor_xiaomi_cepheus -b thirteen vendor/xiaomi/cepheus

echo "Cloning Hw/xiaomi"
git clone https://github.com/balgxmr/android_hardware_xiaomi -b lineage-20 hardware/xiaomi

echo "Cloning Clang"
git clone https://gitlab.com/Panchajanya1999/azure-clang -b main prebuilts/clang/host/linux-x86/clang-azure --depth=1

echo "Cloning Hals"
git clone https://github.com/balgxmr/hardware_qcom-caf_sm8150_audio.git -b thirteen hardware/qcom-caf/sm8150/audio
git clone https://github.com/balgxmr/hardware_qcom-caf_sm8150_media.git -b thirteen hardware/qcom-caf/sm8150/media
git clone https://github.com/balgxmr/hardware_qcom-caf_sm8150_display.git -b thirteen hardware/qcom-caf/sm8150/display

echo "Cloning Devicesettings"
git clone https://github.com/xiaomi-cepheus/packages_resources_devicesettings -b twelve packages/resources/devicesettings

echo "Cloning Miui Camera"
git clone https://gitlab.com/baalgx/vendor_xiaomi_cepheus-miuicamera -b master vendor/xiaomi/cepheus-miuicamera

echo "============ Finished ============"
echo

echo "Wanna execute rom build script? It must be in ~/$rom_name path."
echo "(y/n)"
read selection

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