/*
 * Copyright (C) 2018 Kubos Corporation
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
use failure::Error;
use kubos_app::query;

pub fn telemetry_test() -> Result<(), Error> {
    let mut passed = 0;
    let mut failed = 0;
    
    match insert() {
        Ok(()) => passed += 1,
        Err(_) => failed += 1,
    }
    
    match normal_query() {
        Ok(()) => passed += 1,
        Err(_) => failed += 1,
    }
    match routed_query() {
        Ok(()) => passed += 1,
        Err(_) => failed += 1,
    }
    
    match delete() {
        Ok(()) => passed += 1,
        Err(_) => failed += 1,
    }
    
    let mut log_file = OpenOptions::new()
        .create(true)
        .append(true)
        .open(LOGFILE)
        .unwrap();
    
    log!(log_file, "Telemetry DB Service Test Results: Passed - {}, Failed - {}", passed, failed);
    
    Ok(())
}

pub fn insert() -> Result<(), Error> {
    let mut log_file = OpenOptions::new()
        .create(true)
        .append(true)
        .open(LOGFILE)
        .unwrap();

    let request = r#"
        mutation {
            insert(subsystem: "release", parameter: "param", value: "value") {
                success,
                errors
            }
        }
    "#;

    match query(
        ServiceConfig::new("telemetry-service"),
        &request,
        Some(Duration::from_secs(1)),
    ) {
        Ok(msg) => {
            let data = match msg.get("insert"){
                Some(val) => val,
                None => bail!("Failed to get insert response"),  
            };
            
            let success = data.get("success").and_then(|val| val.as_bool());

            if success == Some(true) {
                log!(log_file, "Test value saved to database");
            } else {
                match msg.get("errors") {
                    Some(errors) => log!(log_file, "Failed to save value to database: {}", errors),
                    None => log!(log_file, "Failed to save value to database"),
                }
                
                bail!("Failed to save value to database");
            }
        }
        Err(err) => {
            log!(log_file, "Insert mutation failed: {}", err);
            bail!("Insert mutation failed")
        }
    }

    Ok(())
}

pub fn normal_query() -> Result<(), Error> {
    let mut log_file = OpenOptions::new()
    .create(true)
    .append(true)
    .open(LOGFILE)
    .unwrap();
    
    let request = r#"{
        telemetry(subsystem: "release") {
            timestamp,
            subsystem,
            parameter,
            value
        }
    }"#;

    match query(
        ServiceConfig::new("telemetry-service"),
        request,
        Some(Duration::from_secs(1)),
    ) {
        Ok(msg) => log!(log_file, "Query Response: {:?}", msg),
        Err(err) => {
            log!(log_file, "Telemetry query failed: {}", err);
            bail!("Telemetry query failed");
        }
    }
    
    Ok(())
}

pub fn routed_query() -> Result<(), Error> {
    let mut log_file = OpenOptions::new()
    .create(true)
    .append(true)
    .open(LOGFILE)
    .unwrap();
    
    let request = format!(r#"{{
        routedTelemetry(subsystem: "release", output: "{}")
    }}"#,
        TELEMFILE
    );

    match query(
        ServiceConfig::new("telemetry-service"),
        &request,
        Some(Duration::from_secs(1)),
    ) {
        Ok(msg) => log!(log_file, "Routed query Response: {:?}", msg),
        Err(err) => {
            log!(log_file, "Telemetry query failed: {}", err);
            bail!("Telemetry query failed");
        }
    }
    
    Ok(())
}

pub fn delete() -> Result<(), Error> {
    let mut log_file = OpenOptions::new()
    .create(true)
    .append(true)
    .open(LOGFILE)
    .unwrap();
    
    let request = r#"
        mutation {
            delete(subsystem: "release") {
                success,
                errors,
                entriesDeleted
            }
        }
    "#;

    match query(
        ServiceConfig::new("telemetry-service"),
        request,
        Some(Duration::from_secs(1)),
    ) {
        Ok(msg) => {
            let data = match msg.get("delete"){
                Some(val) => val,
                None => bail!("Failed to get delete response"),  
            };
            let success = data.get("success").and_then(|val| val.as_bool());

            if success == Some(true) {
                match data.get("entriesDeleted").and_then(|val| val.as_u64()){
                    Some(entries) => log!(log_file, "Entries deleted: {}", entries),
                    None => {
                        log!(log_file, "Failed to get entriesDeleted");
                        bail!("Failed to get entriesDeleted");
                    }
                }
            } else {
                match msg.get("errors") {
                    Some(errors) => log!(log_file, "Failed clean database: {}", errors),
                    None => log!(log_file, "Failed clean database"),
                }
                
                bail!("Failed to clean database");
            }
        }
        Err(err) => {
            log!(log_file, "Delete mutation failed: {}", err);
            bail!("Delete mutation failed")
        }
    }

    Ok(())
}