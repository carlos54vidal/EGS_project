import React from "react";

export default function successAlert({ close }: { close: () => void }) {
  React.useEffect(() => {
    const timer = setTimeout(() => {
      close(); // Call the onClose function after 4 seconds
    }, 4000);

    return () => clearTimeout(timer); // Clear the timer on component unmount
  }, [close]);

  return (
    <div className="fixed top-10 right-10 z-50">
      {/* Centering horizontally at the top */}
      <div
        className="bg-green-100 border border-green-400 text-green-700 px-10 py-4 rounded relative"
        role="alert"
      >
        <strong className="font-bold">Success!</strong>
        <span className="block sm:inline">
          {"  "} Client successfully registered.
        </span>
        <span
          className="absolute top-0 right-0 bottom-0 px-1 py-4"
          onClick={() => {
            close();
          }}
        >
          {/* Positioned at the end */}
          <svg
            className="fill-current h-6 w-6 text-green-500"
            role="button"
            xmlns="http://www.w3.org/2000/svg"
            viewBox="0 0 20 20"
          >
            <title>Close</title>
            <path d="M14.348 14.849a1.2 1.2 0 0 1-1.697 0L10 11.819l-2.651 3.029a1.2 1.2 0 1 1-1.697-1.697l2.758-3.15-2.759-3.152a1.2 1.2 0 1 1 1.697-1.697L10 8.183l2.651-3.031a1.2 1.2 0 1 1 1.697 1.697l-2.758 3.152 2.758 3.15a1.2 1.2 0 0 1 0 1.698z" />
          </svg>
        </span>
      </div>
    </div>
  );
}
