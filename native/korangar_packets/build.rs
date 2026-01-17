use quote::format_ident;
use quote::quote;
use std::env;
use std::fs;
use std::io::Write;
use std::path::{Path, PathBuf};

// keep the ast in a separated file
const CARGO_MANIFEST_DIR: &str = env!("CARGO_MANIFEST_DIR");
include!(concat!(env!("CARGO_MANIFEST_DIR"), "/ast.rs"));

fn to_rust_type(field_type: &FieldType) -> String {
    match field_type {
        FieldType::Array { length: _, of: _ } => {
            unimplemented!();
        }
        FieldType::Box { id: _, of: _ } => {
            unimplemented!();
        }
        FieldType::Generic(_) => {
            unimplemented!();
        }
        FieldType::Primitive(_) => {
            unimplemented!();
        }
        FieldType::Struct { name: _ } => {
            unimplemented!();
        }
        FieldType::Vec { id: _, of: _ } => {
            unimplemented!();
        }
    }
}

fn read_ast_from_json() -> Result<PacketsJson, serde_json::Error> {
    let json_path = Path::new(CARGO_MANIFEST_DIR).join("../../priv/packets.json");

    let json_content = match fs::read_to_string(&json_path) {
        Ok(content) => content,
        Err(error) => panic!("Could not read packets.json: {}", error),
    };

    serde_json::from_str(&json_content)
}

fn main() {
    // rerun if some files changes
    println!("cargo:rerun-if-changed=ast.rs");

    let packets_json: PacketsJson = match read_ast_from_json() {
        Ok(content) => content,
        Err(error) => panic!("Could not read ast from json: {}", error),
    };

    let dest_dir = Path::new(CARGO_MANIFEST_DIR).join("src/packets");

    if !dest_dir.exists() {
        fs::create_dir(&dest_dir).expect("Could not create directory");
    }

    for struct_ in &packets_json.structs {
        let rust_name = format_ident!("{}", struct_.name);
        let rustler_name = format_ident!("Ex{}", struct_.name);

        let code = quote! {
            #[derive(rustler::NifStruct)]
            #[module = "Elixir.YourModule"]
            pub struct #rustler_name {
                // #(...),*
            }

            impl From<external_crate::#rust_name> for #rustler_name {
                fn from(value: external_crate::#rust_name) -> Self {
                    // conversion here
                }
            }
        };

        let _ = write_module("structs.rs", &dest_dir, code.to_string());
    }
}
