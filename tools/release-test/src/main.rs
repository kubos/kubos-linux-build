extern crate chrono;
#[macro_use]
extern crate failure;
#[macro_use]
extern crate kubos_app;

use app_service::*;
use chrono::Utc;
use kubos_app::{AppHandler, ServiceConfig};
use monitor_service::*;
use std::fs::OpenOptions;
use std::io::Write;
use std::thread;
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
    fn on_boot(&self, _args: Vec<String>) {
        loop {
            // Set up the log file
            let mut log_file = OpenOptions::new()
                .create(true)
                .append(true)
                .open(LOGFILE)
                .unwrap();
                
            log!(log_file, "OnBoot logic called");
            
            thread::sleep(Duration::from_secs(300));
        }
    }

    fn on_command(&self, _args: Vec<String>) {
        // Monitor Service Tests
        monitor_test().unwrap();
        
        // Telemetry Service Tests
        telemetry_test().unwrap();

        // App Service Tests
        apps_test().unwrap();
    }
}

fn main() {
    let app = MyApp;
    app_main!(&app);
}
