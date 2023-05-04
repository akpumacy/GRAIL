import xrpl
import os, json
from xrpl.wallet import Wallet

testnet_url = "https://s.altnet.rippletest.net:51234"
client = xrpl.clients.JsonRpcClient(testnet_url)

#-------- load cold wallet
if os.path.exists("cold_address.json"):
    with open('cold_address.json', 'r') as openfile:
        json_object = json.load(openfile)
cold_wallet = Wallet(seed=json_object['seed'],sequence=json_object['sequence'])

#-------- load sender wallet
sender_acc = "account_1.json"
if os.path.exists(sender_acc):
    with open(sender_acc, 'r') as openfile:
        json_object = json.load(openfile)
sender_wallet = Wallet(seed=json_object['seed'],sequence=json_object['sequence'])

#-------- load receiver wallet
sender_acc = "account_2.json"
if os.path.exists(sender_acc):
    with open(sender_acc, 'r') as openfile:
        json_object = json.load(openfile)
receiver_wallet = Wallet(seed=json_object['seed'],sequence=json_object['sequence'])

# Send token -------------------------------------------------------------------
currency_code = "RED"
issue_quantity = "45"
send_token_tx = xrpl.models.transactions.Payment(
    account=sender_wallet.classic_address,
    destination=receiver_wallet.classic_address,
    amount=xrpl.models.amounts.issued_currency_amount.IssuedCurrencyAmount(
        currency=currency_code,
        issuer=cold_wallet.classic_address,
        value=issue_quantity
    )
)
pay_prepared = xrpl.transaction.safe_sign_and_autofill_transaction(
    transaction=send_token_tx,
    wallet=sender_wallet,
    client=client,
)
print(f"Sending {issue_quantity} {currency_code} to {receiver_wallet.classic_address}...")
response = xrpl.transaction.send_reliable_submission(pay_prepared, client)
print(response)