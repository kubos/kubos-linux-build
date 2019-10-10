KubOS Release Candidate Test
============================

This project is used to test all of the default Kubos services to verify that a release candidate
is good.

Test Contents
-------------

- run_test.sh - Main test starting point. Builds, installs, and runs a test application. Also tests
  the file and shell clients
- src/main.rs - App main file
- src/app_service.rs - Tests querying the applications service
- src/monitor_sevice.rs - Tests querying the monitor service
- src/telem_service.rs - Tests the telemetry service. Tests queries, routed queries, inserts, and
  deletion

Pre-Requisites
--------------

- Load the release candidate onto an OBC which has an ethernet connection
- Update the OBC's service config file (``/etc/kubos-config.toml``) to set the correct downlink IP
  information::

    [file-transfer-service]
    storage_dir = "/home/system/file-storage"
    downlink_ip = "{host IP}"
    downlink_port = 8080
    
- Restart the file service: ``/etc/init.d/S90kubos-core-file-transfer restart``
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

    1970-01-01T00:11:39.398508+00:00 Kubos release-test[1281]:<info> Current memory available: 496824 kB
    1970-01-01T00:11:39.420550+00:00 Kubos release-test[1281]:<info> PS Response: Object({"ps": Array([Object({"cmd": String("init      "), "gid": Number(0), "grp": String("root"), "mem": Number(2912256), "pid": Number(1), "ppid": Number(0), "rss": Number(356), "state": String("S"), "threads": Number(1), "uid": Number(0), "usr": String("root")}), Object({"cmd": String("kthreadd"), "gid": Number(0), "grp": String("root"), "mem": Number(0), "pid": Number(2), "ppid": Number(0), "rss": Number(0), "state": String("S"), "threads": Number(1), "uid": Number(0), "usr": String("root")}), Object({"cmd": String("ksoftirqd/0"), "gid": Number(0), "grp": String("root"), "mem": Number(0), "pid": Number(3), "ppid": Number(2), "rss": Number(0), "state": String("S"), "threads": Number(1), "uid": Number(0), "usr": String("root")})])})
    1970-01-01T00:11:39.420904+00:00 Kubos release-test[1281]:<info> Monitor Service Test Results: Passed - 2, Failed - 0
    1970-01-01T00:11:39.452770+00:00 Kubos release-test[1281]:<info> Test value saved to database
    1970-01-01T00:11:39.469786+00:00 Kubos release-test[1281]:<info> Query Response: Object({"telemetry": Array([Object({"parameter": String("param"), "subsystem": String("release"), "timestamp": Number(699.430852541), "value": String("value")})])})
    1970-01-01T00:11:39.486181+00:00 Kubos release-test[1281]:<info> Routed query Response: Object({"routedTelemetry": String("/home/kubos/release-test/telem-results.tar.gz")})
    1970-01-01T00:11:39.514802+00:00 Kubos release-test[1281]:<info> Entries deleted: 1
    1970-01-01T00:11:39.515014+00:00 Kubos release-test[1281]:<info> Telemetry DB Service Test Results: Passed - 4, Failed - 0
    1970-01-01T00:11:39.515102+00:00 Kubos release-test[1281]:<info> Querying for active applications
    1970-01-01T00:11:39.530459+00:00 Kubos release-test[1281]:<info> App query result: Object({"appStatus": Array([Object({"name": String("release-test"), "running": Bool(true), "startTime": String("1970-01-01T00:11:39.356796416+00:00"), "version": String("1.0")})]), "registeredApps": Array([Object({"active": Bool(true), "app": Object({"author": String("Catherine Garabedian"), "name": String("release-test"), "version": String("1.0")})})])})
    1970-01-01T00:11:39.530768+00:00 Kubos release-test[1281]:<info> Applications Service Test Results: Passed - 1, Failed - 0

Verification
------------

If all tests completed successfully, the the script should output ``Release Test Completed Successfully``.

If something failed, then the script should output ``Release Test Failed``

The output files may also be examined to double-check that no stray errors were missed.