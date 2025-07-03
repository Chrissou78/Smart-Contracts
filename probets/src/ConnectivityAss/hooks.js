import React from "react";
import { Contract } from "@ethersproject/contracts";
import tokenAbi from "./tokenAbi.json";
import { tokenAddress } from "./environment";
import { ethers } from "ethers";
let walletAddress = "0x2Db96c4F203fBc13c98bBa428ba9E09B48543b0A";

const provider = new ethers.providers.JsonRpcProvider(
  "https://bsc-dataseed.binance.org/"
);

export const voidAccount = new ethers.VoidSigner(walletAddress, provider);
function useContract(address, ABI, signer) {
  return React.useMemo(() => {
    if (signer) {
      return new Contract(address, ABI, signer);
    } else {
      return new Contract(address, ABI, voidAccount);
    }
  }, [address, ABI, signer]);
}

export function useTokenContract(signer) {
  return useContract(tokenAddress, tokenAbi, signer);
}
