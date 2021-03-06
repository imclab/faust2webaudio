#!/bin/bash
# tputcolors

# Adapted From https://gist.github.com/camupod/5640386
set -e
echo 'Compiling From Faust -> CPP'
faust -a minimal.cpp -i -uim -cn Freeverb  dsp/freeverb.dsp -o cpp/faust-freeverb.cpp
echo " $(tput setaf 2)Complete$(tput sgr0)"
echo "Wrapping dat cpp"
sed -e "s/DSP/FREEVERB/g" -e "s/Dsp/Freeverb/g" -e "s/dsp/freeverb/g" cpp/faust-wrapper.cpp >> cpp/faust-freeverb.cpp
echo " $(tput setaf 2)Complete$(tput sgr0)"
echo "Using emscripten to compile to JavaScript"
emcc -O2 cpp/faust-freeverb.cpp -o js/faust-freeverb-temp.js \
-s EXPORTED_FUNCTIONS="['_FREEVERB_constructor','_FREEVERB_destructor','_FREEVERB_compute', '_FREEVERB_getNumInputs', '_FREEVERB_getNumOutputs', '_FREEVERB_getNumParams', '_FREEVERB_getNextParam']"
echo " $(tput setaf 2)Complete$(tput sgr0)"
echo "Wrapping js"
cat js/header.js > js/faust-freeverb.js
cat js/faust-freeverb-temp.js >> js/faust-freeverb.js
rm js/faust-freeverb-temp.js
sed -e "s/DSP/FREEVERB/g" -e "s/dsp/freeverb/g" js/wrapper.js >> js/faust-freeverb.js
echo " $(tput setaf 2)Complete$(tput sgr0)"