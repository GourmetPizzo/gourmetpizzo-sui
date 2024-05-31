"use client";
import React, { useEffect, useRef } from "react";
import { useCountStore } from "../Store";
import Link from "next/link";
import Image from "next/image";
import Icon from "@/../public/WalletPageIcon.png";
import { ButtonBrownBorder, ButtonFontGradient, Center } from "../Style";
import axios from "axios";
import {
  BaseError,
  ConnectButton,
  ErrorCode,
  useAccountBalance,
  useWallet,
} from "@suiet/wallet-kit";

const Page = () => {
  const { Address, AddressUpdate, BalanceUpdate } = useCountStore();
  const wallet = useWallet();
  const { balance } = useAccountBalance();
  const click = useRef<HTMLAnchorElement>(null);

  useEffect(() => {
    const handleAddress = async () => {
      AddressUpdate(`${wallet.address}`);
      const data = {
        User_Address: wallet.address,
      };
      const Access_Token: string = await axios
        .post("/api/userlogin", data)
        .then((res) => {
          return res.headers.access_token;
        });

      localStorage.setItem("Access_Token", Access_Token);

      axios.defaults.headers.common["Authorization"] = `${Access_Token}`;
      BalanceUpdate(Number(balance));
    };
    if (wallet.address) {
      handleAddress();
    }
  }, [wallet.address, AddressUpdate]);

  useEffect(() => {
    const handleLink = () => {
      click.current?.click();
    };

    if (Address) {
      handleLink();
    }
  }, [Address]);

  return (
    <div className=" w-full h-full flex flex-col justify-center items-center">
      <Image
        src={Icon}
        alt="WalletIconImage"
        className=" mb-[56px] md:w-[150px] md:h-[150px]"
      />

      <div
        // onClick={handleClick}
        className={`xl:text-[50px] md:text-[40px] sm:text-[30px] bg-ButtonImage bg-cover xl:max-w-[600px] md:max-w-[300px] max-w-[250px] w-full xl:h-[100px] md:h-[80px] sm:h-[60px] font-semibold rounded-[10px] cursor-pointer ${ButtonBrownBorder} ${Center}`}
      >
        <div className={` font-BMHANNA ${ButtonFontGradient}`}>
          WALLET LOGIN PLZ!!
        </div>
      </div>
      <Link href="/load/gamestart" ref={click} className="hidden" />
    </div>
  );
};

export default Page;
