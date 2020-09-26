import React from "react";
import { newContextComponents } from "@drizzle/react-components";
import logo from "./logo.png";

const { AccountData, ContractData, ContractForm } = newContextComponents;

export default ({ drizzle, drizzleState }) => {
  // destructure drizzle and drizzleState from props
  return (
    <div className="App">
      <div>
        <img src={logo} alt="drizzle-logo" />
        <h1>VATZCAR SMART CONTRACT</h1>
        <p>
          DEMONSTRATION OF ASSET TRANSFER
        </p>
      </div>

      <div className="section">
        <h2>Your Present Active Account & its Balance is :</h2>
        <AccountData
          drizzle={drizzle}
          drizzleState={drizzleState}
          accountIndex={0}
          units="ether"
          precision={0}
        />
      </div>

      <div className="section">
        <h2>Vatzcar Asset transfer</h2>
        <p>
        A blockchain contract for storing and sharing data and other parameter of an asset.
        </p>
        <p>
          <strong>Lets create an asset! </strong>
        </p>
        <ContractForm 
        drizzle={drizzle} 
        contract="Asset" 
        method="createAsset" 
        labels={["Name of Car.", "ETH Address of Owner" , "Other Details" , "Year of Manufacture"]}
        />
        <p>
          <strong>Lets transfer the asset! </strong>
        </p>
          <ContractForm
          drizzle={drizzle}
          drizzleState={drizzleState}
          contract="Asset"
          method="transferAsset"
          labels={["Name of New Owner", "ETH Address of New Owner" , "Asset No." ]}
          />
        <p>
          <strong>Now we will view the trail of ownership! </strong>
        </p>
          <ContractForm
          drizzle={drizzle}
          drizzleState={drizzleState}
          contract="Asset"
          method="viewTrail"
          labels={["Asset No." ]}
          //methodArgs={["assetNo"]}
          />
        <p>
          <strong>We can give View Access for a limited period of time (in seconds) to third Party </strong>
        </p>
          <ContractForm
          drizzle={drizzle}
          drizzleState={drizzleState}
          contract="Asset"
          method="giveViewAccess"
          labels={["AssetNo" , " ETH Address Third Party" , "Time in seconds"]}
          />
        <p>
          <strong>Third party can view Asset Data for a limited period of time (in seconds) </strong>
        </p>
          <ContractForm
          drizzle={drizzle}
          drizzleState={drizzleState}
          contract="Asset"
          method="viewAssetDetail"
          labels={["AssetNo"]}
          />        
      </div>
    </div>
  );
};
