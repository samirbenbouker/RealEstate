# Real Estate

## Description
This project is a decentralized application (DApp) designed to facilitate the buying and selling of real estate using blockchain technologies. The application utilizes smart contracts written in Solidity, managed and tested with Hardhat, and a user interface developed with React.

## Features
- Users can list properties for sale.
- Users can make offers on listed properties.
- Sellers can accept offers and complete the sale.
- Buyers can review transaction history.

## Technologies Used
- Solidity: To write the smart contracts that manage the application logic.
- Hardhat: To compile, test, and deploy the smart contracts in an Ethereum development environment.
- React: To develop the interactive and user-friendly user interface.
- Web3.js: To interact with the smart contracts from the user interface.

## Project Initialization

### Prerequisites
Make sure you have Node.js and npm installed on your system.

### Steps to Initialize the Project

1. **Clone the Repository**
   ```bash
   git clone https://github.com/samirbenbouker/RealEstate.git
   ```

2. **Install Dependencies**
   ```bash
   cd RealEstate
   npm install
   ```

3. **Set Up the Environment**
   - Create a `.env` file in the project root and configure the necessary environment variables, such as the Ethereum node URL and web3 service provider API keys.

4. **Compile the Smart Contracts**
   ```bash
   npx hardhat compile
   ```

5. **Deploy the Smart Contracts (Optional)**
   If you want to deploy the smart contracts on a test network or on the Ethereum mainnet, configure your `hardhat.config.js` file with your account information and target network, and then run:
   ```bash
   npx hardhat run scripts/deploy.js --network <network_name>
   ```

6. **Start hardhat node**
   ```bash
   npx hardhat node
   ```

7. **Start the Frontend Application**
   ```bash
   npm start
   ```

7. **Access the Application**
   Open your web browser and visit `http://localhost:3000` to interact with the application.

## Smart Contracts

### Escrow.sol

The Escrow contract handles transactions between buyers, sellers, and inspectors for property buying and selling. Here is an explanation of some of its main functions:

- `list(uint256 _nftId, address _buyer, uint256 _purchasePrice, uint256 _escrowAmount)`: This function allows the seller to list a property for sale, specifying the buyer, purchase price, and escrow amount.

- `depositeEarnest(uint256 _nftId)`: Buyers can deposit the required earnest money for the property they wish to purchase.

- `updateInspectionStatus(uint256 _nftId, bool _passed)`: This function allows the inspector to update the inspection status of a property.

- `approveSale(uint256 _nftId)`: Authorized participants can approve the sale of a property.

- `finalizeSale(uint256 _nftId)`: This function finalizes the sale of a property, transferring payment to the seller and the property to the buyer once all conditions are met.

- `cancelSale(uint256 _nftId)`: Allows canceling the sale of a property, handling the refund of earnest money if the inspection has not been approved.

