KubOS Release Candidate Test
============================

This project is used to test all of the default Kubos services to verify that a release candidate
is good.

Pre-Requisites
--------------

- Load the release candidate onto an OBC which has an ethernet connection
- Script must be run from this directory from within an instance of the Kubos SDK

.. note::

    The test script is currently configured to run on either a Beaglebone Black or a Pumpkin MBM2.
    If support for another OBC is added in the future, the script will need to be updated to support
    a configurable target/toolchain.

Usage
-----

::
    ./run-test.sh ip-addr
    
    - ip-addr: IP address of the OBC which is running the release candidate
    
Output
------

After running the ``run-test.sh`` script, there should be three new files:

    - telem-results.tar.gz - The compressed file with the results of the ``routedTelemetry`` test
    - telem-results - The uncompressed version of the same file
    - test-output - The logging output of the tests

The `telem-results` file should have a single line which looks like this::

    [{"timestamp":4705691,"subsystem":"release","parameter":"param","value":"value"}]
    
The `test-output` file should have quite a few lines which look like this::

    2018-12-20T00:58:49.494360+00:00 Kubos rust-mission-app[602]:<info> Current memory available: 495680 kB
    2018-12-20T00:58:49.504938+00:00 Kubos rust-mission-app[602]:<info> PS Response: Object({"ps": Array([Object({"cmd": String("init      "), "gid": Number(0), "grp": String(
    "root"), "mem": Number(2863104), "pid": Number(1), "ppid": Number(0), "rss": Number(320), "state": String("S"), "threads": Number(1), "uid": Number(0), "usr": String("root
    ")}), Object({"cmd": String("kthreadd"), "gid": Number(0), "grp": String("root"), "mem": Number(0), "pid": Number(2), "ppid": Number(0), "rss": Number(0), "state": String(
    "S"), "threads": Number(1), "uid": Number(0), "usr": String("root")}), Object({"cmd": String("ksoftirqd/0"), "gid": Number(0), "grp": String("root"), "mem": Number(0), "pi
    d": Number(3), "ppid": Number(2), "rss": Number(0), "state": String("R"), "threads": Number(1), "uid": Number(0), "usr": String("root")})])})
    2018-12-20T00:58:49.506157+00:00 Kubos rust-mission-app[602]:<info> Monitor Service Test Results: Passed - 2, Failed - 0
    2018-12-20T00:58:49.524911+00:00 Kubos rust-mission-app[602]:<info> Test value saved to database
    2018-12-20T00:58:49.529381+00:00 Kubos rust-mission-app[602]:<info> Query Response: Object({"telemetry": Array([Object({"parameter": String("param"), "subsystem": String("
    release"), "timestamp": Number(1545267529.5085287), "value": String("value")})])})
    2018-12-20T00:58:49.534371+00:00 Kubos rust-mission-app[602]:<info> Routed query Response: Object({"routedTelemetry": String("/home/kubos/release-test/telem-results.tar.gz
    ")})
    2018-12-20T00:58:49.551377+00:00 Kubos rust-mission-app[602]:<info> Entries deleted: 1
    2018-12-20T00:58:49.552118+00:00 Kubos rust-mission-app[602]:<info> Telemetry DB Service Test Results: Passed - 4, Failed - 0
    2018-12-20T00:58:49.552554+00:00 Kubos rust-mission-app[602]:<info> Querying for active applications
    2018-12-20T00:58:49.556063+00:00 Kubos rust-mission-app[602]:<info> App query result: Object({"apps": Array([Object({"active": Bool(true), "app": Object({"author": String(
    "Catherine Garabedian"), "name": String("release-test"), "uuid": String("ff9ac352-4479-4605-9bbd-ea895e18f8b8"), "version": String("1.0")})})])})
    2018-12-20T00:58:49.556801+00:00 Kubos rust-mission-app[602]:<info> Applications Service Test Results: Passed - 1, Failed - 0

Verification
------------

If all tests completed successfully, the the script should output ``Release Test Completed Successfully``.

If something failed, then the script should output ``Release Test Failed``

The output files may also be examined to double-check that no stray errors were missed.