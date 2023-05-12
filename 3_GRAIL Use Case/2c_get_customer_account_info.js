const xrpl = require('xrpl')
const client = new xrpl.Client("wss://s.altnet.rippletest.net:51233")

const dotenv = require('dotenv')
dotenv.config({ path: `H:/Pumacy/Programs/redimi/XRP/GRAIL/3_GRAIL Use Case/.env`, override: true });

const issuer_wallet_seed = process.env.ISSUER_WALLET_SEED
const customer_wallet_seed = "sEdS1kJ7iMwzFNrhU3UVsDJSzqEr5iz"
const token = process.env.GRAIL_TOKEN

async function main() {
    try{
        await client.connect()

        console.log("client connected")

        //----- load customer wallet
        const customer_wallet = xrpl.Wallet.fromSeed(customer_wallet_seed) // Test secret; don't use for real
        console.log(`Customer Wallet Address: ${customer_wallet.address}`)
        const customer_balance = await client.getXrpBalance(customer_wallet.address)
        console.log(`Customer Wallet XRP Balance: ${customer_balance}`);

        const account_info = await client.request({
            command: "account_info",
            account: customer_wallet.address
            });
        console.log(account_info.result)

        const hot_balances = await client.request({
            command: "account_lines",
            account: customer_wallet.address,
            ledger_index: "validated"
          })
        console.log(hot_balances.result)

        const n_lines = hot_balances.result.lines.length
        console.log(`Reserve: ${10+(n_lines*2)}`)

        const X_balances = await client.request({
            command: "account_info",
            account: "X7Z9WgTrQ8267Yoz9LhZJviKBN45jRM8xH9iudJcL42tj5N"
          })
        console.log(X_balances.result)

    } catch (error) {
        console.log(error)
        }
}

main()