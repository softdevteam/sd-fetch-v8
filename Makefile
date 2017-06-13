DEPOT_PATH=PATH=$(shell pwd)/depot_tools:${PATH}

all: v8/sd-build.sh v8/sd-run-bench.sh

depot_tools:
	git submodule init  # in case the user didn't clone with --recursive

v8: depot_tools
	${DEPOT_PATH} gclient sync

sd-branch: v8
	cd v8 && \
		git checkout sd-master && \
		${DEPOT_PATH} gclient sync

v8/sd-build.sh: sd-branch
	@echo "#!/bin/sh" > $@
	@echo "${DEPOT_PATH} tools/dev/v8gen.py x64.release" >> $@
	@echo "${DEPOT_PATH} ninja -C out.gn/x64.release d8" >> $@
	@chmod +x $@
	@echo "\n\n-------- soft-dev specific info --------"
	@echo "\nTo build d8 enter the 'v8' dir and run $@"

v8/sd-run-bench.sh: sd-branch
	@echo "#!/bin/sh" > $@
	@echo "tools/run_perf.py --arch x64 --binary-override-path out.gn/x64.release/d8 --buildbot test/js-perf-test/RegExp.json" >> $@
	@chmod +x $@
	@echo "\nTo run the example benchmark, enter the 'v8' dir and run $@"
