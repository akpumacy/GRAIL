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

        //----- load customer wallet
        const customer_wallet = xrpl.Wallet.fromSeed(customer_wallet_seed) // Test secret; don't use for real
        console.log(`Customer Wallet Address: ${customer_wallet.address}`)
        const customer_balance = await client.getXrpBalance(customer_wallet.address)
        console.log(`Customer Wallet XRP Balance: ${customer_balance}`);

        //----- Create trust line from customer to issuer wallet address ---------------------------------
        const trust_set_tx = {
            "TransactionType": "TrustSet",
            "Account": customer_wallet.address,
            "LimitAmount": {
                "currency": token,
                "issuer": issuer_wallet.address,
                "value": "10000000000" // Large limit, arbitrarily chosen
            }
        }

        const ts_prepared = await client.autofill(trust_set_tx)
        const ts_signed = customer_wallet.sign(ts_prepared)

        console.log("Creating trust line from User address to issuer...")
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