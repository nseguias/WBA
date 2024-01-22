import { getFullnodeUrl, SuiClient } from "@mysten/sui.js/client";
import { Ed25519Keypair } from "@mysten/sui.js/keypairs/ed25519";
import { bcs} from "@mysten/sui.js/bcs";
import { TransactionBlock } from '@mysten/sui.js/transactions';
import wallet from "../.env/wba-wallet.json";
import { fromHEX } from "@mysten/bcs";

const enrollment_object_id = "";
const cohort = "";

// We're going to import our keypair from the wallet file
const keypair = Ed25519Keypair.fromSecretKey(fromHEX(wallet.privateKey));

// Create a devnet client
const client = new SuiClient({ url: getFullnodeUrl("devnet") });

const txb = new TransactionBlock();

// Github account
const github = new Uint8Array(Buffer.from("-your github account-"));
let serialized_github = txb.pure(bcs.vector(bcs.u8()).serialize(github));

let enroll = txb.moveCall({
    target: `${enrollment_object_id}::enrollment::enroll`,
    arguments: [serialized_github, txb.object(cohort)],
});

(async () => {
    let txid = await client.signAndExecuteTransactionBlock({ signer: keypair, transactionBlock: txb });
    console.log(`Success! Check our your TX here:
https://suiexplorer.com/txblock/${txid.digest}?network=devnet`);
})();
