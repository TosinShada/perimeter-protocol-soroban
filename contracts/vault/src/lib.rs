#![deny(warnings)]
#![no_std]
use core::panic;

use vault_interface::vault::{Record, VaultTrait};
use soroban_sdk::{contract, contractimpl, contracttype, Address, Bytes, BytesN, Env};

mod events;
mod test;
mod testutils;

pub(crate) const HIGH_BUMP_AMOUNT: u32 = 518400; // 30 days
pub(crate) const LOW_BUMP_AMOUNT: u32 = 518400; // 30 days

#[derive(Clone)]
#[contracttype]
pub enum DataKey {
    // () => Admin Address
    Admin,
}

#[contract]
pub struct Vault;

#[contractimpl]
#[allow(clippy::needless_pass_by_value)]
impl VaultTrait for Vault {
    fn initialize(e: Env, admin: Address, resolver: Address) {
        if has_administrator(&e) {
            panic!("already initialized")
        }
        set_administrator(&e, &admin);
        set_default_resolver(&e, &resolver)
    }
}

/*
Getter Functions
*/
fn get_administrator(e: &Env) -> Address {
    e.storage()
        .persistent()
        .get::<_, Address>(&DataKey::Admin)
        .unwrap()
}

fn has_administrator(e: &Env) -> bool {
    e.storage().persistent().has(&DataKey::Admin)
}

/*
Modifiers for the contract
*/
fn require_node_authorised(e: &Env, node: &BytesN<32>, caller: &Address) {
    let record = get_record_by_node(e, node);
    assert!(
        record.owner == *caller || is_operator_approved(e, &record.owner, caller),
        "caller is not authorised"
    );
}

/*
State Changing Functions
*/
fn set_administrator(e: &Env, caller: &Address) {
    e.storage().persistent().set(&DataKey::Admin, caller);
    e.storage()
        .persistent()
        .bump(&DataKey::Admin, LOW_BUMP_AMOUNT, HIGH_BUMP_AMOUNT);
}
