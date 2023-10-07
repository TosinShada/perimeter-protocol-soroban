#![deny(warnings)]
#![no_std]

use soroban_sdk::{contractclient, contractspecfn, contracttype, Address, BytesN, Env};
pub struct Spec;

#[derive(Clone, Debug)]
#[contracttype]
pub struct Record {
    pub owner: Address,
    pub resolver: Address,
    pub ttl: u64,
}

/// Interface for Vault
#[contractspecfn(name = "Spec", export = false)]
#[contractclient(name = "VaultClient")]
pub trait VaultTrait {
    fn initialize(e: Env, admin: Address, resolver: Address);
}
