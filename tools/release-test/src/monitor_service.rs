use super::*;
use failure::Error;
use kubos_app::*;

pub fn monitor_test() -> Result<(), Error> {
    get_mem()?;
    get_ps()?;
    
    Ok(())
}

fn get_mem() -> Result<(), Error> {
    let mut log_file = OpenOptions::new()
        .create(true)
        .append(true)
        .open(LOGFILE)
        .unwrap();
    
    let request = "{memInfo{available, total, free, lowFree}}";

    let response = match query(
        ServiceConfig::new("monitor-service"),
        request,
        Some(Duration::from_secs(1)),
    ) {
        Ok(msg) => msg,
        Err(err) => {
            log!(log_file, "MemInfo query failed: {}", err);
            bail!("MemInfo query failed");
        }
    };

    match response
        .get("memInfo")
        .and_then(|msg| msg.get("available"))
        .and_then(|val| val.as_u64())
    {
        Some(mem) => log!(log_file, "Current memory available: {} kB", mem),
        None => {
            log!(log_file, "Failed to get available mem");
            bail!("Failed to get available mem")
        }
    }
    
    Ok(())
}

fn get_ps() -> Result<(), Error> {
        let mut log_file = OpenOptions::new()
        .create(true)
        .append(true)
        .open(LOGFILE)
        .unwrap();
    
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
        ServiceConfig::new("monitor-service"),
        request,
        Some(Duration::from_secs(1)),
    ) {
        Ok(msg) => log!(log_file, "PS Response: {:?}", msg),
        Err(err) => {
            log!(log_file, "PS query failed: {}", err);
            bail!("PS query failed");
        }
    }
    
    Ok(())
}