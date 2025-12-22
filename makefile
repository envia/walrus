.PHONY: all try clean

all: third_party/GCutil/CMakeLists.txt out/release/x64/build.ninja
	ninja -Cout/release/x64
	ln -s -f ${PWD}/out/release/x64/walrus walrus

try: third_party/GCutil/CMakeLists.txt out/release/x64/build.ninja
	ninja -k0 -Cout/release/x64
	ln -s -f ${PWD}/out/release/x64/walrus walrus

clean:
	rm -rf walrus out/release/x64

third_party/GCutil/CMakeLists.txt:
	git submodule update --init --recursive

out/release/x64/build.ninja:
	cmake -DCMAKE_POLICY_VERSION_MINIMUM=3.5 -H. -Bout/release/x64 -DWALRUS_ARCH=x64 -DWALRUS_HOST=linux -DWALRUS_MODE=release -DWALRUS_OUTPUT=shell -GNinja
