const xrpl = require('xrpl')
const client = new xrpl.Client("wss://s.altnet.rippletest.net:51233")

const dotenv = require('dotenv')
dotenv.config({ path: `H:/Pumacy/Programs/redimi/XRP/GRAIL/3_GRAIL Use Case/.env`, override: true });

const issuer_wallet_seed = process.env.ISSUER_WALLET_SEED
const customer_wallet_seed = "sEdS1kJ7iMwzFNrhU3UVsDJSzqEr5iz"
//const token = process.env.GRAIL_TOKEN
const token = "RED"

async function main() {
    try{
        await client.connect()

        console.log("client connected")

        //----- load issuer wallet
        const issuer_wallet = xrpl.Wallet.fromSeed(issuer_wallet_seed) // Test secret; don't use for real
        console.log(`Issuer Wallet Address: ${issuer_wallet.address}`)
        const my_balance = await client.getXrpBalance(issuer_wallet.address)
        console.log(`Issuer Wallet XRP Balance: ${my_balance}`);

        const account_info = await client.request({
            command: "account_info",
            account: issuer_wallet.address
            });
        //console.log(account_info.result)

        const cold_balances = await client.request({
            command: "account_lines",
            account: issuer_wallet.address,
            ledger_index: "validated"
          })
        //console.log(cold_balances.result)

        const n_lines = cold_balances.result.lines.length
        const reserve_xrp = 10+(n_lines*2)
        console.log(`Issuer Reserve: ${reserve_xrp}`)
        const curr_xrp = xrpl.dropsToXrp(account_info.result.account_data.Balance.toString())
        console.log(`Issuer Current XRP: ${curr_xrp}`)

        //----- load customer wallet
        const customer_wallet = xrpl.Wallet.fromSeed(customer_wallet_seed) // Test secret; don't use for real
        console.log(`Customer Wallet Address: ${customer_wallet.address}`)
        const customer_balance = await client.getXrpBalance(customer_wallet.address)
        console.log(`Customer Wallet XRP Balance: ${customer_balance}`);

        // Send token ----------------------------------------------------------------
        const issue_quantity = "10"
        const send_token_tx = {
            "TransactionType": "Payment",
            "Account": issuer_wallet.address,
            "Amount": {
                "currency": token,
                "value": issue_quantity,
                "issuer": issuer_wallet.address
            },
            "Destination": customer_wallet.address,
            "DestinationTag": 2
        }
    
        const pay_prepared = await client.autofill(send_token_tx)
        const ts_signed = issuer_wallet.sign(pay_prepared)

        const fee_xrp = xrpl.dropsToXrp(pay_prepared.Fee.toString())
        console.log(`FEE required: ${fee_xrp} XRP`)

        if (curr_xrp-fee_xrp<reserve_xrp){
            throw `Lack of XRP funds...`
        }

        console.log(`Sending ${issue_quantity} ${token} to ${customer_wallet.address}...`)
        console.log("Transfer tokens to customer...")
        const hst_result = await client.submitAndWait(ts_signed.tx_blob)

        if (hst_result.result.meta.TransactionResult == "tesSUCCESS") {
            console.log(`Transaction succeeded: https://testnet.xrpl.org/transactions/${ts_signed.hash}`)
        } else {
            throw `Error sending transaction: ${hst_result.result.meta.TransactionResult}`
        }

        console.log("Success.")

    } catch (error) {
        console.log(error)
        }
}

main()