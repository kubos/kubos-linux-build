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

extern crate chrono;
#[macro_use]
extern crate failure;
#[macro_use]
extern crate kubos_app;

use app_service::*;
use chrono::Utc;
use failure::Error;
use kubos_app::{AppHandler, ServiceConfig};
use monitor_service::*;
use std::fs::OpenOptions;
use std::io::Write;
use std::time::Duration;
use telem_service::*;

struct MyApp;

const TELEMFILE: &str = "/home/kubos/release-test/telem-results";
const LOGFILE: &str = "/home/kubos/release-test/test-output";

macro_rules! log {
    ($log_file:ident, $msg:expr) => {{
        writeln!($log_file, "{}: {}", Utc::now(), $msg).unwrap();
    }};
    ($log_file:ident, $msg:expr, $($arg:tt)*) => {{
        let message = format!($msg, $($arg)*);
        writeln!($log_file, "{}: {}", Utc::now(), message).unwrap();
    }};
}

mod app_service;
mod monitor_service;
mod telem_service;

impl AppHandler for MyApp {
    fn on_boot(&self, _args: Vec<String>) -> Result<(), Error> {
        // Set up the log file
        let mut log_file = OpenOptions::new()
            .create(true)
            .append(true)
            .open(LOGFILE)?;
            
        log!(log_file, "OnBoot logic called");
        
        Ok(())
    }

    fn on_command(&self, _args: Vec<String>) -> Result<(), Error> {
        // Monitor Service Tests
        monitor_test()?;
        
        // Telemetry Service Tests
        telemetry_test()?;

        // App Service Tests
        apps_test()?;
        
        Ok(())
    }
}

fn main() -> Result<(), Error> {
    let app = MyApp;
    app_main!(&app)?;
    
    Ok(())
}
