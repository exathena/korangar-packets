use serde::Deserialize;

#[derive(Debug, Deserialize)]
pub struct PacketsJson {
    pub version: String,
    pub packets: Vec<Packet>,
    pub structs: Vec<Struct>,
    pub inline_structs: Vec<InlineStruct>,
    pub keyless_structs: Vec<KeylessStruct>,
    pub enums: Vec<Enum>,
}

#[derive(Debug, Deserialize)]
pub struct Packet {
    pub id: u32,
    pub name: String,
    pub header: String,
    pub origin: String,
    pub fields: Vec<Field>,
    pub server: String,
    pub kind: String,
}

#[derive(Debug, Deserialize)]
pub struct Field {
    pub id: u32,
    pub name: String,
    pub field_type: FieldType,
    pub kind: String,
}

#[derive(Debug, Deserialize)]
pub enum FieldType {
    Array { length: u32, of: Box<FieldType> },
    Box { id: u32, of: Box<FieldType> },
    Generic(String),
    Primitive(String),
    Struct { name: String },
    Vec { id: u32, of: Box<FieldType> },
}

#[derive(Debug, Deserialize)]
pub struct Struct {
    pub id: u32,
    pub name: String,
    pub fields: Vec<Field>,
}

#[derive(Debug, Deserialize)]
pub struct InlineStruct {
    pub id: u32,
    pub name: String,
    pub args: Vec<Field>,
}

#[derive(Debug, Deserialize)]
pub struct KeylessStruct {
    pub id: u32,
    pub name: String,
}

#[derive(Debug, Deserialize)]
pub struct Enum {
    pub id: u32,
    pub name: String,
    pub values: Vec<Variant>,
    pub kind: String,
}

#[derive(Debug, Deserialize)]
pub struct Variant {
    pub id: u32,
    pub name: String,
    pub value: VariantValue,
    pub kind: String,
}

#[derive(Debug, Deserialize)]
pub enum VariantValue {
    Literal(String),
    Tuple(Vec<Field>),
    Struct(Vec<Field>),
}
