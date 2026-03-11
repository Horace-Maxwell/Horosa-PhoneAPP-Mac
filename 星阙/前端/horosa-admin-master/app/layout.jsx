import * as React from "react";
import { Inter } from "next/font/google";
import AuthorizerProvider from "@/providers/authorizer-provider"
import "@/styles/globals.css";
import "@/styles/normalize.css";

const inter = Inter({ subsets: ["latin"] });

export const metadata = {
  title: "Horosa App MS",
  description: "Horosa App Management System",
};

export default function RootLayout({ children }) {
  return (
    <html lang="en">
      <body className={inter.className}>
        <React.Suspense>
          <AuthorizerProvider>
            {children}
          </AuthorizerProvider>
        </React.Suspense>
      </body>
    </html>
  );
}
