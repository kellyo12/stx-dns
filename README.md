# STX-DNS Smart Contract

A decentralized domain name service (DNS) system built on the Stacks blockchain using Clarity smart contracts.

## Overview

The `stx-dns` contract allows users to register, manage, transfer, and update domain names entirely on-chain without reliance on centralized DNS providers. Ownership and management of domain names are enforced by the smart contract, providing a censorship-resistant and transparent DNS system.

## Features

-  Domain name registration with unique name enforcement.
-  Ownership management and address binding.
-  Domain transfer functionality.
-  Domain record updates (IP address, metadata, etc).
-  Expiration and renewal system.
-  Squatting prevention through expiration windows.

## Smart Contract Details

- **Contract Name:** `stx-dns`
- **Language:** Clarity (Stacks Smart Contract Language)
- **Blockchain:** Stacks (STX)

## Functions

### Public Functions

- `register-domain (domain-name (buff 32)) (record-data (buff 256))`  
  Register a new domain name with associated data.

- `renew-domain (domain-name (buff 32))`  
  Renew an existing domain before it expires.

- `transfer-domain (domain-name (buff 32)) (new-owner principal)`  
  Transfer ownership of a registered domain.

- `update-record (domain-name (buff 32)) (record-data (buff 256))`  
  Update DNS records (e.g. IP address, content hashes, metadata).

- `get-domain-info (domain-name (buff 32))`  
  Retrieve information about a registered domain.

### Read-Only Functions

- `is-domain-available (domain-name (buff 32))`  
  Check if a domain is available for registration.

- `get-owner (domain-name (buff 32))`  
  Get the owner of a domain.

## Usage

1. Deploy the contract using [Clarinet](https://github.com/hirosystems/clarinet) or the Stacks CLI.
2. Interact with the contract to register domains, update records, transfer ownership, and manage renewals.
3. Build dApps or frontend interfaces that interact with this contract to provide decentralized DNS services.

## Requirements

- Stacks Blockchain
- Clarity Smart Contract Language
- Clarinet for local development and testing

## Development

Clone the repository and install Clarinet:

```bash
git clone https://github.com/your-username/stx-dns.git
cd stx-dns
clarinet check
clarinet test
