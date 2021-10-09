from brownie import Project, Projectstarter, config, accounts
 
def deployContract():
    account = accounts.add(config["wallets"]["from_key"]) or accounts[0]
    Projectstarter.deploy({'from': account})
    Projectstarter[0].createProject("testing", "0xcbfe1B8dC5eD5a9f407D7671C3b511e7cc619340", 1633873187, 200000000000000000000, 1639143587, {'from': account})
    
 
def main():
    deployContract()
