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
use kubos_app::query;

pub fn apps_test() -> Result<(), Error> {
    let mut passed = 0;
    let mut failed = 0;
    
    match get_apps() {
        Ok(()) => passed += 1,
        Err(_) => failed += 1,
    }

    info!("Applications Service Test Results: Passed - {}, Failed - {}", passed, failed);
    
    Ok(())
}

fn get_apps() -> Result<(), Error> {
    info!("Querying for active applications");

    let request = r#"{
        registeredApps {
            active,
            app {
                name,
                version,
                author
            }
        },
        appStatus {
            name,
            version,
            startTime,
            running
        }
    }"#;

    match query(
        &ServiceConfig::new("app-service")?,
        request,
        Some(Duration::from_secs(1)),
    ) {
        Ok(msg) => {
            info!("App query result: {:?}", msg);
            Ok(())
        }
        Err(err) => {
            error!("App service query failed: {}", err);
            bail!("App service query failed")
        }
    }
}
