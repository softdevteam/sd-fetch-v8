// Copyright 2008 the V8 project authors. All rights reserved.
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are
// met:
//
//     * Redistributions of source code must retain the above copyright
//       notice, this list of conditions and the following disclaimer.
//     * Redistributions in binary form must reproduce the above
//       copyright notice, this list of conditions and the following
//       disclaimer in the documentation and/or other materials provided
//       with the distribution.
//     * Neither the name of Google Inc. nor the names of its
//       contributors may be used to endorse or promote products derived
//       from this software without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
// "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
// LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
// A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
// OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
// SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
// LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
// DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
// THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
// OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


load('sd-base.js');
load('richards.js');
load('deltablue.js');
load('raytrace.js');
load('regexp.js');
load('splay.js');
load('navier-stokes.js');

function main() {
  var suites = BenchmarkSuite.suites;
  var inner_iterations = {};
  inner_iterations["Richards"] = 8200;
  inner_iterations["DeltaBlue"] = 4400;
  inner_iterations["RayTrace"] = 600;
  inner_iterations["RegExp"] = 50;
  inner_iterations["Splay"] = 1400;
  inner_iterations["NavierStokes"] = 180;

  // Pre-allocate array here, so that we don't grow the memory footprint
  // of this runner whilst benchmarking.
  var num_results = 0;
  for (var i = 0; i < suites.length; i++) {
    var suite = suites[i];
    var benchmarks = suite.benchmarks;
    for (var j = 0; j < benchmarks.length; j++) {
      var benchmark = benchmarks[j];
      for (var k = 0; k < 1; k++) {
        num_results += 1;
      }
    }
  }
  // Run the benchmarks.
  var results = new Array(num_results);
  for (var i = 0; i < suites.length; i++) {
    var suite = suites[i];
    var benchmarks = suite.benchmarks;
    for (var j = 0; j < benchmarks.length; j++) {
      var benchmark = benchmarks[j];
      for (var k = 0; k < 1; k++) {
        BenchmarkSuite.ResetRNG();
        benchmark.Setup();
        var start = performance.now();
        // Octane benchmarks consist of a (generally fast) "inner" iteration;
        // each benchmark then says "running me for
        // benchmark.deterministicIterations times makes for an outer
        // iteration". We only care about the outer iterations.
        for (var l = 0; l < inner_iterations[benchmark.name]; l++) {
            benchmark.run();
        }
        var elapsed = (performance.now() - start) / 1000.0;
        results[i + j] = elapsed;
        print(benchmark.name + ': ' + elapsed);
        benchmark.TearDown();
      }
    }
  }
}


main();
