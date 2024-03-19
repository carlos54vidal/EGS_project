"use client";
import React, { useState, FormEvent } from "react";
import axios from "axios";

export default function SignUp({
  handleAlert,
}: {
  handleAlert: (open: boolean) => void;
}) {
  // State to hold the value of the text field
  const [companyName, setCompanyName] = useState("");

  // Event handler to update the state when the text field value changes
  const handleCompanyNameChange = (
    event: React.ChangeEvent<HTMLInputElement>
  ) => {
    setCompanyName(event.target.value);
  };

  // Event handler to handle form submission
  const handleSubmit = (event: FormEvent<HTMLFormElement>) => {
    event.preventDefault();
    registerClient(companyName)
      .then((status) => {
        console.log("Registration status:", status);
        setCompanyName(""); // reset field
        handleAlert(true); // Show success alert
      })
      .catch((error) => {
        console.error("Failed to register client:", error);
      });
  };

  // POST - Register client
  const registerClient = async (name: string): Promise<number> => {
    const url = "http://localhost:4001/v1/clients";
    const config = { "Content-Type": "application/json" };

    try {
      const data = { clientName: name };
      await axios.post(url, data, { headers: config });
      // If the request is successful, return status code 200
      return 200;
    } catch (error: unknown) {
      if (axios.isAxiosError(error)) {
        if (error.response) {
          // If there's an error response, return the status code from it
          return error.response.status;
        }
      }
      console.error("Error registering client.", error);
      // Default to 500 if no status is available
      return 500;
    }
  };

  return (
    <>
      {/* Render success alert if showSuccess is true */}
      <div className="flex min-h-full flex-1 flex-col justify-center px-6 py-12 lg:px-8">
        <div className="sm:mx-auto sm:w-full sm:max-w-sm">
          <h2 className="text-center text-2xl font-bold leading-9 tracking-tight text-gray-900">
            Sign up for free
          </h2>
        </div>
        <div className="mt-10 sm:mx-auto sm:w-full sm:max-w-sm">
          <div className="bg-white rounded-lg shadow px-6 py-8">
            <form className="space-y-6" onSubmit={handleSubmit}>
              <div>
                <label
                  htmlFor="name"
                  className="block text-sm font-medium leading-6 text-gray-900"
                >
                  Company name
                </label>
                <div className="mt-2">
                  <input
                    id="name"
                    name="name"
                    type="text"
                    required
                    value={companyName}
                    onChange={handleCompanyNameChange}
                    className="block w-full rounded-md border-0 py-1.5 text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-2 focus:ring-inset focus:ring-indigo-600 sm:text-sm sm:leading-6 bg-white"
                  />
                </div>
              </div>

              <div>
                <button
                  type="submit"
                  className="flex w-full justify-center rounded-md bg-indigo-600 px-3 py-1.5 text-sm font-semibold leading-6 text-white shadow-sm hover:bg-indigo-500 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-600"
                >
                  Sign up
                </button>
              </div>
            </form>
            <p className="mt-10 text-center text-sm text-gray-500">
              Not a member?{" "}
              <a
                href="#"
                className="font-semibold leading-6 text-indigo-600 hover:text-indigo-500"
              >
                Start now for FREE !
              </a>
            </p>
          </div>
        </div>
      </div>
    </>
  );
}
