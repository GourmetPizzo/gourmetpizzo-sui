"use client";
import { FC } from "react";
import "@suiet/wallet-kit/style.css";
import { WalletProvider } from "@suiet/wallet-kit";

const Providers: FC<any> = ({ children }) => {
  return <WalletProvider autoConnect={false}>{children}</WalletProvider>;
};

export default Providers;
