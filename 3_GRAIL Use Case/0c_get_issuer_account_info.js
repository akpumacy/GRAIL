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

        //----- load issuer wallet
        const issuer_wallet = xrpl.Wallet.fromSeed(issuer_wallet_seed) // Test secret; don't use for real
        console.log(`Issuer Wallet Address: ${issuer_wallet.address}`)
        const my_balance = await client.getXrpBalance(issuer_wallet.address)
        console.log(`Issuer Wallet XRP Balance: ${my_balance}`);

        const account_info = await client.request({
            command: "account_info",
            account: issuer_wallet.address
            });
        console.log(account_info.result)

        const cold_balances = await client.request({
            command: "account_lines",
            account: issuer_wallet.address,
            ledger_index: "validated"
          })
        console.log(cold_balances.result)

        const n_lines = cold_balances.result.lines.length
        console.log(`Reserve: ${10+(n_lines*2)}`)

    } catch (error) {
        console.log(error)
        }
}

main()