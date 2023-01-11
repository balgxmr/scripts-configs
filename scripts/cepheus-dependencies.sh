#! /bin/sh
#
# balgxmr's cepheus dependencies script
# 
# rem: Current path is ~/Documents/SW

cd ../.. || exit 1
cd pixelos/ || exit 1

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
