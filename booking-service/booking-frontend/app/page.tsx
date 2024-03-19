"use client";
import React, { useState } from "react";
import SignUp from "@/components/signUp";
import Image from "next/image";
import SuccessAlert from "@/components/successAlert";

export default function Home() {
  const [showSuccess, setShowSuccess] = useState(false);

  const handleAlert = (open: boolean) => {
    setShowSuccess(open);
  };

  const closeAlert = () => {
    setShowSuccess(false);
  };

  return (
    <>
      {showSuccess && <SuccessAlert close={closeAlert} />}{" "}
      <main className="flex min-h-screen flex-col items-center justify-between p-10">
        <div className="z-10 max-w-5xl w-full items-center justify-between font-mono text-sm lg:flex">
          <div className="fixed bottom-0 left-0 flex h-48 w-full items-end justify-center bg-gradient-to-t from-white via-white dark:from-black dark:via-black lg:static lg:h-auto lg:w-auto lg:bg-none">
            <h2 className="jost-title text-3xl">Booking Service</h2>
          </div>
        </div>

        <div className="absolute h-[300px] w-full sm:w-[480px] -translate-x-1/2 rounded-full bg-gradient-radial from-white to-transparent blur-2xl content-[''] dark:bg-gradient-to-br dark:from-transparent dark:to-blue-700 dark:opacity-10 lg:h-[360px] z-[-1]"></div>
        <div className="relative flex place-items-center w-full sm:w-[480px]">
          <SignUp handleAlert={handleAlert} />
        </div>

        <div className="mb-32 grid text-center lg:max-w-5xl lg:w-full lg:mb-0 lg:grid-cols-4 lg:text-left"></div>
      </main>
    </>
  );
}
