"use client";
import { useCountStore } from "@/app/Store";
import Link from "next/link";
import React, { useEffect, useRef } from "react";
import Logo from "@/../public/Logo.svg";
import Image from "next/image";
import { usePathname } from "next/navigation";
import useHeight from "@/app/hooks/useHeight";
import { BaseError, ConnectButton, ErrorCode } from "@suiet/wallet-kit";

const Header = () => {
  const { Address, AddressUpdate } = useCountStore();
  const Url = usePathname();
  const height = useHeight();
  const pathName = usePathname();
  const BGMRef = useRef<HTMLAudioElement | null>(null);

  useEffect(() => {
    // Initialize BGM if not already initialized
    if (!BGMRef.current) {
      BGMRef.current = new Audio("/sounds/background.mp3");
      BGMRef.current.loop = true;
    }

    const handleBGM = () => {
      if (
        pathName === "/" ||
        pathName === "/load/gamestart/game" ||
        pathName === "/load"
      ) {
        return BGMRef.current?.pause();
      } else {
        return BGMRef.current?.play().catch((err) => {
          console.error("Failed to resume BGM:", err);
        });
      }
    };

    handleBGM();

    return () => {
      return BGMRef.current?.pause();
    };
  }, [Address, pathName]);
  return (
    <div
      className={`w-full h-[100px] z-10 sticky top-0 ${
        height > 100 ? " transition duration-300 ease-in-out bg-black/10" : null
      }`}
    >
      <div
        className={`flex w-full max-w-[1440px] items-center py-[10px] px-[20px] mx-auto justify-between `}
      >
        <Link href="/">
          <Image src={Logo} alt="LogoImage" />
        </Link>
        <div className="flex gap-[10px] items-center">
          {/* {Address ? (
            <div className=" flex gap-[40px] text-middle sm:hidden font-semibold text-white">
              <div>{Address.slice(0, 5) + "..."}</div>
            </div>
          ) : null} */}
          <ConnectButton
            onConnectError={(error: BaseError) => {
              if (
                error.code === ErrorCode.WALLET__CONNECT_ERROR__USER_REJECTED
              ) {
                console.warn(
                  "user rejected the connection to " + error.details?.wallet
                );
              } else {
                console.warn("unknown connect error: ", error);
              }
            }}
            onDisconnectSuccess={() => {
              AddressUpdate("");
            }}
          >
            Wallet Login
          </ConnectButton>
          {Url === "/" ? (
            <Link
              href="/load"
              className={` w-full transition duration-200 ease-in-out rounded-[10px] cursor-pointer bg-white text-black hover:bg-[#333] hover:text-white xl:w-[150px] md:w-[100px] h-[40px] flex items-center justify-center font-BMHANNA xl:text-[22px] md:text-[18px]${
                height > 500 ? " opacity-1" : " hidden"
              }`}
            >
              Get Start
            </Link>
          ) : null}
        </div>
      </div>
    </div>
  );
};

export default Header;
