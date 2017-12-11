DEPOT_PATH=PATH=$(shell pwd)/depot_tools:${PATH}
BUILD_SCRIPT=sd-build.sh
RUN_SCRIPT=sd-run-bench.sh
# https://omahaproxy.appspot.com/
V8_VERSION=6.3.292.46
DEPOT_TOOLS_VERSION=ad9cc1112183f420639a5767b15cc36959740d37
WARMUP_STATS_VERSION=b03387818bc948de6db3e0447718cfedfd8c662a

all: build-v8 build-warmup-stats tools

.PHONY: build-warmup-stats build-v8

depot_tools:
	git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git
	cd depot_tools && git checkout ${DEPOT_TOOLS_VERSION}

v8: depot_tools
	${DEPOT_PATH} fetch v8
	cd v8 && git checkout ${V8_VERSION}
	${DEPOT_PATH} gclient sync  # rolls back dependencies

tools: v8
	@cp scripts/sd-base.js scripts/sd-run.js scripts/sd-v8.json v8/benchmarks/
	@cp scripts/sd_merge_csv.py scripts/sd_run_perf.py v8/tools/
	@echo "To run the example benchmark, cd to the v8 dir and run ../scripts/${RUN_SCRIPT}"
	@echo "To use fewer process executions, edit the PEXECS variable in scripts/${RUN_SCRIPT}."
	@echo "To use fewer iterations, edit 'run_count' in v8/benchmarks/sd-v8.json."
	@echo "\n"

warmup_stats:
	git clone https://github.com/softdevteam/warmup_stats.git
	cd warmup_stats && git checkout ${WARMUP_STATS_VERSION}

build-warmup-stats: warmup_stats
	cd warmup_stats && ./build.sh

build-v8: v8
	cd v8 && ${DEPOT_PATH} tools/dev/v8gen.py x64.release && \
		${DEPOT_PATH} ninja -C out.gn/x64.release d8

clean:
	rm -rf .gclient* v8 depot_tools warmup_stats
