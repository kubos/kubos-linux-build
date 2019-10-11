/*
 * Copyright (C) 2019 Kubos Corporation
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

use super::*;
use failure::{bail, Error};
use log::{info, error};

pub fn monitor_test() -> Result<(), Error> {
    let mut passed = 0;
    let mut failed = 0;
    
    match get_mem() {
        Ok(()) => passed += 1,
        Err(_) => failed += 1,
    }
    match get_ps() {
        Ok(()) => passed += 1,
        Err(_) => failed += 1,
    }

    info!("Monitor Service Test Results: Passed - {}, Failed - {}", passed, failed);
    
    Ok(())
}

fn get_mem() -> Result<(), Error> {

    let request = "{memInfo{available, total, free, lowFree}}";

    let response = match query(
        &ServiceConfig::new("monitor-service")?,
        request,
        Some(Duration::from_secs(1)),
    ) {
        Ok(msg) => msg,
        Err(err) => {
            error!("MemInfo query failed: {}", err);
            bail!("MemInfo query failed");
        }
    };

    match response
        .get("memInfo")
        .and_then(|msg| msg.get("available"))
        .and_then(|val| val.as_u64())
    {
        Some(mem) => info!("Current memory available: {} kB", mem),
        None => {
            error!("Failed to get available mem");
            bail!("Failed to get available mem")
        }
    }
    
    Ok(())
}

fn get_ps() -> Result<(), Error> {

    let request = r#"{
        ps(pids: [1, 2, 3]) {
            pid,
            uid,
            gid,
            usr,
            grp,
            state,
            ppid,
            mem,
            rss,
            threads,
            cmd
        }
    }"#;

    match query(
        &ServiceConfig::new("monitor-service")?,
        request,
        Some(Duration::from_secs(1)),
    ) {
        Ok(msg) => info!("PS Response: {:?}", msg),
        Err(err) => {
            error!("PS query failed: {}", err);
            bail!("PS query failed");
        }
    }
    
    Ok(())
}