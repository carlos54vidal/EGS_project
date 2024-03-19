import type { Metadata } from "next";
// import { Inter } from "next/font/google";
import { Jost } from "next/font/google";
import "./globals.css";

export const jost = Jost({
  weight: ["300", "400", "500", "700"],
  subsets: ["latin"],
  display: "swap",
});

export const metadata: Metadata = {
  title: "Home - Booking Service",
  description: "Booking Service",
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="en">
      <body className={jost.className} cz-shortcut-listen="true">
        {children}
      </body>
    </html>
  );
}
