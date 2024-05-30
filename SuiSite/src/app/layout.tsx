import type { Metadata } from "next";
import { Inter } from "next/font/google";
import "./globals.css";
import { Analytics } from "@vercel/analytics/react";
import { SpeedInsights } from "@vercel/speed-insights/next";
import Providers from "./providers";

const inter = Inter({ subsets: ["latin"] });

export const metadata: Metadata = {
  title: "Pizzo",
  description: "Pizzo Ready Page",
  icons: {
    icon: "/favicon.png",
  },
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="en">
      <body className={inter.className}>
        <div className=" w-full h-full bg-Background-Image bg-cover bg-no-repeat">
          <Providers>{children}</Providers>
          <Analytics />
          <SpeedInsights />
        </div>
      </body>
    </html>
  );
}
