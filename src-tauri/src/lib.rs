use std::fs;
use std::path::PathBuf;

const RECOVERY_FILE_NAME: &str = ".ottermark-recovery";

/// Get the path to the recovery file in the temp directory
fn get_recovery_file_path() -> Result<PathBuf, String> {
    let temp_dir = std::env::temp_dir();
    Ok(temp_dir.join(RECOVERY_FILE_NAME))
}

/// Write content to the recovery file
#[tauri::command]
fn write_recovery_file(content: String) -> Result<(), String> {
    let path = get_recovery_file_path()?;
    fs::write(&path, content).map_err(|e| format!("Failed to write recovery file: {}", e))?;
    Ok(())
}

/// Read content from the recovery file
#[tauri::command]
fn read_recovery_file() -> Result<String, String> {
    let path = get_recovery_file_path()?;
    fs::read_to_string(&path).map_err(|e| format!("Failed to read recovery file: {}", e))
}

/// Check if the recovery file exists
#[tauri::command]
fn recovery_exists() -> Result<bool, String> {
    let path = get_recovery_file_path()?;
    Ok(path.exists())
}

/// Delete the recovery file
#[tauri::command]
fn delete_recovery_file() -> Result<(), String> {
    let path = get_recovery_file_path()?;
    if path.exists() {
        fs::remove_file(&path).map_err(|e| format!("Failed to delete recovery file: {}", e))?;
    }
    Ok(())
}

#[cfg_attr(mobile, tauri::mobile_entry_point)]
pub fn run() {
    tauri::Builder::default()
        .plugin(tauri_plugin_opener::init())
        .plugin(tauri_plugin_dialog::init())
        .plugin(tauri_plugin_fs::init())
        .invoke_handler(tauri::generate_handler![
            write_recovery_file,
            read_recovery_file,
            recovery_exists,
            delete_recovery_file
        ])
        .build(tauri::generate_context!())
        .expect("error while building tauri application")
        .run(|_app, event| {
            if let tauri::RunEvent::Exit = event {
                if let Ok(path) = get_recovery_file_path() {
                    let _ = fs::remove_file(path);
                }
            }
        });
}
