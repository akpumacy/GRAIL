const xrpl = require('xrpl')
const client = new xrpl.Client("wss://s.altnet.rippletest.net:51233")
const issuer_wallet = process.env.ISSUER_WALLET
const grail_token = process.env.GRAIL_TOKEN

async function main() {
    await client.connect()

    //----- load issuer wallet
    const issuer_wallet = xrpl.Wallet.fromSeed(issuer_wallet) // Test secret; don't use for real
    console.log({issuer_wallet})

    //----- load customer wallet
    const customer_wallet = xrpl.Wallet.fromSeed("sEdTzcsZesDc1gd5z893A4uyj3wEw2o") // Test secret; don't use for real
    console.log({customer_wallet})

    //----- Create trust line from customer to issuer wallet address ---------------------------------
    const trust_set_tx = {
        "TransactionType": "TrustSet",
        "Account": customer_wallet.address,
        "LimitAmount": {
            "currency": grail_token,
            "issuer": issuer_wallet.address,
            "value": "10000000000" // Large limit, arbitrarily chosen
        }
    }

    const ts_prepared = await client.autofill(trust_set_tx)
    const ts_signed = customer_wallet.sign(ts_prepared)

    console.log("Creating trust line from User address to issuer...")
    const tx = await client.submitAndWait(ts_signed.tx_blob)

    console.log("Transaction result:", tx.result.meta.TransactionResult)

    if (tx.result.meta.TransactionResult!="tesSUCCESS"){
        throw new Error('Trustline setup was not successful');
    }

}

main()