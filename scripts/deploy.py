from brownie import CampaignBalance, config, accounts
 
def deployContract():
    account = accounts.add(config["wallets"]["from_key"]) or accounts[0]
    CampaignBalance.deploy({'from': account})
 
def main():
    deployContract()
