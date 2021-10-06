from brownie import Project, Projectstarter, config, accounts
 
def deployContract():
    account = accounts.add(config["wallets"]["from_key"]) or accounts[0]
    Projectstarter.deploy({'from': account})
 
def main():
    deployContract()
