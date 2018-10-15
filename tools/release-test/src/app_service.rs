use super::*;
use failure::Error;
use kubos_app::query;

pub fn apps_test() -> Result<(), Error> {
    get_apps()?;
    
    Ok(())
}

fn get_apps() -> Result<(), Error> {
    // Set up the log file
    let mut log_file = OpenOptions::new()
        .create(true)
        .append(true)
        .open(LOGFILE)
        .unwrap();

    log!(log_file, "Querying for active applications");

    let request = r#"{
        apps {
            active,
            app {
                uuid,
                name,
                version,
                author
            }
        }
    }"#;

    match query(
        ServiceConfig::new("app-service"),
        request,
        Some(Duration::from_secs(1)),
    ) {
        Ok(msg) => {
            log!(log_file, "App query result: {:?}", msg);
            Ok(())
        }
        Err(err) => {
            log!(log_file, "App service query failed: {}", err);
            bail!("App service query failed")
        }
    }
}
