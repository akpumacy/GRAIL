const xrpl = require('xrpl')
const client = new xrpl.Client("wss://s.altnet.rippletest.net:51233")
const issuer_wallet = process.env.ISSUER_WALLET

async function main() {
    await client.connect()

    console.log({message:"client connected"})

    //----- create test wallet ---------------------------------
    const customer_wallet = xrpl.Wallet.generate()
    console.log({customer_wallet})

    /* // Create a wallet and fund it with the Testnet faucet:
    const fund_result = await client.fundWallet()
    const faucet_wallet = fund_result.wallet
    console.log(faucet_wallet) */

    //----- load issuer wallet
    const issuer_wallet = xrpl.Wallet.fromSeed(issuer_wallet) // Test secret; don't use for real
    console.log({issuer_wallet})

    //----- prepare transfer transaction ---------------------------------
    const prepared = await client.autofill({
    "TransactionType": "Payment",
    "Account": issuer_wallet.address,
    "Amount": xrpl.xrpToDrops("12"), //minimum required
    "Destination": customer_wallet.address
    })
    const max_ledger = prepared.LastLedgerSequence
    console.log("Prepared transaction instructions:", prepared)
    console.log("Transaction cost:", xrpl.dropsToXrp(prepared.Fee), "XRP")
    console.log("Transaction expires after ledger:", max_ledger)

    //----- sign prepared instructions ---------------------------------
    const signed = issuer_wallet.sign(prepared)
    console.log("Identifying hash:", signed.hash)
    console.log("Signed blob:", signed.tx_blob)

    //----- submit signed blob ---------------------------------
    const tx = await client.submitAndWait(signed.tx_blob)

    console.log("Transaction result:", tx.result.meta.TransactionResult)
    if (tx.result.meta.TransactionResult!="tesSUCCESS"){
        throw new Error('Wallet creation was not successful');
    }

    //----- check transaction results ---------------------------------
    console.log("Balance changes:", JSON.stringify(xrpl.getBalanceChanges(tx.result.meta), null, 2))

    const account_info = await client.request({
        command: "account_info",
        account: customer_wallet.address
        });
    console.log({account_info})

}

main()