use super::*;
use failure::Error;
use kubos_app::query;

pub fn telemetry_test() -> Result<(), Error> {
    insert()?;
    
    normal_query()?;
    routed_query()?;
    
    delete()?;
    
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