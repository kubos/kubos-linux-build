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

    1970-01-01 00:18:42.653402675 UTC: Current memory available: 499188 kB
    1970-01-01 00:18:42.663339508 UTC: PS Response: Object({"ps": Array([Object({"cmd": String("init      "), "gid": Number(0), "grp": String("root"), "mem": Number(2854912), "pid": Number(1), "ppid"
    : Number(0), "rss": Number(337), "state": String("S"), "threads": Number(1), "uid": Number(0), "usr": String("root")}), Object({"cmd": String("kthreadd"), "gid": Number(0), "grp": String("root"),
     "mem": Number(0), "pid": Number(2), "ppid": Number(0), "rss": Number(0), "state": String("S"), "threads": Number(1), "uid": Number(0), "usr": String("root")}), Object({"cmd": String("ksoftirqd/0
    "), "gid": Number(0), "grp": String("root"), "mem": Number(0), "pid": Number(3), "ppid": Number(2), "rss": Number(0), "state": String("R"), "threads": Number(1), "uid": Number(0), "usr": String("
    root")})])})
    1970-01-01 00:18:42.663703258 UTC: Monitor Service Test Results: Passed - 2, Failed - 0
    1970-01-01 00:18:42.682024258 UTC: Test value saved to database
    1970-01-01 00:18:42.685113550 UTC: Query Response: Object({"telemetry": Array([Object({"parameter": String("param"), "subsystem": String("release"), "timestamp": Number(1122665), "value": String(
    "value")})])})
    1970-01-01 00:18:42.689354300 UTC: Routed query Response: Object({"routedTelemetry": String("/home/kubos/release-test/telem-results.tar.gz")})
    1970-01-01 00:18:42.703139425 UTC: Entries deleted: 1
    1970-01-01 00:18:42.703498467 UTC: Telemetry DB Service Test Results: Passed - 4, Failed - 0
    1970-01-01 00:18:42.703696633 UTC: Querying for active applications
    1970-01-01 00:18:42.706457008 UTC: App query result: Object({"apps": Array([Object({"active": Bool(false), "app": Object({"author": String("Catherine Garabedian"), "name": String("release-test"),
     "uuid": String("e2fc59d7-2413-4f12-8957-80a98c6128c9"), "version": String("1.0")})}), Object({"active": Bool(true), "app": Object({"author": String("Catherine Garabedian"), "name": String("relea
    se-test"), "uuid": String("e2fc59d7-2413-4f12-8957-80a98c6128c9"), "version": String("1.0")})})])})
    1970-01-01 00:18:42.706841925 UTC: Applications Service Test Results: Passed - 1, Failed - 0

Verification
------------

If all tests completed successfully, the the script should output ``Release Test Completed Successfully``.

If something failed, then the script should output ``Release Test Failed``

The output files may also be examined to double-check that no stray errors were missed.