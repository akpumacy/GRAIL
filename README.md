# GRAIL Implementation/ Existing Architecture

GRAIL brings the existing Redimi solution to XRPL.

[Redimi](https://redimi.net) solution comprises of several modules where each module accomplishes a crucial task. Following is the list of these modules:

1. [Ethereum based smart contracts](/Solidity%20Smart%20Contracts/): solidity contracts to manage gift card functionalities
2. Mobile Wallet Application: allows customers to manage their gift cards, transactions and a lot more...
3. Platform Provider (PP) API: connects all modules together

For the purpose of demonstration, the gift cards can behave as a fungible tokens since they are partially redeemable and transferable. Therefore, a token can be created as shown in [Tokenomy](/XRP%20Scripts/1_Tokenomy/). For transfering of tokens, we have setup multiple wallets including a cold wallet. We have also added token transfer functionality to already available wallet management application as shown in [Wallet Management](/XRP%20Scripts/2_Account_Management/). This allows wallets to transfer tokens directly from the app.

## Ethereum <> XRPL Migration

The actual implementation of GRAIL use case on XRPL can be found under [GRAIL Use Case](/GRAIL%20Use%20Case/). The scripts (developed in JS) demonstrate the implementation plan of Redimi Gift Cards in form of Tokens. These scripts are integrated in the XRPL version of our PP API, developed using [STRAPI](https://strapi.io/), a headless content management system. The [*REST API documentation*](https://documenter.getpostman.com/view/12104204/2s93eVYZeV) for GRAIL implementation is also available.

Following sections describe further our existing solution and its sub-modules: 

## Mobile Wallet Application

The [mobile application](https://play.google.com/store/apps/details?id=com.redimigmbh.redimi) for customers, also known as Mobile Wallet allows customers to register/login and manage their existing gift cards, coupons and transactions. Furthermore, customers can also store 3rd party gift cards by scanning their QR/Barcodes and store receipts for budgeting. To improve user experience, customers can see their friends and family (already existing on Redimi) as contacts, making it easier to select recipients when transfering gift cards. When redeeming, customers can also choose the amount they wish to redeem from the gift card. A QR code is created with encrypted information regarding the gift card. This information also includes signature from the customer's wallet.

Retailers can simply scan this gift card which will redirect them to a redeem portal website.

<img src="https://github.com/akpumacy/GRAIL/blob/main/media/login.jpg" alt="Login Page" width="30%" height="30%"> <img src="https://github.com/akpumacy/GRAIL/blob/main/media/gift-cards.jpg" alt="Gift Card Management" width="30%" height="30%"> <img src="https://github.com/akpumacy/GRAIL/blob/main/media/redeem-portal.jpg" alt="Redeem Portal" width="30%" height="30%">

### Purchase Portal

To allow customers to purchase gift cards with easy and comfort, a [purchase portal](https://redimi.net/gift-cards) is setup on the Redimi's website where customers can choose a mall and amount of gift card they wish to purchase. Multiple payment methods are integrated at checkout for the ease of the customer.

## Payment Settlement using Monerium 

After customers redeem gift cards at several retailers, these amounts have to be summed up and transfered to the retailers' bank account. This is made possible by the help of Monerium's e-money solution. Using Monerium's API, the total amount calculated fir each retailer can be transfered from the Mall's Monerium account to the retailers' bank account automatically at regular predefined intervals.
